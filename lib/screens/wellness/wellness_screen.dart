import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/sources/wellness_data.dart';
import '../../providers/wellness_provider.dart';
import '../../l10n/app_strings.dart';
import '../../providers/user_provider.dart';

class WellnessScreen extends ConsumerWidget {
  const WellnessScreen({super.key});

  void _showCompletionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: AppColors.success, size: 56),
            ),
            const SizedBox(height: 16),
            Text('Namaste! 🙏',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Your meditation session is complete.\nMay peace guide your day.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(meditationTimerProvider.notifier)
                    .acknowledgeCompletion();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wellnessState = ref.watch(wellnessProvider);
    final timerState = ref.watch(meditationTimerProvider);
    final playingSound = ref.watch(playingSoundProvider);
    final lang = ref.watch(userProfileProvider)?.settings.language ?? 'en';
    final userProfile = ref.watch(userProfileProvider);
    final dominantDosha = userProfile?.doshaResult?.dominant.displayName;

    final greeting = ref.watch(ayurvedicGreetingProvider);
    final timeSuggestion = ref.watch(ayurvedicTimeSuggestionProvider);
    final currentSeason = ref.watch(currentSeasonProvider);
    final seasonDetails = ref.watch(currentSeasonDetailsProvider);

    // Listen for meditation completion
    ref.listen<MeditationTimerState>(meditationTimerProvider, (previous, next) {
      if (next.isComplete && !(previous?.isComplete ?? false)) {
        _showCompletionDialog(context, ref);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header ----
              Text(tr(AppStrings.wellnessHub, lang),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: DesignTokens.spacingXxs),

              // ---- Ayurvedic Time Greeting ----
              _buildTimeGreetingCard(context, greeting, timeSuggestion, lang),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Streak Card ----
              _buildStreakCard(context, wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Mood Check-in ----
              _buildMoodCheckIn(context, ref, wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Progress Stats ----
              _buildProgressStats(context, wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Morning/Evening Toggle ----
              _buildRoutineToggle(context, ref, wellnessState),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Daily Routine ----
              _buildRoutineSection(context, wellnessState, lang),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Dosha-Aware Meditation ----
              _buildMeditationSection(context, ref, timerState, dominantDosha),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Ahara (Dietary Tips) ----
              if (dominantDosha != null)
                _buildAharaSection(context, dominantDosha, lang),
              if (dominantDosha != null)
                const SizedBox(height: DesignTokens.spacingMd),

              // ---- Sleep Sounds ----
              _buildSleepSoundsSection(context, ref, playingSound),
              const SizedBox(height: DesignTokens.spacingMd),

              // ---- Dosha Balance Cards ----
              Text(tr(AppStrings.balanceDosha, lang),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DesignTokens.spacingSm),
              Row(
                children: [
                  _buildDoshaCard(context, tr(AppStrings.vata, lang),
                      AppColors.vata, dominantDosha == 'Vata'),
                  const SizedBox(width: DesignTokens.spacingSm),
                  _buildDoshaCard(context, tr(AppStrings.pitta, lang),
                      AppColors.pitta, dominantDosha == 'Pitta'),
                  const SizedBox(width: DesignTokens.spacingSm),
                  _buildDoshaCard(context, tr(AppStrings.kapha, lang),
                      AppColors.kapha, dominantDosha == 'Kapha'),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // ---- Dynamic Seasonal Wisdom ----
              _buildSeasonalWisdomSection(
                  context, currentSeason, seasonDetails, lang),
              const SizedBox(height: DesignTokens.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TIME GREETING CARD
  // ============================================================

  Widget _buildTimeGreetingCard(
    BuildContext context,
    Map<String, String> greeting,
    Map<String, String> suggestion,
    String lang,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.tulsiGreen.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting[lang] ?? greeting['en']!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            suggestion[lang] ?? suggestion['en']!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STREAK CARD
  // ============================================================

  Widget _buildStreakCard(BuildContext context, WellnessState state) {
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

  // ============================================================
  // MOOD CHECK-IN
  // ============================================================

  Widget _buildMoodCheckIn(
      BuildContext context, WidgetRef ref, WellnessState state) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_emotions, color: AppColors.lotusPink),
              const SizedBox(width: 8),
              Text('How are you feeling?',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: WellnessData.moodOptions.map((mood) {
              final isSelected = state.todayMood == mood['value'];
              return GestureDetector(
                onTap: () => ref
                    .read(wellnessProvider.notifier)
                    .logMood(mood['value'] as int),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(mood['emoji'] as String,
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        mood['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          // Mood History Mini Chart
          if (state.moodHistory.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            const Divider(),
            const SizedBox(height: DesignTokens.spacingXs),
            Text('This Week',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: state.moodHistory.map((m) {
                  final height = (m / 5.0) * 24.0 + 6.0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: height,
                    decoration: BoxDecoration(
                      color: _moodColor(m),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return AppColors.error.withValues(alpha: 0.6);
      case 2:
        return AppColors.warning.withValues(alpha: 0.6);
      case 3:
        return AppColors.turmeric;
      case 4:
        return AppColors.primaryLight;
      case 5:
        return AppColors.success;
      default:
        return AppColors.stoneGray;
    }
  }

  // ============================================================
  // PROGRESS STATS
  // ============================================================

  Widget _buildProgressStats(BuildContext context, WellnessState state) {
    return Row(
      children: [
        _buildStatCard(
            context, '🧘', '${state.totalMeditationMinutes}', 'Mins Meditated'),
        const SizedBox(width: DesignTokens.spacingSm),
        _buildStatCard(context, '✅', '${state.weeklyCheckIns}', 'This Week'),
        const SizedBox(width: DesignTokens.spacingSm),
        _buildStatCard(context, '🔥', '${state.currentStreak}', 'Day Streak'),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingSm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 1))
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ROUTINE TOGGLE
  // ============================================================

  Widget _buildRoutineToggle(
      BuildContext context, WidgetRef ref, WellnessState state) {
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
                if (!state.isMorningRoutine) {
                  ref.read(wellnessProvider.notifier).toggleRoutine();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: state.isMorningRoutine
                      ? AppColors.saffron
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny,
                        color: state.isMorningRoutine
                            ? Colors.white
                            : AppColors.textSecondary,
                        size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Morning',
                      style: TextStyle(
                        color: state.isMorningRoutine
                            ? Colors.white
                            : AppColors.textSecondary,
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
                if (state.isMorningRoutine) {
                  ref.read(wellnessProvider.notifier).toggleRoutine();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !state.isMorningRoutine
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.nightlight_round,
                        color: !state.isMorningRoutine
                            ? Colors.white
                            : AppColors.textSecondary,
                        size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Evening',
                      style: TextStyle(
                        color: !state.isMorningRoutine
                            ? Colors.white
                            : AppColors.textSecondary,
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

  // ============================================================
  // ROUTINE SECTION
  // ============================================================

  Widget _buildRoutineSection(
      BuildContext context, WellnessState state, String lang) {
    final routineItems = state.isMorningRoutine
        ? WellnessData.dailyRoutine
        : WellnessData.eveningRoutine;
    final title =
        state.isMorningRoutine ? 'Morning Routine' : 'Evening Routine';
    final icon =
        state.isMorningRoutine ? Icons.wb_sunny : Icons.nightlight_round;
    final color =
        state.isMorningRoutine ? AppColors.saffron : AppColors.primary;

    return _buildSection(context, title, icon, color,
        routineItems.map((r) => r[lang] ?? r['en']!).toList());
  }

  // ============================================================
  // MEDITATION SECTION (Dosha-Aware)
  // ============================================================

  Widget _buildMeditationSection(BuildContext context, WidgetRef ref,
      MeditationTimerState timerState, String? dominantDosha) {
    // Pick dosha-specific meditations if known, else fallback
    final meditations = dominantDosha != null
        ? (WellnessData.doshaMeditations[dominantDosha] ??
            WellnessData.meditationTypes)
        : WellnessData.meditationTypes;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))
        ],
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
                child: const Icon(Icons.self_improvement,
                    color: AppColors.lotusPink),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Meditation',
                        style: Theme.of(context).textTheme.titleMedium),
                    if (dominantDosha != null)
                      Text(
                        'Tailored for $dominantDosha',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          if (timerState.isRunning || timerState.remainingSeconds > 0) ...[
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: timerState.progress,
                            strokeWidth: 8,
                            backgroundColor: AppColors.surfaceVariant,
                            color: AppColors.lotusPink,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timerState.formattedTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              timerState.isRunning ? 'Breathing...' : 'Paused',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (timerState.isRunning)
                        OutlinedButton.icon(
                          onPressed: () => ref
                              .read(meditationTimerProvider.notifier)
                              .pauseMeditation(),
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () => ref
                              .read(meditationTimerProvider.notifier)
                              .resumeMeditation(),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Resume'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white),
                        ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => ref
                            .read(meditationTimerProvider.notifier)
                            .stopMeditation(),
                        icon: const Icon(Icons.stop, color: AppColors.error),
                        label: const Text('Stop',
                            style: TextStyle(color: AppColors.error)),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // Show meditation options
            ...meditations.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => ref
                          .read(meditationTimerProvider.notifier)
                          .startMeditation(med['duration'] as int),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.lotusPink.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  AppColors.lotusPink.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.lotusPink.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.self_improvement,
                                  color: AppColors.lotusPink, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(med['name'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600)),
                                  Text(med['description'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.lotusPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${med['duration']} min',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // AHARA (DIETARY) SECTION
  // ============================================================

  Widget _buildAharaSection(BuildContext context, String dosha, String lang) {
    final aharaData = WellnessData.aharaTips[dosha];
    if (aharaData == null) return const SizedBox.shrink();

    final favorFoods = aharaData['favor'] as List<dynamic>;
    final avoidFoods = aharaData['avoid'] as List<dynamic>;
    final spice = aharaData['spice'] as Map<String, String>;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.turmeric.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant, color: AppColors.turmeric),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ahara (Diet)',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      'For $dosha balance',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),

          // Favor foods
          Text('✅ Favor',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.success)),
          const SizedBox(height: 4),
          ...favorFoods.map((f) {
            final item = f as Map<String, String>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('  • ',
                      style: TextStyle(color: AppColors.success)),
                  Expanded(
                    child: Text(item[lang] ?? item['en']!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: DesignTokens.spacingXs),

          // Avoid foods
          Text('❌ Avoid',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.error)),
          const SizedBox(height: 4),
          ...avoidFoods.map((f) {
            final item = f as Map<String, String>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('  • ', style: TextStyle(color: AppColors.error)),
                  Expanded(
                    child: Text(item[lang] ?? item['en']!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: DesignTokens.spacingXs),

          // Recommended spice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.turmeric.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('🌿', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Top Spices: ${spice[lang] ?? spice['en']!}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.earthBrown),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SLEEP SOUNDS
  // ============================================================

  Widget _buildSleepSoundsSection(
      BuildContext context, WidgetRef ref, String? playingSound) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))
        ],
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
              Text('Sleep Sounds',
                  style: Theme.of(context).textTheme.titleMedium),
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
                    ref.read(playingSoundProvider.notifier).state =
                        sound['name'];
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // GENERIC SECTION (checklist style)
  // ============================================================

  Widget _buildSection(BuildContext context, String title, IconData icon,
      Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))
        ],
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
              Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(item,
                            style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ============================================================
  // DOSHA BALANCE CARDS
  // ============================================================

  Widget _buildDoshaCard(
      BuildContext context, String dosha, Color color, bool isUserDosha) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/dosha-quiz'),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isUserDosha ? 0.25 : 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: color.withValues(alpha: isUserDosha ? 0.8 : 0.3),
                width: isUserDosha ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(dosha,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  isUserDosha ? 'Your Dosha' : 'Balance tips',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight:
                          isUserDosha ? FontWeight.w600 : FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DYNAMIC SEASONAL WISDOM
  // ============================================================

  Widget _buildSeasonalWisdomSection(
    BuildContext context,
    String currentSeason,
    Map<String, dynamic>? details,
    String lang,
  ) {
    if (details == null) return const SizedBox.shrink();

    final emoji = details['emoji'] as String;
    final seasonName = (details[lang] ?? details['en']) as String;
    final doshaAffected = details['dosha'] as String;
    final tips = details['tips'] as List<dynamic>;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.turmeric.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Season',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textSecondary)),
                    Text(seasonName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.getDoshaColor(doshaAffected)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$doshaAffected season',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.getDoshaColor(doshaAffected),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          ...tips.map((t) {
            final tip = t as Map<String, String>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.eco, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(tip[lang] ?? tip['en']!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
