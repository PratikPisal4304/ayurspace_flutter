import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/auth_error_mapper.dart';
import '../utils/app_exceptions.dart';

/// Firebase Auth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Google Sign In instance provider (null on web since we use signInWithPopup)
final googleSignInProvider = Provider<GoogleSignIn?>((ref) {
  // On web, we use signInWithPopup which doesn't need GoogleSignIn
  if (kIsWeb) return null;

  return GoogleSignIn(
    scopes: ['email', 'profile'],
  );
});

/// Auth state changes stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Auth service for handling authentication
class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn? _googleSignIn;

  AuthService(this._auth, this._googleSignIn);

  /// Get the current logged in user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes for router refresh
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.mapErrorCode(e.code), code: e.code);
    }
  }

  /// Try to sign in silently (without showing UI)
  /// Useful for persistent login sessions on mobile
  Future<UserCredential?> signInSilently() async {
    if (kIsWeb || _googleSignIn == null) return null;

    try {
      final googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Silent Google sign-in failed: $e');
      return null;
    }
  }

  /// Professional Google Sign In with platform-specific flow
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Web Flow
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        // Professional apps often add hints for better UX
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.email');
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        return await _auth.signInWithPopup(googleProvider);
      }

      // 2. Mobile Native Flow (iOS/Android/macOS)
      if (_googleSignIn == null) {
        throw FirebaseAuthException(
          code: 'service-unavailable',
          message: 'Google Sign In is not configured on this platform.',
        );
      }

      // Trigger the native pickers
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in (professional apps treat this as null, not an error)
        return null;
      }

      // Obtain the auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Validate tokens (Professional check)
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw FirebaseAuthException(
          code: 'missing-credentials',
          message:
              'Google Sign In failed to provide valid authentication tokens.',
        );
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.mapErrorCode(e.code), code: e.code);
    } catch (e) {
      throw AuthException('An unexpected error occurred. Please try again.',
          originalError: e);
    }
  }

  /// Create account with email and password
  Future<UserCredential?> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthErrorMapper.mapErrorCode(e.code), code: e.code);
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    // Only sign out from GoogleSignIn on mobile
    if (_googleSignIn != null) {
      await _googleSignIn
          .disconnect(); // Disconnect to ensure account picker shows up next time
      await _googleSignIn.signOut();
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Error handling now uses centralized AuthErrorMapper utility
}

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  );
});
