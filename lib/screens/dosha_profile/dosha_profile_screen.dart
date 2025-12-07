import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../providers/user_provider.dart';

class DoshaProfileScreen extends ConsumerWidget {
  const DoshaProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final result = user?.doshaResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Dosha')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('No dosha assessment yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: DesignTokens.spacingMd),
            ElevatedButton(onPressed: () => context.push('/dosha-quiz'), child: const Text('Take Quiz')),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Dosha Profile')),
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
                  AppColors.getDoshaColor(result.dominant.name).withOpacity(0.7),
                ]),
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              ),
              child: Column(children: [
                const Icon(Icons.spa, color: Colors.white, size: 60),
                const SizedBox(height: DesignTokens.spacingSm),
                Text('You are ${result.dominant.displayName}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                Text(result.dominant.element, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            // Dosha Breakdown
            Text('Dosha Breakdown', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: DesignTokens.spacingSm),
            _DoshaBar(label: 'Vata', percent: result.vataPercent, color: AppColors.vata),
            _DoshaBar(label: 'Pitta', percent: result.pittaPercent, color: AppColors.pitta),
            _DoshaBar(label: 'Kapha', percent: result.kaphaPercent, color: AppColors.kapha),
            const SizedBox(height: DesignTokens.spacingLg),

            // Description
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
              child: Text(result.dominant.description, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            // Retake Button
            OutlinedButton.icon(onPressed: () => context.push('/dosha-quiz'), icon: const Icon(Icons.refresh), label: const Text('Retake Quiz')),
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
  const _DoshaBar({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
      child: Row(children: [
        SizedBox(width: 50, child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent / 100,
              child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ),
        SizedBox(width: 40, child: Text('${percent.toInt()}%', textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodySmall)),
      ]),
    );
  }
}
