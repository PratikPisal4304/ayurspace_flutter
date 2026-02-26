import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_profile.dart';
import '../data/models/dosha.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

/// User state
class UserState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const UserState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// User notifier handling persistence via Firestore
class UserNotifier extends StateNotifier<UserState> {
  final FirestoreService _firestoreService;
  StreamSubscription<FirestoreUser?>? _userSubscription;

  UserNotifier(this._firestoreService) : super(const UserState());

  /// Initialize based on Auth User
  void onAuthStateChanged(User? firebaseUser) {
    _userSubscription?.cancel();
    _userSubscription = null;

    if (firebaseUser == null) {
      state = const UserState(); // Reset state on logout
    } else {
      loading();
      // Listen to real-time updates from Firestore
      _userSubscription = _firestoreService.streamUser(firebaseUser.uid).listen(
          (firestoreUser) {
        if (firestoreUser != null) {
          state = state.copyWith(
            profile: _mapFirestoreUserToUserProfile(firestoreUser),
            isLoading: false,
          );
        } else {
          // User authenticated but no Firestore doc yet
          // This can happen during Google Sign-In before document is created.
          // Create a minimal profile from Firebase Auth to show immediately.
          state = state.copyWith(
            profile: UserProfile(
              id: firebaseUser.uid,
              name: firebaseUser.displayName ?? 'User',
              email: firebaseUser.email ?? '',
              avatarUrl: firebaseUser.photoURL,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            isLoading: false,
          );
        }
      }, onError: (e) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      });
    }
  }

  void loading() {
    state = state.copyWith(isLoading: true);
  }

  /// Update user name
  Future<void> updateName(String name) async {
    final uid = state.profile?.id;
    if (uid != null) {
      await _firestoreService.updateName(uid, name);
    }
  }

  /// Update user email - handled by AuthService, but strictly speaking
  /// we might want to update Firestore if we store email there.
  /// Skipping for now as AuthService handles auth email.
  Future<void> updateEmail(String email) async {
    final uid = state.profile?.id;
    if (uid != null) {
      await _firestoreService.updateEmail(uid, email);
    }
  }

  /// Update avatar index
  Future<void> updateAvatarIndex(int index) async {
    final uid = state.profile?.id;
    if (uid != null) {
      await _firestoreService.updateAvatarIndex(uid, index);
    }
  }

  /// Save dosha result
  Future<void> saveDoshaResult(DoshaResult result) async {
    final uid = state.profile?.id;
    if (uid != null) {
      await _firestoreService.saveDoshaResult(uid, result.toJson());
    }
  }

  /// Toggle plant bookmark
  Future<void> toggleBookmark(String plantId) async {
    final uid = state.profile?.id;
    if (uid == null) return;

    final isBookmarked = state.profile!.bookmarkedPlantIds.contains(plantId);

    // Optimistic update
    final currentBookmarks =
        List<String>.from(state.profile!.bookmarkedPlantIds);
    if (isBookmarked) {
      currentBookmarks.remove(plantId);
      await _firestoreService.removeBookmark(uid, plantId);
    } else {
      currentBookmarks.add(plantId);
      await _firestoreService.addBookmark(uid, plantId);
    }

    // State update happens via Firestore stream subscription automatically,
    // but if we want instant local feedback before network:
    // state = state.copyWith(profile: state.profile!.copyWith(bookmarkedPlantIds: currentBookmarks));
  }

  /// Toggle remedy favorite
  Future<void> toggleFavoriteRemedy(String remedyId) async {
    final uid = state.profile?.id;
    if (uid == null) return;

    final isFavorite = state.profile!.favoriteRemedyIds.contains(remedyId);

    if (isFavorite) {
      await _firestoreService.removeFavorite(uid, remedyId);
    } else {
      await _firestoreService.addFavorite(uid, remedyId);
    }
  }

  /// Update user settings - currently local only in this model,
  /// need schema update to persist.
  void updateSettings(UserSettings settings) {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          settings: settings,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update stats
  Future<void> incrementPlantsScanned() async {
    final uid = state.profile?.id;
    if (uid != null) {
      await _firestoreService.incrementPlantsScanned(uid);
    }
  }

  Future<void> incrementRemediesTried() async {
    final uid = state.profile?.id;
    if (uid != null) {
      await _firestoreService.incrementRemediesTried(uid);
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  UserProfile _mapFirestoreUserToUserProfile(FirestoreUser firestoreUser) {
    return UserProfile(
      id: firestoreUser.uid,
      name: firestoreUser.name,
      email: firestoreUser.email,
      avatarUrl: firestoreUser.avatarUrl,
      avatarIndex: firestoreUser.avatarIndex,
      doshaResult: firestoreUser.doshaResult != null
          ? DoshaResult.fromJson(firestoreUser.doshaResult!)
          : null,
      createdAt: firestoreUser.createdAt,
      updatedAt: firestoreUser.updatedAt,
      // Mapping stats from flat structure
      stats: UserStats(
        plantsScanned: firestoreUser.plantsScanned,
        remediesTried: firestoreUser.remediesTried,
        wellnessScore: firestoreUser.wellnessScore,
        bookmarkedPlants: firestoreUser.bookmarks.length,
        favoriteRemedies: firestoreUser.favorites.length,
      ),
      // Settings are not yet in Firestore, using defaults
      settings: const UserSettings(),
      bookmarkedPlantIds: firestoreUser.bookmarks,
      favoriteRemedyIds: firestoreUser.favorites,
    );
  }
}

/// User provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final notifier = UserNotifier(firestoreService);

  // Watch auth changes and update notifier
  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
    next.whenData((user) => notifier.onAuthStateChanged(user));
  });

  // Initialize with current value if available (for initial load)
  final authState = ref.read(authStateProvider);
  if (authState.hasValue) {
    notifier.onAuthStateChanged(authState.value);
  }

  return notifier;
});

/// User profile provider
final userProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(userProvider).profile;
});

/// User stats provider
final userStatsProvider = Provider<UserStats>((ref) {
  return ref.watch(userProvider).profile?.stats ?? const UserStats();
});

/// Greeting type based on time of day
enum GreetingType { morning, afternoon, evening }

/// Greeting provider based on time of day
final greetingTypeProvider = Provider<GreetingType>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 12) return GreetingType.morning;
  if (hour < 17) return GreetingType.afternoon;
  return GreetingType.evening;
});
