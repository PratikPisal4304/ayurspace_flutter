import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wellness Hub', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: DesignTokens.spacingXs),
              Text('Your daily Ayurvedic practices', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: DesignTokens.spacingLg),

              _buildSection(context, 'Daily Routine', Icons.wb_sunny, AppColors.saffron, [
                'Wake before sunrise', 'Warm water on empty stomach', 
                'Oil pulling & tongue scraping', 'Self-massage (Abhyanga)', 'Yoga & meditation'
              ]),
              const SizedBox(height: DesignTokens.spacingMd),

              Text('Balance Your Dosha', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DesignTokens.spacingSm),
              Row(
                children: [
                  _buildDoshaCard(context, 'Vata', AppColors.vata),
                  const SizedBox(width: DesignTokens.spacingSm),
                  _buildDoshaCard(context, 'Pitta', AppColors.pitta),
                  const SizedBox(width: DesignTokens.spacingSm),
                  _buildDoshaCard(context, 'Kapha', AppColors.kapha),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              _buildSection(context, 'Yoga & Meditation', Icons.self_improvement, AppColors.lotusPink, [
                'Surya Namaskar', 'Pranayama breathing', 'Mindfulness meditation'
              ]),
              const SizedBox(height: DesignTokens.spacingMd),

              _buildSection(context, 'Seasonal Wisdom', Icons.eco, AppColors.primary, [
                'Winter: Warm foods', 'Spring: Light diet', 'Summer: Stay cool', 'Monsoon: Digestive care'
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ]),
          const SizedBox(height: DesignTokens.spacingSm),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(children: [
              Icon(Icons.check_circle, color: color, size: 16),
              const SizedBox(width: 8),
              Text(item, style: Theme.of(context).textTheme.bodyMedium),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _buildDoshaCard(BuildContext context, String dosha, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingSm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Text(dosha, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Balance tips', style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}
