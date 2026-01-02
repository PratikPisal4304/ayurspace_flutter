import 'plants_repository.dart';
import '../models/plant.dart';
import '../sources/plants_data.dart';

/// Local implementation of PlantsRepository using static data
class LocalPlantsRepository implements PlantsRepository {
  @override
  Future<List<Plant>> getPlants() async {
    // Simulate network delay for future API compatibility
    await Future.delayed(const Duration(milliseconds: 100));
    return plantsData;
  }

  @override
  Future<Plant?> getPlantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return plantsData.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Plant>> searchPlants(String query) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final lowerQuery = query.toLowerCase();
    return plantsData.where((plant) {
      return plant.name.toLowerCase().contains(lowerQuery) ||
          plant.scientificName.toLowerCase().contains(lowerQuery) ||
          plant.hindi.contains(query) ||
          plant.benefits.any((b) => b.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
