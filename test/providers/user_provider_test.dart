import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayurspace_flutter/providers/user_provider.dart';
import 'package:ayurspace_flutter/services/firestore_service.dart';
import 'package:ayurspace_flutter/data/models/dosha.dart';

// --- Fakes ---

class FakeUser extends Fake implements User {
  @override
  final String uid;
  FakeUser(this.uid);
}

class MockFirestoreService extends Fake implements FirestoreService {
  final StreamController<FirestoreUser?> _userController = StreamController<FirestoreUser?>.broadcast();
  
  // Verification flags/storage
  String? lastUpdatedName;
  Map<String, dynamic>? lastDoshaResult;
  int plantsScannedIncrementCount = 0;
  int remediesTriedIncrementCount = 0;

  @override
  Stream<FirestoreUser?> streamUser(String uid) {
    return _userController.stream;
  }
  
  void emitUser(FirestoreUser? user) {
    _userController.add(user);
  }

  @override
  Future<void> updateName(String uid, String name) async {
    lastUpdatedName = name;
  }

  @override
  Future<void> saveDoshaResult(String uid, Map<String, dynamic> result) async {
    lastDoshaResult = result;
  }
  
  @override
  Future<void> incrementPlantsScanned(String uid) async {
    plantsScannedIncrementCount++;
  }
  
  @override
  Future<void> incrementRemediesTried(String uid) async {
    remediesTriedIncrementCount++;
  }
  
  void close() {
    _userController.close();
  }
}

void main() {
  late MockFirestoreService mockFirestoreService;
  late UserNotifier notifier;

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    notifier = UserNotifier(mockFirestoreService);
  });
  
  tearDown(() {
    mockFirestoreService.close();
    notifier.dispose();
  });

  group('UserNotifier Tests', () {
    test('Initial state should be empty', () {
      expect(notifier.state.profile, isNull);
      expect(notifier.state.isLoading, isFalse);
    });

    test('onAuthStateChanged(null) should clear state', () {
      // Setup some state first (hypothetically)
      // notifier.state = UserState(profile: ...); 
      // But we can just verify it stays empty or clears
      
      notifier.onAuthStateChanged(null);
      expect(notifier.state.profile, isNull);
    });

    test('onAuthStateChanged(user) should subscribe to Firestore stream', () async {
      final user = FakeUser('user_123');
      notifier.onAuthStateChanged(user);

      // Should be loading initially
      expect(notifier.state.isLoading, isTrue);

      // Emit Firestore Data
      final firestoreUser = FirestoreUser(
        uid: 'user_123',
        name: 'Test Setup',
        email: 'test@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        bookmarks: ['plant_1'],
        plantsScanned: 5,
      );
      
      mockFirestoreService.emitUser(firestoreUser);
      
      // Wait for stream listener
      await Future.delayed(Duration.zero);
      
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.profile, isNotNull);
      expect(notifier.state.profile!.id, 'user_123');
      expect(notifier.state.profile!.name, 'Test Setup');
      expect(notifier.state.profile!.stats.plantsScanned, 5);
      expect(notifier.state.profile!.stats.bookmarkedPlants, 1);
    });

    test('updateName calls FirestoreService', () async {
      // Setup logged in user
      final user = FakeUser('user_123');
      notifier.onAuthStateChanged(user);
      
      final firestoreUser = FirestoreUser(
        uid: 'user_123',
        name: 'Old Name',
        email: 'test@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      mockFirestoreService.emitUser(firestoreUser);
      await Future.delayed(Duration.zero);

      // Action
      await notifier.updateName('New Name');

      // Verify
      expect(mockFirestoreService.lastUpdatedName, 'New Name');
    });

    test('saveDoshaResult calls FirestoreService', () async {
      // Setup logged in user
      final user = FakeUser('user_123');
      notifier.onAuthStateChanged(user);
      
      final firestoreUser = FirestoreUser(
        uid: 'user_123',
        name: 'Test',
        email: 'test@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      mockFirestoreService.emitUser(firestoreUser);
      await Future.delayed(Duration.zero);

      // Action
      final result = DoshaResult(
        vata: 10,
        pitta: 5,
        kapha: 2,
        dominant: DoshaType.vata,
        assessedAt: DateTime.now(),
      );
      await notifier.saveDoshaResult(result);

      // Verify
      expect(mockFirestoreService.lastDoshaResult, isNotNull);
      expect(mockFirestoreService.lastDoshaResult!['dominant'], 'vata');
    });

    test('incrementStats calls FirestoreService', () async {
      // Setup logged in user
      final user = FakeUser('user_123');
      notifier.onAuthStateChanged(user);
      
      final firestoreUser = FirestoreUser(
        uid: 'user_123',
        name: 'Test',
        email: 'test@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      mockFirestoreService.emitUser(firestoreUser);
      await Future.delayed(Duration.zero);

      // Action
      await notifier.incrementPlantsScanned();
      await notifier.incrementRemediesTried();

      // Verify
      expect(mockFirestoreService.plantsScannedIncrementCount, 1);
      expect(mockFirestoreService.remediesTriedIncrementCount, 1);
    });
  });
}
