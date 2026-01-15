import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Authentication State
class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

/// Auth Notifier to handle logic
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthNotifier(this._authService, this._firestoreService)
      : super(const AuthState());

  /// Sign In
  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, user: credential?.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // Allow UI to handle if needed (navigating etc)
    }
  }

  /// Sign Up with full orchestration
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 1. Create Account
      final credential = await _authService.createAccount(
        email: email,
        password: password,
      );

      if (credential?.user != null) {
        // 2. Update Display Name
        await _authService.updateDisplayName(name);

        // 3. Create Firestore Document
        await _firestoreService.createUser(
          uid: credential!.user!.uid,
          name: name,
          email: email,
        );

        state = state.copyWith(isLoading: false, user: credential.user);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Sign In with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _authService.signInWithGoogle();
      
      if (credential?.user != null) {
        final user = credential!.user!;
        
        // Check if this is a new user (additionalUserInfo.isNewUser)
        final isNewUser = credential.additionalUserInfo?.isNewUser ?? false;
        
        if (isNewUser) {
          // Create Firestore document for new Google user
          await _firestoreService.createUser(
            uid: user.uid,
            name: user.displayName ?? 'User',
            email: user.email ?? '',
          );
        }
        
        state = state.copyWith(isLoading: false, user: user);
      } else {
        // User cancelled sign-in
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Password Reset
  Future<void> sendPasswordReset(String email) async {
    try {
      await _authService.sendPasswordReset(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

/// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return AuthNotifier(authService, firestoreService);
});
