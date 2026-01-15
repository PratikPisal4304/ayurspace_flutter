import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant.dart';
import 'plants_repository.dart';

class FirestorePlantsRepository implements PlantsRepository {
  final FirebaseFirestore _firestore;

  FirestorePlantsRepository(this._firestore);

  @override
  Future<List<Plant>> getPlants() async {
    try {
      final snapshot = await _firestore.collection('plants').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure ID is passed if needed, or if it's in data
        return Plant.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to load plants from Firestore: $e');
    }
  }

  @override
  Future<Plant?> getPlantById(String id) async {
    try {
      final doc = await _firestore.collection('plants').doc(id).get();
      if (doc.exists) {
        return Plant.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load plant: $e');
    }
  }

  @override
  Future<List<Plant>> searchPlants(String query) async {
    // Basic client-side filtering since Firestore weak text search
    // For production, use Algolia/Typesense
    final plants = await getPlants();
    final lowercaseQuery = query.toLowerCase();
    
    return plants.where((plant) {
      return plant.name.toLowerCase().contains(lowercaseQuery) ||
             plant.scientificName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
