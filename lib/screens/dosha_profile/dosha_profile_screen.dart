import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';
import '../../providers/wellness_provider.dart';
import '../../data/sources/wellness_data.dart';
import 'package:ayurspace_flutter/l10n/app_localizations.dart';

class DoshaProfileScreen extends ConsumerWidget {
  const DoshaProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final result = user?.doshaResult;
    final l10n = AppLocalizations.of(context)!;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.doshaProfileNoAssessment)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingXl),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.spa, size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: DesignTokens.spacingLg),
              Text(l10n.doshaDiscoverTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppColors.primaryDark)),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                l10n.doshaDiscoverSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(height: DesignTokens.spacingXl),
              ElevatedButton(
                  onPressed: () => context.push('/dosha-quiz'),
                  child: Text(l10n.doshaQuiz)),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.doshaProfileTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          children: [
            // Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.getDoshaColor(result.dominant.name),
                  AppColors.getDoshaColor(result.dominant.name)
                      .withValues(alpha: 0.1),
                ]),
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              ),
              child: Column(children: [
                const Icon(Icons.spa, color: Colors.white, size: 60),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(l10n.doshaYouAre(result.dominant.displayName),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white)),
                Text(result.dominant.element,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            // Dosha Breakdown
            Text(l10n.doshaBreakdown,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: DesignTokens.spacingSm),
            _DoshaBar(
                label: 'Vata',
                percent: result.vataPercent,
                color: AppColors.vata),
            _DoshaBar(
                label: 'Pitta',
                percent: result.pittaPercent,
                color: AppColors.pitta),
            _DoshaBar(
                label: 'Kapha',
                percent: result.kaphaPercent,
                color: AppColors.kapha),
            const SizedBox(height: DesignTokens.spacingLg),

            // Description
            Text(l10n.doshaAbout(result.dominant.displayName),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: DesignTokens.spacingSm),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
              child: Text(result.dominant.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.5)),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            // Ahara (Diet)
            _buildAharaSection(context, result.dominant.name, l10n),
            const SizedBox(height: DesignTokens.spacingLg),

            // Seasonal Impact
            _buildSeasonalImpact(context, ref, result.dominant.name, l10n),
            const SizedBox(height: DesignTokens.spacingLg),

            // Retake Button
            OutlinedButton.icon(
                onPressed: () => context.push('/dosha-quiz'),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.doshaRetakeQuiz)),
          ],
        ),
      ),
    );
  }
}

class _DoshaBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  const _DoshaBar(
      {required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
      child: Row(children: [
        SizedBox(
            width: 50,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent / 100,
              child: Container(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ),
        SizedBox(
            width: 40,
            child: Text('${percent.toInt()}%',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodySmall)),
      ]),
    );
  }
}

Widget _buildAharaSection(
    BuildContext context, String dosha, AppLocalizations l10n) {
  final ahara = WellnessData.aharaTips[dosha];
  if (ahara == null) return const SizedBox.shrink();

  final favor = ahara['favor'] as List<dynamic>;
  final avoid = ahara['avoid'] as List<dynamic>;

  // Determine locale code for Ahara tips
  final locale = Localizations.localeOf(context).languageCode;
  String tipText(dynamic f) {
    final map = f as Map<String, String>;
    return map[locale] ?? map['en'] ?? '';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l10n.doshaBalancingDiet,
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: DesignTokens.spacingSm),
      Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.doshaFavor,
                style: const TextStyle(
                    color: AppColors.success, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...favor.take(3).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• ${tipText(f)}'),
                )),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(l10n.doshaAvoid,
                style: const TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...avoid.take(3).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• ${tipText(f)}'),
                )),
          ],
        ),
      ),
    ],
  );
}

Widget _buildSeasonalImpact(BuildContext context, WidgetRef ref,
    String userDosha, AppLocalizations l10n) {
  final seasonDetails = ref.watch(currentSeasonDetailsProvider);
  if (seasonDetails == null) return const SizedBox.shrink();

  final seasonDosha = seasonDetails['dosha'] as String;
  final isMatching = seasonDosha == userDosha;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l10n.doshaSeasonImpact,
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: DesignTokens.spacingSm),
      Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
            color: isMatching
                ? AppColors.warning.withValues(alpha: 0.1)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seasonDetails['emoji'] as String,
                style: const TextStyle(fontSize: 24)),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.doshaSeasonOf(seasonDosha),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    isMatching
                        ? l10n.doshaSeasonWarning
                        : l10n.doshaSeasonNeutral(seasonDosha),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
