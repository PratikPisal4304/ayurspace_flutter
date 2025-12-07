import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/plant.dart';
import '../data/sources/plants_data.dart';

/// Plants state
class PlantsState {
  final List<Plant> plants;
  final List<Plant> filteredPlants;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedDosha;
  final String? selectedDifficulty;
  final bool isLoading;

  const PlantsState({
    this.plants = const [],
    this.filteredPlants = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedDosha,
    this.selectedDifficulty,
    this.isLoading = false,
  });

  PlantsState copyWith({
    List<Plant>? plants,
    List<Plant>? filteredPlants,
    String? searchQuery,
    String? selectedCategory,
    String? selectedDosha,
    String? selectedDifficulty,
    bool? isLoading,
  }) {
    return PlantsState(
      plants: plants ?? this.plants,
      filteredPlants: filteredPlants ?? this.filteredPlants,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDosha: selectedDosha ?? this.selectedDosha,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Plants notifier
class PlantsNotifier extends StateNotifier<PlantsState> {
  PlantsNotifier() : super(const PlantsState()) {
    _loadPlants();
  }

  void _loadPlants() {
    state = state.copyWith(
      plants: plantsData,
      filteredPlants: plantsData,
      isLoading: false,
    );
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
      selectedCategory: null,
      selectedDosha: null,
      selectedDifficulty: null,
      filteredPlants: state.plants,
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

/// Plants provider
final plantsProvider = StateNotifierProvider<PlantsNotifier, PlantsState>(
  (ref) => PlantsNotifier(),
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
