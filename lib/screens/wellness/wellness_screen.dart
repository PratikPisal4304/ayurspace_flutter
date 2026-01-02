import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/sources/wellness_data.dart';
import '../../providers/wellness_provider.dart';

class WellnessScreen extends ConsumerStatefulWidget {
  const WellnessScreen({super.key});

  @override
  ConsumerState<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends ConsumerState<WellnessScreen> {
  Timer? _meditationTimer;

  @override
  void dispose() {
    _meditationTimer?.cancel();
    super.dispose();
  }

  void _startMeditation(int minutes) {
    final totalSeconds = minutes * 60;
    ref.read(meditationTimerProvider.notifier).state = MeditationTimerState(
      remainingSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      isRunning: true,
      isComplete: false,
    );

    _meditationTimer?.cancel();
    _meditationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = ref.read(meditationTimerProvider);
      if (current.remainingSeconds <= 1) {
        timer.cancel();
        ref.read(meditationTimerProvider.notifier).state = current.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          isComplete: true,
        );
        ref.read(wellnessProvider.notifier).addMeditationMinutes(minutes);
        _showCompletionDialog();
      } else {
        ref.read(meditationTimerProvider.notifier).state = current.copyWith(
          remainingSeconds: current.remainingSeconds - 1,
        );
      }
    });
  }

  void _stopMeditation() {
    _meditationTimer?.cancel();
    ref.read(meditationTimerProvider.notifier).state = const MeditationTimerState();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            const SizedBox(height: 16),
            Text('Session Complete!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Great job on your meditation practice.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wellnessState = ref.watch(wellnessProvider);
    final timerState = ref.watch(meditationTimerProvider);
    final playingSound = ref.watch(playingSoundProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Wellness Hub', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: DesignTokens.spacingXs),
              Text('Your daily Ayurvedic practices', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: DesignTokens.spacingLg),

              // Streak Card
              _buildStreakCard(wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // Mood Check-in
              _buildMoodCheckIn(wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // Progress Stats
              _buildProgressStats(wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // Morning/Evening Toggle
              _buildRoutineToggle(wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // Daily Routine Section
              _buildRoutineSection(wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // Quick Meditation Timer
              _buildMeditationSection(timerState),
              const SizedBox(height: DesignTokens.spacingMd),

              // Sleep Sounds
              _buildSleepSoundsSection(playingSound),
              const SizedBox(height: DesignTokens.spacingMd),

              // Dosha Balance Cards
              Text('Balance Your Dosha', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DesignTokens.spacingSm),
              Row(
                children: [
                  _buildDoshaCard('Vata', AppColors.vata),
                  const SizedBox(width: DesignTokens.spacingSm),
                  _buildDoshaCard('Pitta', AppColors.pitta),
                  const SizedBox(width: DesignTokens.spacingSm),
                  _buildDoshaCard('Kapha', AppColors.kapha),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // Seasonal Wisdom
              _buildSection('Seasonal Wisdom', Icons.eco, AppColors.primary,
                WellnessData.seasonalWisdom.map((s) => s['en']!).toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(WellnessState state) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.saffron, AppColors.saffron.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🔥', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.currentStreak} Day Streak!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.currentStreak == 0
                      ? 'Start your wellness journey today'
                      : 'Keep it up! You\'re doing great.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCheckIn(WellnessState state) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_emotions, color: AppColors.lotusPink),
              const SizedBox(width: 8),
              Text('How are you feeling?', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: WellnessData.moodOptions.map((mood) {
              final isSelected = state.todayMood == mood['value'];
              return GestureDetector(
                onTap: () => ref.read(wellnessProvider.notifier).logMood(mood['value'] as int),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                  ),
                  child: Column(
                    children: [
                      Text(mood['emoji'] as String, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        mood['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStats(WellnessState state) {
    return Row(
      children: [
        _buildStatCard('🧘', '${state.totalMeditationMinutes}', 'Mins Meditated'),
        const SizedBox(width: DesignTokens.spacingSm),
        _buildStatCard('✅', '${state.weeklyCheckIns}', 'This Week'),
        const SizedBox(width: DesignTokens.spacingSm),
        _buildStatCard('🔥', '${state.currentStreak}', 'Day Streak'),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingSm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 1))],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineToggle(WellnessState state) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!state.isMorningRoutine) ref.read(wellnessProvider.notifier).toggleRoutine();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: state.isMorningRoutine ? AppColors.saffron : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, color: state.isMorningRoutine ? Colors.white : AppColors.textSecondary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Morning',
                      style: TextStyle(
                        color: state.isMorningRoutine ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (state.isMorningRoutine) ref.read(wellnessProvider.notifier).toggleRoutine();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !state.isMorningRoutine ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.nightlight_round, color: !state.isMorningRoutine ? Colors.white : AppColors.textSecondary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Evening',
                      style: TextStyle(
                        color: !state.isMorningRoutine ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineSection(WellnessState state) {
    final routineItems = state.isMorningRoutine
        ? WellnessData.dailyRoutine
        : WellnessData.eveningRoutine;
    final title = state.isMorningRoutine ? 'Morning Routine (Dinacharya)' : 'Evening Routine (Ratricharya)';
    final icon = state.isMorningRoutine ? Icons.wb_sunny : Icons.nightlight_round;
    final color = state.isMorningRoutine ? AppColors.saffron : AppColors.primary;

    return _buildSection(title, icon, color, routineItems.map((r) => r['en']!).toList());
  }

  Widget _buildMeditationSection(MeditationTimerState timerState) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.lotusPink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.self_improvement, color: AppColors.lotusPink),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text('Quick Meditation', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          if (timerState.isRunning) ...[
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: timerState.progress,
                            strokeWidth: 8,
                            backgroundColor: AppColors.surfaceVariant,
                            color: AppColors.lotusPink,
                          ),
                        ),
                        Text(
                          timerState.formattedTime,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  ElevatedButton.icon(
                    onPressed: _stopMeditation,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [5, 10, 15].map((mins) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => _startMeditation(mins),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.lotusPink),
                      ),
                      child: Text('$mins min'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSleepSoundsSection(String? playingSound) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bedtime, color: Colors.indigo),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text('Sleep Sounds', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: WellnessData.sleepSounds.map((sound) {
              final color = Color(int.parse(sound['color']!));
              final isPlaying = playingSound == sound['name'];
              return GestureDetector(
                onTap: () {
                  if (isPlaying) {
                    ref.read(playingSoundProvider.notifier).state = null;
                  } else {
                    ref.read(playingSoundProvider.notifier).state = sound['name'];
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isPlaying ? color : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: color),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: isPlaying ? Colors.white : color,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        sound['name']!,
                        style: TextStyle(
                          color: isPlaying ? Colors.white : color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (playingSound != null) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            Center(
              child: Text(
                '🎵 Now playing: $playingSound',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: color, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDoshaCard(String dosha, Color color) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/dosha-quiz'),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(dosha, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Balance tips', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
