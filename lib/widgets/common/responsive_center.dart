import 'package:flutter/material.dart';
import '../../config/design_tokens.dart';

/// A wrapper that centers content and constrains its width on larger screens.
/// This prevents the "stretched mobile app" look on tablets and desktop/web.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth =
        DesignTokens.breakpointTablet, // Default to tablet width (768)
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
