import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

/// A badge widget for displaying tags like dosha types, categories, etc.
/// Supports custom colors and compact sizing
class TagBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const TagBadge({
    super.key,
    required this.text,
    required this.color,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXs,
            vertical: DesignTokens.spacingXxxs,
          ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
