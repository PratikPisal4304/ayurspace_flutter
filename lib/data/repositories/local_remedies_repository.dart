import '../models/remedy.dart';
import '../sources/remedies_data.dart';
import 'remedies_repository.dart';

/// Local implementation of RemediesRepository using static data
/// Follows the same pattern as LocalPlantsRepository for consistency
class LocalRemediesRepository implements RemediesRepository {
  @override
  Future<List<Remedy>> getRemedies() async {
    // Simulate network delay for realistic behavior
    await Future.delayed(const Duration(milliseconds: 300));
    return remediesData;
  }

  @override
  Future<Remedy?> getRemedyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return remediesData.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Remedy>> getRemediesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (category == 'All' || category.isEmpty) {
      return remediesData;
    }
    return remediesData.where((r) => r.category == category).toList();
  }

  @override
  Future<List<Remedy>> searchRemedies(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return remediesData;

    final q = query.toLowerCase();
    return remediesData
        .where((r) =>
            r.title.toLowerCase().contains(q) ||
            r.titleHindi.contains(q) ||
            r.description.toLowerCase().contains(q) ||
            r.healthGoals.any((g) => g.toLowerCase().contains(q)) ||
            r.category.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return remediesData.map((r) => r.category).toSet().toList()..sort();
  }
}
