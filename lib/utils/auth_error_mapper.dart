import 'package:firebase_auth/firebase_auth.dart';

/// Maps Firebase Auth error codes to user-friendly messages.
/// This prevents raw exception strings from being shown to users.
class AuthErrorMapper {
  AuthErrorMapper._(); // Private constructor

  /// Converts a FirebaseAuthException code to a user-friendly message.
  static String mapErrorCode(String code) {
    switch (code) {
      // Sign-in errors
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      // Sign-up errors
      case 'email-already-in-use':
        return 'An account already exists with this email. Please sign in.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';

      // Google Sign-In errors
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Sign-in was cancelled. Please try again.';

      // Network errors
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      // Fallback
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Extracts a user-friendly message from any exception.
  /// Handles FirebaseAuthException specifically, falls back for others.
  static String getErrorMessage(Object exception) {
    if (exception is FirebaseAuthException) {
      return mapErrorCode(exception.code);
    }
    // For other exceptions, provide a generic message
    // instead of exposing internal details
    return 'An unexpected error occurred. Please try again.';
  }
}
