import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/data/models/plant.dart';

void main() {
  group('Plant Model', () {
    const testPlantJson = {
      'id': '1',
      'name': 'Tulsi',
      'hindi': 'तुलसी',
      'scientificName': 'Ocimum sanctum',
      'image': 'https://example.com/tulsi.jpg',
      'doshas': ['Vata', 'Kapha'],
      'benefits': ['Immunity', 'Respiratory'],
      'rating': 4.8,
      'category': 'Herbs',
      'difficulty': 'Easy',
      'season': ['Summer', 'Monsoon'],
      'description': 'Holy basil is a sacred plant.',
      'uses': ['Common cold', 'Stress relief'],
      'dosage': '5-10 leaves daily',
      'precautions': 'Avoid during pregnancy.',
      'growingTips': 'Requires 6-8 hours of sunlight.',
      'harvestTime': '90-120 days',
      'isBookmarked': true,
    };

    const testPlant = Plant(
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
      season: ['Summer', 'Monsoon'],
      description: 'Holy basil is a sacred plant.',
      uses: ['Common cold', 'Stress relief'],
      dosage: '5-10 leaves daily',
      precautions: 'Avoid during pregnancy.',
      growingTips: 'Requires 6-8 hours of sunlight.',
      harvestTime: '90-120 days',
      isBookmarked: true,
    );

    test('fromJson creates Plant from valid JSON', () {
      final plant = Plant.fromJson(testPlantJson);

      expect(plant.id, '1');
      expect(plant.name, 'Tulsi');
      expect(plant.hindi, 'तुलसी');
      expect(plant.scientificName, 'Ocimum sanctum');
      expect(plant.doshas, ['Vata', 'Kapha']);
      expect(plant.rating, 4.8);
      expect(plant.isBookmarked, true);
    });

    test('toJson converts Plant to valid JSON', () {
      final json = testPlant.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Tulsi');
      expect(json['doshas'], ['Vata', 'Kapha']);
      expect(json['rating'], 4.8);
      expect(json['isBookmarked'], true);
    });

    test('fromJson and toJson are reversible', () {
      final plant = Plant.fromJson(testPlantJson);
      final json = plant.toJson();
      final recreatedPlant = Plant.fromJson(json);

      expect(recreatedPlant, plant);
    });

    test('copyWith creates new instance with updated fields', () {
      final updatedPlant = testPlant.copyWith(
        name: 'Updated Tulsi',
        isBookmarked: false,
      );

      expect(updatedPlant.name, 'Updated Tulsi');
      expect(updatedPlant.isBookmarked, false);
      expect(updatedPlant.id, testPlant.id); // unchanged
      expect(updatedPlant.hindi, testPlant.hindi); // unchanged
    });

    test('copyWith with no arguments returns equal instance', () {
      final copiedPlant = testPlant.copyWith();

      expect(copiedPlant, testPlant);
    });

    test('isBookmarked defaults to false in fromJson', () {
      final jsonWithoutBookmark = Map<String, dynamic>.from(testPlantJson);
      jsonWithoutBookmark.remove('isBookmarked');

      final plant = Plant.fromJson(jsonWithoutBookmark);

      expect(plant.isBookmarked, false);
    });

    test('Equatable compares plants correctly', () {
      final plant1 = Plant.fromJson(testPlantJson);
      final plant2 = Plant.fromJson(testPlantJson);

      expect(plant1, plant2);
      expect(plant1.hashCode, plant2.hashCode);
    });

    test('Equatable detects different plants', () {
      final plant1 = Plant.fromJson(testPlantJson);
      final modifiedJson = Map<String, dynamic>.from(testPlantJson);
      modifiedJson['id'] = '2';
      final plant2 = Plant.fromJson(modifiedJson);

      expect(plant1, isNot(plant2));
    });
  });
}
