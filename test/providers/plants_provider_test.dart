import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/data/models/plant.dart';
import 'package:ayurspace_flutter/data/repositories/plants_repository.dart';
import 'package:ayurspace_flutter/providers/plants_provider.dart';

/// Mock repository for testing
class MockPlantsRepository implements PlantsRepository {
  final List<Plant> _plants;
  final bool shouldThrow;

  MockPlantsRepository({
    List<Plant>? plants,
    this.shouldThrow = false,
  }) : _plants = plants ?? _defaultPlants;

  static final _defaultPlants = [
    const Plant(
      id: '1',
      name: 'Tulsi',
      hindi: 'तुलसी',
      scientificName: 'Ocimum sanctum',
      image: 'https://example.com/tulsi.jpg',
      doshas: ['Vata', 'Kapha'],
      benefits: ['Immunity', 'Respiratory'],
      rating: 4.8,
      category: 'Herbs',
      difficulty: 'Easy',
      season: ['Summer'],
      description: 'Holy basil',
      uses: ['Cold'],
      dosage: '5 leaves',
      precautions: 'None',
      growingTips: 'Sun',
      harvestTime: '90 days',
    ),
    const Plant(
      id: '2',
      name: 'Ashwagandha',
      hindi: 'अश्वगंधा',
      scientificName: 'Withania somnifera',
      image: 'https://example.com/ashwa.jpg',
      doshas: ['Vata', 'Kapha'],
      benefits: ['Energy', 'Stress'],
      rating: 4.9,
      category: 'Roots',
      difficulty: 'Medium',
      season: ['Winter'],
      description: 'Indian Ginseng',
      uses: ['Fatigue'],
      dosage: '300mg',
      precautions: 'Pregnancy',
      growingTips: 'Dry soil',
      harvestTime: '150 days',
    ),
    const Plant(
      id: '3',
      name: 'Neem',
      hindi: 'नीम',
      scientificName: 'Azadirachta indica',
      image: 'https://example.com/neem.jpg',
      doshas: ['Pitta', 'Kapha'],
      benefits: ['Skin', 'Blood Purifier'],
      rating: 4.7,
      category: 'Bark',
      difficulty: 'Easy',
      season: ['All Seasons'],
      description: "Nature's pharmacy",
      uses: ['Skin infections'],
      dosage: '2-4 leaves',
      precautions: 'Pregnancy',
      growingTips: 'Hardy tree',
      harvestTime: 'Year-round',
    ),
  ];

  @override
  Future<List<Plant>> getPlants() async {
    if (shouldThrow) {
      throw Exception('Mock repository error');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    return _plants;
  }

  @override
  Future<Plant?> getPlantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    try {
      return _plants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Plant>> searchPlants(String query) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final lowerQuery = query.toLowerCase();
    return _plants.where((p) => p.name.toLowerCase().contains(lowerQuery)).toList();
  }
}

void main() {
  group('PlantsNotifier', () {
    test('initializes with loading state and loads plants', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      
      // Wait for async load to complete
      await Future.delayed(const Duration(milliseconds: 50));
      
      expect(notifier.state.plants.length, 3);
      expect(notifier.state.filteredPlants.length, 3);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, null);
    });

    test('handles repository error gracefully', () async {
      final notifier = PlantsNotifier(MockPlantsRepository(shouldThrow: true));
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      expect(notifier.state.plants, isEmpty);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNotNull);
      expect(notifier.state.error, contains('Failed to load plants'));
    });

    test('searchPlants filters by name', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.searchPlants('tulsi');
      
      expect(notifier.state.filteredPlants.length, 1);
      expect(notifier.state.filteredPlants.first.name, 'Tulsi');
      expect(notifier.state.searchQuery, 'tulsi');
    });

    test('searchPlants filters by scientific name', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.searchPlants('withania');
      
      expect(notifier.state.filteredPlants.length, 1);
      expect(notifier.state.filteredPlants.first.name, 'Ashwagandha');
    });

    test('filterByCategory filters correctly', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.filterByCategory('Herbs');
      
      expect(notifier.state.filteredPlants.length, 1);
      expect(notifier.state.filteredPlants.first.category, 'Herbs');
    });

    test('filterByDosha filters correctly', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.filterByDosha('Pitta');
      
      expect(notifier.state.filteredPlants.length, 1);
      expect(notifier.state.filteredPlants.first.name, 'Neem');
    });

    test('filterByDifficulty filters correctly', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.filterByDifficulty('Medium');
      
      expect(notifier.state.filteredPlants.length, 1);
      expect(notifier.state.filteredPlants.first.name, 'Ashwagandha');
    });

    test('clearFilters resets all filters', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.searchPlants('tulsi');
      notifier.filterByCategory('Herbs');
      expect(notifier.state.filteredPlants.length, 1);
      
      notifier.clearFilters();
      
      expect(notifier.state.filteredPlants.length, 3);
      expect(notifier.state.searchQuery, '');
      expect(notifier.state.selectedCategory, null);
    });

    test('toggleBookmark toggles plant bookmark state', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      expect(notifier.state.plants.first.isBookmarked, false);
      
      notifier.toggleBookmark('1');
      
      expect(notifier.state.plants.first.isBookmarked, true);
      
      notifier.toggleBookmark('1');
      
      expect(notifier.state.plants.first.isBookmarked, false);
    });

    test('bookmarkedPlants returns only bookmarked plants', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.toggleBookmark('1');
      notifier.toggleBookmark('3');
      
      final bookmarked = notifier.bookmarkedPlants;
      
      expect(bookmarked.length, 2);
      expect(bookmarked.map((p) => p.id).toList(), ['1', '3']);
    });

    test('multiple filters combine correctly', () async {
      final notifier = PlantsNotifier(MockPlantsRepository());
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.filterByDosha('Kapha');
      expect(notifier.state.filteredPlants.length, 3); // All have Kapha
      
      notifier.filterByDifficulty('Easy');
      expect(notifier.state.filteredPlants.length, 2); // Tulsi and Neem
    });
  });
}
