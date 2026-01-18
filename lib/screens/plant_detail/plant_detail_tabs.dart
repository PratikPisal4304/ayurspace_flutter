part of 'plant_detail_screen.dart';

/// Overview Tab - Description, benefits, and key information
class _OverviewTab extends StatelessWidget {
  final Plant plant;
  const _OverviewTab({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Description Section
        _SectionCard(
          title: l10n.plantAbout,
          icon: Icons.info_outline,
          child: Text(
            plant.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Health Benefits
        _SectionCard(
          title: l10n.plantBenefits,
          icon: Icons.favorite_outline,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plant.benefits.map((benefit) {
              return _BenefitChip(label: benefit);
            }).toList(),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Dosha Badges
        _SectionCard(
          title: l10n.plantDoshas,
          icon: Icons.balance,
          child: Row(
            children: plant.doshas.map((dosha) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _DoshaChip(dosha: dosha),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Seasons
        _SectionCard(
          title: l10n.plantSeasons,
          icon: Icons.calendar_today,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plant.season.map((s) => _SeasonChip(season: s)).toList(),
          ),
        ),

        // Chemical Compounds (if available)
        if (plant.chemicalCompounds != null && plant.chemicalCompounds!.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          _SectionCard(
            title: l10n.plantCompounds,
            icon: Icons.science,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.chemicalCompounds!
                  .map((c) => Chip(
                        label: Text(c, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.info.withValues(alpha: 0.1),
                      ))
                  .toList(),
            ),
          ),
        ],

        const SizedBox(height: DesignTokens.spacingXxl),
      ],
    );
  }
}

/// Uses & Dosage Tab
class _UsesTab extends StatelessWidget {
  final Plant plant;
  const _UsesTab({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Uses List
        _SectionCard(
          title: l10n.plantUses,
          icon: Icons.medication_outlined,
          child: Column(
            children: plant.uses.asMap().entries.map((entry) {
              return _NumberedListItem(
                number: entry.key + 1,
                text: entry.value,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Dosage Card
        _InfoCard(
          title: l10n.plantDosage,
          content: plant.dosage,
          icon: Icons.medical_services,
          color: AppColors.primary,
        ),
        const SizedBox(height: DesignTokens.spacingSm),

        // Precautions Card
        _InfoCard(
          title: l10n.plantPrecautions,
          content: plant.precautions,
          icon: Icons.warning_amber,
          color: AppColors.warning,
        ),

        // Contraindications (if available)
        if (plant.contraindications != null && plant.contraindications!.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingSm),
          _InfoCard(
            title: l10n.plantContraindications,
            content: plant.contraindications!.join('\n• '),
            icon: Icons.do_not_disturb,
            color: AppColors.error,
          ),
        ],

        const SizedBox(height: DesignTokens.spacingXxl),
      ],
    );
  }
}

/// Growing Tab
class _GrowingTab extends StatelessWidget {
  final Plant plant;
  const _GrowingTab({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Difficulty Indicator
        _SectionCard(
          title: l10n.plantDifficulty,
          icon: Icons.trending_up,
          child: _DifficultyMeter(difficulty: plant.difficulty),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Growing Tips
        _InfoCard(
          title: l10n.plantTips,
          content: plant.growingTips,
          icon: Icons.tips_and_updates,
          color: AppColors.neemGreen,
        ),
        const SizedBox(height: DesignTokens.spacingSm),

        // Harvest Time
        _InfoCard(
          title: l10n.plantHarvest,
          content: plant.harvestTime,
          icon: Icons.schedule,
          color: AppColors.saffron,
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Category & Part Used
        _SectionCard(
          title: l10n.plantDetails,
          icon: Icons.eco,
          child: Column(
            children: [
              _DetailRow(label: l10n.plantCategory, value: plant.category),
              if (plant.partUsed != null)
                _DetailRow(label: l10n.plantPartUsed, value: plant.partUsed!),
              if (plant.origin != null)
                _DetailRow(label: l10n.plantOrigin, value: plant.origin!),
            ],
          ),
        ),

        const SizedBox(height: DesignTokens.spacingXxl),
      ],
    );
  }
}

/// Ayurveda Tab
class _AyurvedaTab extends StatelessWidget {
  final Plant plant;
  const _AyurvedaTab({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        // Dosha Visualization
        _SectionCard(
          title: l10n.plantDoshaBalance,
          icon: Icons.pie_chart,
          child: _DoshaVisualization(doshas: plant.doshas),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Taste Profile (Rasa)
        if (plant.taste != null && plant.taste!.isNotEmpty) ...[
          _SectionCard(
            title: l10n.plantTaste,
            icon: Icons.restaurant,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.taste!.map((t) => _TasteChip(taste: t)).toList(),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
        ],

        // Names Section
        _SectionCard(
          title: l10n.plantNames,
          icon: Icons.translate,
          child: Column(
            children: [
              _DetailRow(label: l10n.nameEnglish, value: plant.name),
              _DetailRow(label: l10n.nameHindi, value: plant.hindi),
              _DetailRow(label: l10n.nameScientific, value: plant.scientificName),
              if (plant.sanskritName != null)
                _DetailRow(label: l10n.nameSanskrit, value: plant.sanskritName!),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        // Properties Summary
        _SectionCard(
          title: l10n.ayurvedicProps,
          icon: Icons.auto_awesome,
          child: Column(
            children: [
              _PropertyRow(
                label: l10n.propBalances,
                value: plant.doshas.join(', '),
                icon: Icons.balance,
              ),
              _PropertyRow(
                label: l10n.plantCategory,
                value: plant.category,
                icon: Icons.category,
              ),
              // Use real field data for Virya (Potency)
              _PropertyRow(
                label: l10n.propPotency,
                value: plant.virya ?? 'Unknown',
                icon: Icons.thermostat,
              ),
              // Added Vipaka (Post-digestive)
               if (plant.vipaka != null)
                _PropertyRow(
                  label: l10n.propPostDigestive,
                  value: plant.vipaka!,
                  icon: Icons.science_outlined,
                ),
            ],
          ),
        ),

        const SizedBox(height: DesignTokens.spacingXxl),
      ],
    );
  }
  // Logic removed: _getPotency logic is domain logic and should be in the model

}

// ============ HELPER WIDGETS ============

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          child,
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final String label;
  const _BenefitChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoshaChip extends StatelessWidget {
  final String dosha;
  const _DoshaChip({required this.dosha});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDoshaColor(dosha);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            dosha,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonChip extends StatelessWidget {
  final String season;
  const _SeasonChip({required this.season});

  IconData get _icon {
    switch (season.toLowerCase()) {
      case 'summer':
        return Icons.wb_sunny;
      case 'monsoon':
        return Icons.water_drop;
      case 'winter':
        return Icons.ac_unit;
      case 'spring':
        return Icons.local_florist;
      case 'autumn':
        return Icons.eco;
      default:
        return Icons.calendar_today;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(_icon, size: 16, color: AppColors.saffron),
      label: Text(season),
      backgroundColor: AppColors.saffron.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.saffron.withValues(alpha: 0.3)),
    );
  }
}

class _TasteChip extends StatelessWidget {
  final String taste;
  const _TasteChip({required this.taste});

  Color get _color {
    switch (taste.toLowerCase()) {
      case 'sweet':
        return Colors.pink;
      case 'sour':
        return Colors.orange;
      case 'salty':
        return Colors.blue;
      case 'bitter':
        return Colors.brown;
      case 'pungent':
        return Colors.red;
      case 'astringent':
        return Colors.purple;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(taste, style: TextStyle(color: _color, fontWeight: FontWeight.w500)),
      backgroundColor: _color.withValues(alpha: 0.1),
      side: BorderSide(color: _color.withValues(alpha: 0.3)),
    );
  }
}

class _NumberedListItem extends StatelessWidget {
  final int number;
  final String text;

  const _NumberedListItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _DifficultyMeter extends StatelessWidget {
  final String difficulty;
  const _DifficultyMeter({required this.difficulty});

  int get _level {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDifficultyColor(difficulty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (index) {
            final isActive = index < _level;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? color : color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          difficulty,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _PropertyRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PropertyRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _DoshaVisualization extends StatelessWidget {
  final List<String> doshas;
  const _DoshaVisualization({required this.doshas});

  @override
  Widget build(BuildContext context) {
    final allDoshas = ['Vata', 'Pitta', 'Kapha'];
    return Row(
      children: allDoshas.map((dosha) {
        final isActive = doshas.contains(dosha);
        final color = AppColors.getDoshaColor(dosha);
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: isActive ? color.withValues(alpha: 0.15) : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? color : AppColors.border,
                width: isActive ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.circle_outlined,
                  color: isActive ? color : AppColors.textTertiary,
                  size: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  dosha,
                  style: TextStyle(
                    color: isActive ? color : AppColors.textTertiary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
