import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../data/models/remedy.dart';
import '../data/repositories/remedies_repository.dart';
import '../data/repositories/local_remedies_repository.dart';

// import '../services/firestore_service.dart';
// import '../data/repositories/firestore_remedies_repository.dart';
/// State for the Remedies feature
class RemediesState {
  final List<Remedy> remedies;
  final List<Remedy> filteredRemedies;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  // final Set<String> favoriteIds;
  final bool isLoading;
  final String? error;

  const RemediesState({
    this.remedies = const [],
    this.filteredRemedies = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
    // this.favoriteIds = const {},
    this.isLoading = false,
    this.error,
  });

  RemediesState copyWith({
    List<Remedy>? remedies,
    List<Remedy>? filteredRemedies,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    Set<String>? favoriteIds,
    bool? isLoading,
    String? error,
    bool clearCategory = false,
    bool clearError = false,
  }) {
    return RemediesState(
      remedies: remedies ?? this.remedies,
      filteredRemedies: filteredRemedies ?? this.filteredRemedies,
      categories: categories ?? this.categories,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,

      // favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Check if filters are active
  bool get hasFilters => selectedCategory != null || searchQuery.isNotEmpty;
}

/// Notifier for managing Remedies state and logic
class RemediesNotifier extends StateNotifier<RemediesState> {
  final RemediesRepository _repository;

  RemediesNotifier(this._repository) : super(const RemediesState()) {
    loadRemedies();
  }

  /// Load all remedies
  Future<void> loadRemedies() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final remedies = await _repository.getRemedies();
      final categories = await _repository.getCategories();

      state = state.copyWith(
        remedies: remedies,
        filteredRemedies: remedies,
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load remedies: $e',
      );
    }
  }

  /// Filter by category
  void filterByCategory(String? category) {
    if (category == 'All') {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
    _applyFilters();
  }

  /// Search remedies
  void searchRemedies(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Apply all active filters
  void _applyFilters() {
    var filtered = state.remedies;

    // Apply category filter
    if (state.selectedCategory != null) {
      filtered =
          filtered.where((r) => r.category == state.selectedCategory).toList();
    }

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((r) {
        return r.title.toLowerCase().contains(query) ||
            r.titleHindi.contains(query) ||
            r.description.toLowerCase().contains(query) ||
            r.healthGoals.any((g) => g.toLowerCase().contains(query));
      }).toList();
    }

    state = state.copyWith(filteredRemedies: filtered);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      clearCategory: true,
      searchQuery: '',
      filteredRemedies: state.remedies,
    );
  }
}

/// Get icon for health goal/category
IconData getIconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'immunity':
      return Icons.verified_user_outlined;
    case 'digestion':
      return Icons.water_drop_outlined;
    case 'stress':
      return Icons.nightlight_outlined;
    case 'skin':
      return Icons.face_outlined;
    case 'respiratory':
      return Icons.air;
    case 'sleep':
      return Icons.bed_outlined;
    default:
      return Icons.medical_services_outlined;
  }
}

/// Provider for RemediesRepository
final remediesRepositoryProvider = Provider<RemediesRepository>((ref) {
  // Switch to FirestoreRemediesRepository for production
  // return FirestoreRemediesRepository(ref.watch(firestoreProvider));

  return LocalRemediesRepository();
});

/// Provider for Remedies
final remediesProvider =
    StateNotifierProvider<RemediesNotifier, RemediesState>((ref) {
  return RemediesNotifier(ref.watch(remediesRepositoryProvider));
});

/// Provider for remedy by ID
final remedyByIdProvider = Provider.family<Remedy?, String>((ref, id) {
  final remedies = ref.watch(remediesProvider).remedies;
  try {
    return remedies.firstWhere((r) => r.id == id);
  } catch (_) {
    return null;
  }
});

/// Provider for favorite remedies
/// Provider for favorite remedies
final favoriteRemediesProvider = Provider<List<Remedy>>((ref) {
  final remediesState = ref.watch(remediesProvider);
  final userProfile = ref.watch(userProfileProvider);

  if (userProfile == null) return [];

  final favIds = userProfile.favoriteRemedyIds;
  return remediesState.remedies.where((r) => favIds.contains(r.id)).toList();
});

/// Provider for categories with 'All' option
final remedyCategoriesProvider = Provider<List<String>>((ref) {
  final categories = ref.watch(remediesProvider).categories;
  return ['All', ...categories];
});
