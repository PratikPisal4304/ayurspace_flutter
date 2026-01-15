import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/sources/plants_data.dart';
import '../data/sources/remedies_data.dart';

import 'firestore_service.dart';

class AdminService {
  final FirebaseFirestore _firestore;

  AdminService(this._firestore);

  /// Seed Plants Collection
  Future<void> seedPlants() async {
    final batch = _firestore.batch();
    final collection = _firestore.collection('plants');

    // Warning: Firestore batch limit is 500 operations.
    // Assuming plantsData is smaller than 500 for now.
    // If larger, we would need to chunk it.
    
    for (final plant in plantsData) {
      final doc = collection.doc(plant.id);
      batch.set(doc, plant.toJson());
    }

    await batch.commit();
  }

  /// Seed Remedies Collection
  Future<void> seedRemedies() async {
    final batch = _firestore.batch();
    final collection = _firestore.collection('remedies');

    for (final remedy in remediesData) {
      final doc = collection.doc(remedy.id);
      batch.set(doc, remedy.toJson());
    }

    await batch.commit();
  }
}

/// Provider for AdminService
final adminServiceProvider = Provider<AdminService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AdminService(firestore);
});
