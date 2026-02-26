import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_exceptions.dart';

/// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// User document model for Firestore
class FirestoreUser {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final int avatarIndex;
  final Map<String, dynamic>? doshaResult;
  final List<String> bookmarks;
  final List<String> favorites;
  final int plantsScanned;
  final int remediesTried;
  final int wellnessScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirestoreUser({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.avatarIndex = 0,
    this.doshaResult,
    this.bookmarks = const [],
    this.favorites = const [],
    this.plantsScanned = 0,
    this.remediesTried = 0,
    this.wellnessScore = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FirestoreUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FirestoreUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      avatarIndex: data['avatarIndex'] ?? 0,
      doshaResult: data['doshaResult'],
      bookmarks: List<String>.from(data['bookmarks'] ?? []),
      favorites: List<String>.from(data['favorites'] ?? []),
      plantsScanned: data['plantsScanned'] ?? 0,
      remediesTried: data['remediesTried'] ?? 0,
      wellnessScore: data['wellnessScore'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'avatarIndex': avatarIndex,
      'doshaResult': doshaResult,
      'bookmarks': bookmarks,
      'favorites': favorites,
      'plantsScanned': plantsScanned,
      'remediesTried': remediesTried,
      'wellnessScore': wellnessScore,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

/// Firestore service for user data operations
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Create user document
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      final user = FirestoreUser(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _usersCollection.doc(uid).set(user.toFirestore());
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Get user document
  Future<FirestoreUser?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (!doc.exists) return null;
      return FirestoreUser.fromFirestore(doc);
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Stream user document
  Stream<FirestoreUser?> streamUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return FirestoreUser.fromFirestore(doc);
    });
  }

  /// Update user name
  Future<void> updateName(String uid, String name) async {
    try {
      await _usersCollection.doc(uid).update({
        'name': name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Update user email
  Future<void> updateEmail(String uid, String email) async {
    try {
      await _usersCollection.doc(uid).update({
        'email': email,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Update user avatar index
  Future<void> updateAvatarIndex(String uid, int index) async {
    try {
      await _usersCollection.doc(uid).update({
        'avatarIndex': index,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Save dosha result
  Future<void> saveDoshaResult(String uid, Map<String, dynamic> result) async {
    try {
      await _usersCollection.doc(uid).update({
        'doshaResult': result,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Add bookmark
  Future<void> addBookmark(String uid, String plantId) async {
    try {
      await _usersCollection.doc(uid).update({
        'bookmarks': FieldValue.arrayUnion([plantId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Remove bookmark
  Future<void> removeBookmark(String uid, String plantId) async {
    try {
      await _usersCollection.doc(uid).update({
        'bookmarks': FieldValue.arrayRemove([plantId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Add favorite
  Future<void> addFavorite(String uid, String remedyId) async {
    try {
      await _usersCollection.doc(uid).update({
        'favorites': FieldValue.arrayUnion([remedyId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Remove favorite
  Future<void> removeFavorite(String uid, String remedyId) async {
    try {
      await _usersCollection.doc(uid).update({
        'favorites': FieldValue.arrayRemove([remedyId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Increment plants scanned
  Future<void> incrementPlantsScanned(String uid) async {
    try {
      await _usersCollection.doc(uid).update({
        'plantsScanned': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }

  /// Increment remedies tried
  Future<void> incrementRemediesTried(String uid) async {
    try {
      await _usersCollection.doc(uid).update({
        'remediesTried': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreException.fromError(e);
    }
  }
}

/// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(ref.watch(firestoreProvider));
});
