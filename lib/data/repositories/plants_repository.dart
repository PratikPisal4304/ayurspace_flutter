import '../models/plant.dart';

/// Abstract repository interface for plants data
abstract class PlantsRepository {
  /// Get all plants
  Future<List<Plant>> getPlants();

  /// Get a single plant by ID
  Future<Plant?> getPlantById(String id);

  /// Search plants by query
  Future<List<Plant>> searchPlants(String query);
}
