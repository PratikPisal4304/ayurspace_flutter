import 'package:equatable/equatable.dart';
import 'dosha.dart';

/// User profile information
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final DoshaResult? doshaResult;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserSettings settings;
  final UserStats stats;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.doshaResult,
    required this.createdAt,
    required this.updatedAt,
    this.settings = const UserSettings(),
    this.stats = const UserStats(),
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    DoshaResult? doshaResult,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserSettings? settings,
    UserStats? stats,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      doshaResult: doshaResult ?? this.doshaResult,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatarUrl,
        doshaResult,
        createdAt,
        updatedAt,
      ];
}

/// User app settings
class UserSettings extends Equatable {
  final String language;
  final bool notificationsEnabled;
  final bool darkMode;
  final bool autoBackup;
  final String unitSystem;

  const UserSettings({
    this.language = 'en',
    this.notificationsEnabled = true,
    this.darkMode = false,
    this.autoBackup = true,
    this.unitSystem = 'metric',
  });

  UserSettings copyWith({
    String? language,
    bool? notificationsEnabled,
    bool? darkMode,
    bool? autoBackup,
    String? unitSystem,
  }) {
    return UserSettings(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      autoBackup: autoBackup ?? this.autoBackup,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }

  @override
  List<Object?> get props => [
        language,
        notificationsEnabled,
        darkMode,
        autoBackup,
        unitSystem,
      ];
}

/// User activity statistics
class UserStats extends Equatable {
  final int plantsScanned;
  final int remediesTried;
  final int herbsGrowing;
  final int bookmarkedPlants;
  final int favoriteRemedies;
  final int wellnessScore;

  const UserStats({
    this.plantsScanned = 0,
    this.remediesTried = 0,
    this.herbsGrowing = 0,
    this.bookmarkedPlants = 0,
    this.favoriteRemedies = 0,
    this.wellnessScore = 0,
  });

  UserStats copyWith({
    int? plantsScanned,
    int? remediesTried,
    int? herbsGrowing,
    int? bookmarkedPlants,
    int? favoriteRemedies,
    int? wellnessScore,
  }) {
    return UserStats(
      plantsScanned: plantsScanned ?? this.plantsScanned,
      remediesTried: remediesTried ?? this.remediesTried,
      herbsGrowing: herbsGrowing ?? this.herbsGrowing,
      bookmarkedPlants: bookmarkedPlants ?? this.bookmarkedPlants,
      favoriteRemedies: favoriteRemedies ?? this.favoriteRemedies,
      wellnessScore: wellnessScore ?? this.wellnessScore,
    );
  }

  @override
  List<Object?> get props => [
        plantsScanned,
        remediesTried,
        herbsGrowing,
        bookmarkedPlants,
        favoriteRemedies,
        wellnessScore,
      ];
}
