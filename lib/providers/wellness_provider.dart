import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wellness state for tracking user wellness activities
class WellnessState {
  final int currentStreak;
  final int totalMeditationMinutes;
  final int weeklyCheckIns;
  final bool isMorningRoutine;
  final int? todayMood; // 1-5 scale
  final DateTime? lastCheckInDate;
  final bool isLoading;

  const WellnessState({
    this.currentStreak = 0,
    this.totalMeditationMinutes = 0,
    this.weeklyCheckIns = 0,
    this.isMorningRoutine = true,
    this.todayMood,
    this.lastCheckInDate,
    this.isLoading = false,
  });

  WellnessState copyWith({
    int? currentStreak,
    int? totalMeditationMinutes,
    int? weeklyCheckIns,
    bool? isMorningRoutine,
    int? todayMood,
    DateTime? lastCheckInDate,
    bool? isLoading,
    bool clearMood = false,
  }) {
    return WellnessState(
      currentStreak: currentStreak ?? this.currentStreak,
      totalMeditationMinutes: totalMeditationMinutes ?? this.totalMeditationMinutes,
      weeklyCheckIns: weeklyCheckIns ?? this.weeklyCheckIns,
      isMorningRoutine: isMorningRoutine ?? this.isMorningRoutine,
      todayMood: clearMood ? null : (todayMood ?? this.todayMood),
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

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

  Future<void> _loadFromStorage() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final streak = prefs.getInt(_streakKey) ?? 0;
      final meditation = prefs.getInt(_meditationKey) ?? 0;
      final checkIns = prefs.getInt(_checkInsKey) ?? 0;
      final lastCheckInStr = prefs.getString(_lastCheckInKey);
      final mood = prefs.getInt(_moodKey);

      DateTime? lastCheckIn;
      if (lastCheckInStr != null) {
        lastCheckIn = DateTime.tryParse(lastCheckInStr);
      }

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

    state = state.copyWith(
      todayMood: mood,
      currentStreak: newStreak,
      weeklyCheckIns: newCheckIns,
      lastCheckInDate: today,
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

/// Meditation timer state
class MeditationTimerState {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isComplete;

  const MeditationTimerState({
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.isRunning = false,
    this.isComplete = false,
  });

  MeditationTimerState copyWith({
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isComplete,
  }) {
    return MeditationTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isComplete: isComplete ?? this.isComplete,
    );
  }

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

/// Meditation timer provider
final meditationTimerProvider = StateProvider<MeditationTimerState>(
  (ref) => const MeditationTimerState(),
);
