import 'package:flutter/material.dart';
import '../config/colors.dart';

/// A reusable stat item widget showing a value with a label
/// Used in profile screens, wellness dashboards, etc.
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: valueStyle ??
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: valueColor ?? AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: labelStyle ?? Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
