import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/remedy.dart';
import 'remedies_repository.dart';

class FirestoreRemediesRepository implements RemediesRepository {
  final FirebaseFirestore _firestore;

  FirestoreRemediesRepository(this._firestore);

  @override
  Future<List<Remedy>> getRemedies() async {
    try {
      final snapshot = await _firestore.collection('remedies').get();
      return snapshot.docs.map((doc) {
        return Remedy.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to load remedies from Firestore: $e');
    }
  }

  @override
  Future<Remedy?> getRemedyById(String id) async {
    try {
      final doc = await _firestore.collection('remedies').doc(id).get();
      if (doc.exists) {
        return Remedy.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get remedy: $e');
    }
  }

  @override
  Future<List<Remedy>> getRemediesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('remedies')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        return Remedy.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to load remedies by category: $e');
    }
  }

  @override
  Future<List<Remedy>> searchRemedies(String query) async {
    final remedies = await getRemedies();
    final q = query.toLowerCase();
    return remedies.where((r) => r.title.toLowerCase().contains(q)).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    // This is expensive on Firestore without a separate aggregation/document
    // For now, fetch all distinct categories from remedies
    final remedies = await getRemedies();
    return remedies.map((r) => r.category).toSet().toList();
  }
}
