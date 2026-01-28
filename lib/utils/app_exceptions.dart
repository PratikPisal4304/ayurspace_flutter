// Centralized exception types for the AyurSpace application.
// Using typed exceptions instead of throwing raw strings
// enables better error handling and type safety.

/// Base exception class for all app exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// Exception for Firestore-related errors
class FirestoreException extends AppException {
  const FirestoreException(
    super.message, {
    super.code,
    super.originalError,
  });

  /// Factory constructor for common Firestore errors
  factory FirestoreException.fromError(Object error) {
    final errorString = error.toString();
    
    if (errorString.contains('permission-denied')) {
      return const FirestoreException(
        'You do not have permission to perform this action.',
        code: 'permission-denied',
      );
    }
    
    if (errorString.contains('not-found')) {
      return const FirestoreException(
        'The requested data was not found.',
        code: 'not-found',
      );
    }
    
    if (errorString.contains('unavailable')) {
      return FirestoreException(
        'Service temporarily unavailable. Please check your connection.',
        code: 'unavailable',
        originalError: error,
      );
    }
    
    return FirestoreException(
      'A database error occurred. Please try again.',
      originalError: error,
    );
  }
}

/// Exception for authentication-related errors
class AuthException extends AppException {
  const AuthException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception for API-related errors (Plant.id, Gemini, etc.)
class ApiException extends AppException {
  final int? statusCode;

  const ApiException(
    super.message, {
    super.code,
    super.originalError,
    this.statusCode,
  });
}
