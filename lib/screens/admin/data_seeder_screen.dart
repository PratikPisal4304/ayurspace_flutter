import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/admin_service.dart';
import '../../config/colors.dart';

class DataSeederScreen extends ConsumerStatefulWidget {
  const DataSeederScreen({super.key});

  @override
  ConsumerState<DataSeederScreen> createState() => _DataSeederScreenState();
}

class _DataSeederScreenState extends ConsumerState<DataSeederScreen> {
  bool _isSeedingPlants = false;
  bool _isSeedingRemedies = false;
  String? _message;

  Future<void> _seedPlants() async {
    setState(() {
      _isSeedingPlants = true;
      _message = null;
    });

    try {
      await ref.read(adminServiceProvider).seedPlants();
      setState(() {
        _message = 'Plants seeded successfully!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error seeding plants: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSeedingPlants = false;
        });
      }
    }
  }

  Future<void> _seedRemedies() async {
    setState(() {
      _isSeedingRemedies = true;
      _message = null;
    });

    try {
      await ref.read(adminServiceProvider).seedRemedies();
      setState(() {
        _message = 'Remedies seeded successfully!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error seeding remedies: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSeedingRemedies = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Data Seeder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Use this tool to populate Cloud Firestore with initial data.\nWARNING: This will overwrite existing documents with the same IDs.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            if (_message != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_message!),
              ),
            ElevatedButton(
              onPressed: _isSeedingPlants ? null : _seedPlants,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSeedingPlants
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Seed Plants Collection'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSeedingRemedies ? null : _seedRemedies,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffron,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSeedingRemedies
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Seed Remedies Collection'),
            ),
          ],
        ),
      ),
    );
  }
}
