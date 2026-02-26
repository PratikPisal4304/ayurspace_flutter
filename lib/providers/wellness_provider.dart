import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sources/wellness_data.dart';

// ============================================================
// WELLNESS STATE
// ============================================================

/// Wellness state for tracking user wellness activities
class WellnessState {
  final int currentStreak;
  final int totalMeditationMinutes;
  final int weeklyCheckIns;
  final bool isMorningRoutine;
  final int? todayMood; // 1-5 scale
  final List<int> moodHistory; // last 7 days moods
  final DateTime? lastCheckInDate;
  final bool isLoading;

  const WellnessState({
    this.currentStreak = 0,
    this.totalMeditationMinutes = 0,
    this.weeklyCheckIns = 0,
    this.isMorningRoutine = true,
    this.todayMood,
    this.moodHistory = const [],
    this.lastCheckInDate,
    this.isLoading = false,
  });

  WellnessState copyWith({
    int? currentStreak,
    int? totalMeditationMinutes,
    int? weeklyCheckIns,
    bool? isMorningRoutine,
    int? todayMood,
    List<int>? moodHistory,
    DateTime? lastCheckInDate,
    bool? isLoading,
    bool clearMood = false,
  }) {
    return WellnessState(
      currentStreak: currentStreak ?? this.currentStreak,
      totalMeditationMinutes:
          totalMeditationMinutes ?? this.totalMeditationMinutes,
      weeklyCheckIns: weeklyCheckIns ?? this.weeklyCheckIns,
      isMorningRoutine: isMorningRoutine ?? this.isMorningRoutine,
      todayMood: clearMood ? null : (todayMood ?? this.todayMood),
      moodHistory: moodHistory ?? this.moodHistory,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ============================================================
// WELLNESS NOTIFIER
// ============================================================

/// Wellness notifier for managing wellness state
class WellnessNotifier extends StateNotifier<WellnessState> {
  WellnessNotifier() : super(const WellnessState()) {
    _loadFromStorage();
  }

  static const _streakKey = 'wellness_streak';
  static const _meditationKey = 'meditation_minutes';
  static const _checkInsKey = 'weekly_check_ins';
  static const _lastCheckInKey = 'last_check_in';
  static const _moodKey = 'today_mood';
  static const _moodHistoryKey = 'mood_history';

  Future<void> _loadFromStorage() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final streak = prefs.getInt(_streakKey) ?? 0;
      final meditation = prefs.getInt(_meditationKey) ?? 0;
      final checkIns = prefs.getInt(_checkInsKey) ?? 0;
      final lastCheckInStr = prefs.getString(_lastCheckInKey);
      final mood = prefs.getInt(_moodKey);
      final moodHistoryStr = prefs.getStringList(_moodHistoryKey) ?? [];

      DateTime? lastCheckIn;
      if (lastCheckInStr != null) {
        lastCheckIn = DateTime.tryParse(lastCheckInStr);
      }

      // Parse mood history
      final moodHistory =
          moodHistoryStr.map((s) => int.tryParse(s) ?? 3).toList();

      // Check if streak should reset (missed a day)
      final today = DateTime.now();
      int currentStreak = streak;
      if (lastCheckIn != null) {
        final daysDiff = today.difference(lastCheckIn).inDays;
        if (daysDiff > 1) {
          currentStreak = 0; // Reset streak if more than 1 day missed
          await prefs.setInt(_streakKey, 0);
        }
      }

      state = state.copyWith(
        currentStreak: currentStreak,
        totalMeditationMinutes: meditation,
        weeklyCheckIns: checkIns,
        lastCheckInDate: lastCheckIn,
        todayMood: mood,
        moodHistory: moodHistory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Toggle between morning and evening routine
  void toggleRoutine() {
    state = state.copyWith(isMorningRoutine: !state.isMorningRoutine);
  }

  /// Log a mood check-in (1-5 scale)
  Future<void> logMood(int mood) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];

    // Check if already checked in today
    final lastCheckIn = state.lastCheckInDate;
    final isNewDay = lastCheckIn == null ||
        lastCheckIn.toIso8601String().split('T')[0] != todayStr;

    int newStreak = state.currentStreak;
    int newCheckIns = state.weeklyCheckIns;

    if (isNewDay) {
      newStreak = state.currentStreak + 1;
      newCheckIns = state.weeklyCheckIns + 1;
      await prefs.setInt(_streakKey, newStreak);
      await prefs.setInt(_checkInsKey, newCheckIns);
      await prefs.setString(_lastCheckInKey, today.toIso8601String());
    }

    await prefs.setInt(_moodKey, mood);

    // Update mood history (keep last 7 days)
    final updatedHistory = List<int>.from(state.moodHistory);
    if (isNewDay) {
      updatedHistory.add(mood);
      if (updatedHistory.length > 7) {
        updatedHistory.removeAt(0);
      }
    } else if (updatedHistory.isNotEmpty) {
      updatedHistory[updatedHistory.length - 1] = mood;
    } else {
      updatedHistory.add(mood);
    }
    await prefs.setStringList(
        _moodHistoryKey, updatedHistory.map((m) => m.toString()).toList());

    state = state.copyWith(
      todayMood: mood,
      currentStreak: newStreak,
      weeklyCheckIns: newCheckIns,
      lastCheckInDate: today,
      moodHistory: updatedHistory,
    );
  }

  /// Add meditation minutes
  Future<void> addMeditationMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalMeditationMinutes + minutes;
    await prefs.setInt(_meditationKey, newTotal);
    state = state.copyWith(totalMeditationMinutes: newTotal);
  }

  /// Reset weekly stats (call on Sunday)
  Future<void> resetWeeklyStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_checkInsKey, 0);
    state = state.copyWith(weeklyCheckIns: 0);
  }
}

/// Wellness provider
final wellnessProvider = StateNotifierProvider<WellnessNotifier, WellnessState>(
  (ref) => WellnessNotifier(),
);

/// Currently playing sound provider (null if nothing playing)
final playingSoundProvider = StateProvider<String?>((ref) => null);

// ============================================================
// MEDITATION TIMER (Background-Safe)
// ============================================================

/// Meditation timer state
class MeditationTimerState {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isComplete;
  final DateTime? _endTime; // Background-safe anchor

  const MeditationTimerState({
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.isRunning = false,
    this.isComplete = false,
    DateTime? endTime,
  }) : _endTime = endTime;

  MeditationTimerState copyWith({
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isComplete,
    DateTime? endTime,
    bool clearEndTime = false,
  }) {
    return MeditationTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isComplete: isComplete ?? this.isComplete,
      endTime: clearEndTime ? null : (endTime ?? _endTime),
    );
  }

  DateTime? get endTime => _endTime;

  String get formattedTime {
    final mins = remainingSeconds ~/ 60;
    final secs = remainingSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / totalSeconds);
  }
}

/// Meditation Timer Notifier - handles all timer logic
/// Uses endTime anchor for background-safe countdown
class MeditationTimerNotifier extends StateNotifier<MeditationTimerState> {
  final Ref _ref;
  Timer? _timer;

  MeditationTimerNotifier(this._ref) : super(const MeditationTimerState());

  /// Start meditation timer with specified minutes
  void startMeditation(int minutes) {
    _timer?.cancel();

    final totalSeconds = minutes * 60;
    final endTime = DateTime.now().add(Duration(seconds: totalSeconds));

    state = MeditationTimerState(
      remainingSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      isRunning: true,
      isComplete: false,
      endTime: endTime,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    final endTime = state.endTime;
    if (endTime == null) {
      timer.cancel();
      return;
    }

    final remaining = endTime.difference(DateTime.now()).inSeconds;

    if (remaining <= 0) {
      // Timer complete
      timer.cancel();
      _timer = null;

      final minutes = state.totalSeconds ~/ 60;
      _ref.read(wellnessProvider.notifier).addMeditationMinutes(minutes);

      state = state.copyWith(
        remainingSeconds: 0,
        isRunning: false,
        isComplete: true,
        clearEndTime: true,
      );
    } else {
      state = state.copyWith(remainingSeconds: remaining);
    }
  }

  /// Recalculate remaining time after returning from background
  void recalculateFromBackground() {
    final endTime = state.endTime;
    if (endTime == null || !state.isRunning) return;

    final remaining = endTime.difference(DateTime.now()).inSeconds;
    if (remaining <= 0) {
      _timer?.cancel();
      _timer = null;
      final minutes = state.totalSeconds ~/ 60;
      _ref.read(wellnessProvider.notifier).addMeditationMinutes(minutes);
      state = state.copyWith(
        remainingSeconds: 0,
        isRunning: false,
        isComplete: true,
        clearEndTime: true,
      );
    } else {
      state = state.copyWith(remainingSeconds: remaining);
    }
  }

  /// Stop the meditation timer
  void stopMeditation() {
    _timer?.cancel();
    _timer = null;
    state = const MeditationTimerState();
  }

  /// Pause the meditation timer
  void pauseMeditation() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  /// Resume the meditation timer
  void resumeMeditation() {
    if (state.remainingSeconds > 0 && !state.isRunning) {
      // Re-anchor the endTime to now + remaining
      final newEnd =
          DateTime.now().add(Duration(seconds: state.remainingSeconds));
      state = state.copyWith(isRunning: true, endTime: newEnd);
      _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    }
  }

  /// Reset completion status (after showing dialog)
  void acknowledgeCompletion() {
    state = const MeditationTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Meditation timer provider
final meditationTimerProvider =
    StateNotifierProvider<MeditationTimerNotifier, MeditationTimerState>(
  (ref) => MeditationTimerNotifier(ref),
);

// ============================================================
// AYURVEDIC TIME & SEASON PROVIDERS
// ============================================================

/// Provider for the current Ayurvedic time period (Kapha/Pitta/Vata)
final ayurvedicTimePeriodProvider = Provider<String>((ref) {
  return WellnessData.getAyurvedicTimePeriod(DateTime.now().hour);
});

/// Provider for the current Ayurvedic season (Ritucharya)
final currentSeasonProvider = Provider<String>((ref) {
  return WellnessData.getCurrentSeason(DateTime.now().month);
});

/// Provider for the current season's details
final currentSeasonDetailsProvider = Provider<Map<String, dynamic>?>((ref) {
  final season = ref.watch(currentSeasonProvider);
  return WellnessData.seasonalDetails[season];
});

/// Provider for the time-based greeting
final ayurvedicGreetingProvider = Provider<Map<String, String>>((ref) {
  return WellnessData.getTimeGreeting(DateTime.now().hour);
});

/// Provider for the time-based smart suggestion
final ayurvedicTimeSuggestionProvider = Provider<Map<String, String>>((ref) {
  return WellnessData.getTimeSuggestion(DateTime.now().hour);
});
