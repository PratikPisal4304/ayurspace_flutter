import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/providers/remedies_provider.dart';
import 'package:ayurspace_flutter/data/models/remedy.dart';
import 'package:ayurspace_flutter/data/models/dosha.dart';
import 'package:ayurspace_flutter/data/repositories/remedies_repository.dart';

// --- Fakes ---

class MockRemediesRepository extends Fake implements RemediesRepository {
  @override
  Future<List<Remedy>> getRemedies() async {
    return [
      const Remedy(
        id: '1',
        title: 'Turmeric Tea',
        description: 'Healing tea',
        category: 'Immunity',
        ingredients: [],
        steps: [],
        doshaTypes: [DoshaType.kapha],
        healthGoals: ['Boost immunity'],
        duration: '5 mins',
        difficulty: 'Easy',
      ),
      const Remedy(
        id: '2',
        title: 'Ashwagandha Milk',
        description: 'Relaxing drink',
        category: 'Stress',
        ingredients: [],
        steps: [],
        doshaTypes: [DoshaType.vata],
        healthGoals: ['Reduce stress'],
        duration: '10 mins',
        difficulty: 'Medium',
      ),
    ];
  }

  @override
  Future<List<String>> getCategories() async {
    return ['Immunity', 'Stress'];
  }
}

void main() {
  late MockRemediesRepository mockRepository;
  late RemediesNotifier notifier;

  setUp(() {
    mockRepository = MockRemediesRepository();
    // RemediesNotifier calls loadRemedies() in constructor
    notifier = RemediesNotifier(mockRepository); 
  });

  group('RemediesNotifier Tests', () {
    test('Initial load populates state', () async {
      // Allow constructor async call to complete
      await Future.delayed(Duration.zero);
      
      expect(notifier.state.remedies.length, 2);
      expect(notifier.state.filteredRemedies.length, 2);
      expect(notifier.state.categories.length, 2);
      expect(notifier.state.isLoading, isFalse);
    });

    test('filterByCategory filters remedies', () async {
      await Future.delayed(Duration.zero);

      notifier.filterByCategory('Immunity');

      expect(notifier.state.filteredRemedies.length, 1);
      expect(notifier.state.filteredRemedies.first.title, 'Turmeric Tea');
      expect(notifier.state.selectedCategory, 'Immunity');
    });
    
    test('filterByCategory(All) clears category filter', () async {
       await Future.delayed(Duration.zero);
       notifier.filterByCategory('Immunity');
       expect(notifier.state.filteredRemedies.length, 1);
       
       notifier.filterByCategory('All');
       expect(notifier.state.filteredRemedies.length, 2);
       expect(notifier.state.selectedCategory, isNull);
    });

    test('searchRemedies filters by title', () async {
      await Future.delayed(Duration.zero);

      notifier.searchRemedies('Turmeric');

      expect(notifier.state.filteredRemedies.length, 1);
      expect(notifier.state.filteredRemedies.first.title, 'Turmeric Tea');
      expect(notifier.state.searchQuery, 'Turmeric');
    });

    test('Combined filter and search', () async {
      await Future.delayed(Duration.zero);

      // Filter by Stress (expects 'Ashwagandha Milk')
      notifier.filterByCategory('Stress');
      expect(notifier.state.filteredRemedies.length, 1);

      // Search for 'Milk' (matches)
      notifier.searchRemedies('Milk');
      expect(notifier.state.filteredRemedies.length, 1);

      // Search for 'Tea' (no match in Stress category)
      notifier.searchRemedies('Tea');
      expect(notifier.state.filteredRemedies.length, 0);
    });
    

  });
}
