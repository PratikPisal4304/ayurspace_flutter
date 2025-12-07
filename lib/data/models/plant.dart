import 'package:equatable/equatable.dart';

/// Represents an Ayurvedic medicinal plant
class Plant extends Equatable {
  final String id;
  final String name;
  final String hindi;
  final String scientificName;
  final String image;
  final List<String> doshas;
  final List<String> benefits;
  final double rating;
  final String category;
  final String difficulty;
  final List<String> season;
  final String description;
  final List<String> uses;
  final String dosage;
  final String precautions;
  final String growingTips;
  final String harvestTime;
  final bool isBookmarked;

  const Plant({
    required this.id,
    required this.name,
    required this.hindi,
    required this.scientificName,
    required this.image,
    required this.doshas,
    required this.benefits,
    required this.rating,
    required this.category,
    required this.difficulty,
    required this.season,
    required this.description,
    required this.uses,
    required this.dosage,
    required this.precautions,
    required this.growingTips,
    required this.harvestTime,
    this.isBookmarked = false,
  });

  /// Create a copy with modified fields
  Plant copyWith({
    String? id,
    String? name,
    String? hindi,
    String? scientificName,
    String? image,
    List<String>? doshas,
    List<String>? benefits,
    double? rating,
    String? category,
    String? difficulty,
    List<String>? season,
    String? description,
    List<String>? uses,
    String? dosage,
    String? precautions,
    String? growingTips,
    String? harvestTime,
    bool? isBookmarked,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      hindi: hindi ?? this.hindi,
      scientificName: scientificName ?? this.scientificName,
      image: image ?? this.image,
      doshas: doshas ?? this.doshas,
      benefits: benefits ?? this.benefits,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      season: season ?? this.season,
      description: description ?? this.description,
      uses: uses ?? this.uses,
      dosage: dosage ?? this.dosage,
      precautions: precautions ?? this.precautions,
      growingTips: growingTips ?? this.growingTips,
      harvestTime: harvestTime ?? this.harvestTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// Create from JSON/Map
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      name: json['name'] as String,
      hindi: json['hindi'] as String,
      scientificName: json['scientificName'] as String,
      image: json['image'] as String,
      doshas: List<String>.from(json['doshas'] as List),
      benefits: List<String>.from(json['benefits'] as List),
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      season: List<String>.from(json['season'] as List),
      description: json['description'] as String,
      uses: List<String>.from(json['uses'] as List),
      dosage: json['dosage'] as String,
      precautions: json['precautions'] as String,
      growingTips: json['growingTips'] as String,
      harvestTime: json['harvestTime'] as String,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  /// Convert to JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hindi': hindi,
      'scientificName': scientificName,
      'image': image,
      'doshas': doshas,
      'benefits': benefits,
      'rating': rating,
      'category': category,
      'difficulty': difficulty,
      'season': season,
      'description': description,
      'uses': uses,
      'dosage': dosage,
      'precautions': precautions,
      'growingTips': growingTips,
      'harvestTime': harvestTime,
      'isBookmarked': isBookmarked,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        hindi,
        scientificName,
        image,
        doshas,
        benefits,
        rating,
        category,
        difficulty,
        season,
        description,
        uses,
        dosage,
        precautions,
        growingTips,
        harvestTime,
        isBookmarked,
      ];
}
