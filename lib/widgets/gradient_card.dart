import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

/// A gradient card widget for highlighted content like streak cards
/// or wellness score displays
class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry beginAlignment;
  final AlignmentGeometry endAlignment;
  final BorderRadius? borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradientColors,
    this.padding,
    this.beginAlignment = Alignment.topLeft,
    this.endAlignment = Alignment.bottomRight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: beginAlignment,
          end: endAlignment,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: child,
    );
  }
}
