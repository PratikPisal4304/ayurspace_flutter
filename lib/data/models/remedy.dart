import 'package:equatable/equatable.dart';
import 'dosha.dart';

/// Represents an Ayurvedic remedy
class Remedy extends Equatable {
  final String id;
  final String title;
  final String titleHindi;
  final String description;
  final String descriptionHindi;
  final String category;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final List<String> stepsHindi;
  final List<DoshaType> doshaTypes;
  final List<String> healthGoals;
  final String duration;
  final String difficulty;
  final String? image;
  final String? dosage;
  final String? precautions;
  final bool isFavorite;

  const Remedy({
    required this.id,
    required this.title,
    this.titleHindi = '',
    required this.description,
    this.descriptionHindi = '',
    required this.category,
    required this.ingredients,
    required this.steps,
    this.stepsHindi = const [],
    required this.doshaTypes,
    required this.healthGoals,
    required this.duration,
    required this.difficulty,
    this.image,
    this.dosage,
    this.precautions,
    this.isFavorite = false,
  });

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleHindi: json['titleHindi'] as String? ?? '',
      description: json['description'] as String? ?? '',
      descriptionHindi: json['descriptionHindi'] as String? ?? '',
      category: json['category'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      stepsHindi: (json['stepsHindi'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      doshaTypes: (json['doshaTypes'] as List<dynamic>?)?.map((e) {
            final str = e.toString().toLowerCase();
            return DoshaType.values
                .firstWhere((d) => d.name == str, orElse: () => DoshaType.vata);
          }).toList() ??
          const [],
      healthGoals: (json['healthGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      duration: json['duration'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      image: json['image'] as String?,
      dosage: json['dosage'] as String?,
      precautions: json['precautions'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleHindi': titleHindi,
      'description': description,
      'descriptionHindi': descriptionHindi,
      'category': category,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'stepsHindi': stepsHindi,
      'doshaTypes': doshaTypes.map((e) => e.name).toList(),
      'healthGoals': healthGoals,
      'duration': duration,
      'difficulty': difficulty,
      'image': image,
      'dosage': dosage,
      'precautions': precautions,
      'isFavorite': isFavorite,
    };
  }

  Remedy copyWith({
    String? id,
    String? title,
    String? titleHindi,
    String? description,
    String? descriptionHindi,
    String? category,
    List<Ingredient>? ingredients,
    List<String>? steps,
    List<String>? stepsHindi,
    List<DoshaType>? doshaTypes,
    List<String>? healthGoals,
    String? duration,
    String? difficulty,
    String? image,
    String? dosage,
    String? precautions,
    bool? isFavorite,
  }) {
    return Remedy(
      id: id ?? this.id,
      title: title ?? this.title,
      titleHindi: titleHindi ?? this.titleHindi,
      description: description ?? this.description,
      descriptionHindi: descriptionHindi ?? this.descriptionHindi,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      stepsHindi: stepsHindi ?? this.stepsHindi,
      doshaTypes: doshaTypes ?? this.doshaTypes,
      healthGoals: healthGoals ?? this.healthGoals,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      image: image ?? this.image,
      dosage: dosage ?? this.dosage,
      precautions: precautions ?? this.precautions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        ingredients,
        steps,
        doshaTypes,
        healthGoals,
        duration,
        difficulty,
        isFavorite,
      ];
}

/// Ingredient in a remedy
class Ingredient extends Equatable {
  final String id;
  final String name;
  final String nameHindi;
  final String quantity;
  final bool optional;
  final List<String> substitutes;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameHindi: json['nameHindi'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      optional: json['optional'] as bool? ?? false,
      substitutes: (json['substitutes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameHindi': nameHindi,
      'quantity': quantity,
      'optional': optional,
      'substitutes': substitutes,
    };
  }

  const Ingredient({
    required this.id,
    required this.name,
    this.nameHindi = '',
    required this.quantity,
    this.optional = false,
    this.substitutes = const [],
  });

  @override
  List<Object?> get props => [id, name, quantity, optional, substitutes];
}
