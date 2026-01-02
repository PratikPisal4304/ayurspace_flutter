import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track Firebase initialization state
final firebaseInitializedProvider = StateProvider<bool>((ref) => false);
