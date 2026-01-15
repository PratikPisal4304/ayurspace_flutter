import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/plant.dart';
import '../data/repositories/plants_repository.dart';
import '../data/repositories/local_plants_repository.dart';
// import '../services/firestore_service.dart';
// import '../data/repositories/firestore_plants_repository.dart';

/// Plants state with error handling
class PlantsState {
  final List<Plant> plants;
  final List<Plant> filteredPlants;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedDosha;
  final String? selectedDifficulty;
  final bool isLoading;
  final String? error;

  const PlantsState({
    this.plants = const [],
    this.filteredPlants = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedDosha,
    this.selectedDifficulty,
    this.isLoading = false,
    this.error,
  });

  PlantsState copyWith({
    List<Plant>? plants,
    List<Plant>? filteredPlants,
    String? searchQuery,
    String? selectedCategory,
    String? selectedDosha,
    String? selectedDifficulty,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearFilters = false,
  }) {
    return PlantsState(
      plants: plants ?? this.plants,
      filteredPlants: filteredPlants ?? this.filteredPlants,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearFilters ? null : (selectedCategory ?? this.selectedCategory),
      selectedDosha: clearFilters ? null : (selectedDosha ?? this.selectedDosha),
      selectedDifficulty: clearFilters ? null : (selectedDifficulty ?? this.selectedDifficulty),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Repository provider for dependency injection
final plantsRepositoryProvider = Provider<PlantsRepository>((ref) {
  // Switch to FirestorePlantsRepository for production
  // return FirestorePlantsRepository(ref.watch(firestoreProvider));
  
  // Keeping LocalPlantsRepository active for now ensuring data visibility
  // until Firestore is populated.
  return LocalPlantsRepository();
});

/// Plants notifier with repository pattern
class PlantsNotifier extends StateNotifier<PlantsState> {
  final PlantsRepository _repository;

  PlantsNotifier(this._repository) : super(const PlantsState()) {
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final plants = await _repository.getPlants();
      state = state.copyWith(
        plants: plants,
        filteredPlants: plants,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load plants: ${e.toString()}',
      );
    }
  }

  /// Refresh plants from repository
  Future<void> refreshPlants() async {
    await _loadPlants();
  }

  /// Search plants by name or scientific name
  void searchPlants(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Filter by category
  void filterByCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  /// Filter by dosha
  void filterByDosha(String? dosha) {
    state = state.copyWith(selectedDosha: dosha);
    _applyFilters();
  }

  /// Filter by difficulty
  void filterByDifficulty(String? difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      filteredPlants: state.plants,
      clearFilters: true,
    );
  }

  void _applyFilters() {
    var filtered = state.plants.toList();

    // Search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((plant) {
        return plant.name.toLowerCase().contains(query) ||
            plant.scientificName.toLowerCase().contains(query) ||
            plant.hindi.contains(query) ||
            plant.benefits.any((b) => b.toLowerCase().contains(query));
      }).toList();
    }

    // Category filter
    if (state.selectedCategory != null) {
      filtered = filtered
          .where((plant) => plant.category == state.selectedCategory)
          .toList();
    }

    // Dosha filter
    if (state.selectedDosha != null) {
      filtered = filtered
          .where((plant) => plant.doshas.contains(state.selectedDosha))
          .toList();
    }

    // Difficulty filter
    if (state.selectedDifficulty != null) {
      filtered = filtered
          .where((plant) => plant.difficulty == state.selectedDifficulty)
          .toList();
    }

    state = state.copyWith(filteredPlants: filtered);
  }

  /// Toggle bookmark on a plant
  void toggleBookmark(String plantId) {
    final updatedPlants = state.plants.map((plant) {
      if (plant.id == plantId) {
        return plant.copyWith(isBookmarked: !plant.isBookmarked);
      }
      return plant;
    }).toList();

    state = state.copyWith(plants: updatedPlants);
    _applyFilters();
  }

  /// Get bookmarked plants
  List<Plant> get bookmarkedPlants =>
      state.plants.where((p) => p.isBookmarked).toList();
}

/// Plants provider with repository injection
final plantsProvider = StateNotifierProvider<PlantsNotifier, PlantsState>(
  (ref) => PlantsNotifier(ref.watch(plantsRepositoryProvider)),
);

/// Single plant provider
final plantByIdProvider = Provider.family<Plant?, String>((ref, id) {
  final state = ref.watch(plantsProvider);
  try {
    return state.plants.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

/// Bookmarked plants provider
final bookmarkedPlantsProvider = Provider<List<Plant>>((ref) {
  final state = ref.watch(plantsProvider);
  return state.plants.where((p) => p.isBookmarked).toList();
});
