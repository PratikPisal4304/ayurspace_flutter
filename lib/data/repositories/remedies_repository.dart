import '../models/remedy.dart';

/// Abstract repository interface for remedies data
/// Follows the same pattern as PlantsRepository for consistency
abstract class RemediesRepository {
  /// Get all remedies
  Future<List<Remedy>> getRemedies();

  /// Get a remedy by ID
  Future<Remedy?> getRemedyById(String id);

  /// Get remedies by category
  Future<List<Remedy>> getRemediesByCategory(String category);

  /// Search remedies by query
  Future<List<Remedy>> searchRemedies(String query);

  /// Get all categories
  Future<List<String>> getCategories();
}
