import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';

class RemedyDetailScreen extends StatelessWidget {
  final String remedyId;
  const RemedyDetailScreen({super.key, required this.remedyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remedy Details')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.medical_services, size: 64, color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: DesignTokens.spacingMd),
          Text('Remedy: $remedyId', style: Theme.of(context).textTheme.titleLarge),
        ]),
      ),
    );
  }
}
