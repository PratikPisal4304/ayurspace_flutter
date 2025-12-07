import 'package:equatable/equatable.dart';

/// Dosha types in Ayurveda
enum DoshaType {
  vata,
  pitta,
  kapha;

  String get displayName {
    switch (this) {
      case DoshaType.vata:
        return 'Vata';
      case DoshaType.pitta:
        return 'Pitta';
      case DoshaType.kapha:
        return 'Kapha';
    }
  }

  String get hindi {
    switch (this) {
      case DoshaType.vata:
        return 'वात';
      case DoshaType.pitta:
        return 'पित्त';
      case DoshaType.kapha:
        return 'कफ';
    }
  }

  String get element {
    switch (this) {
      case DoshaType.vata:
        return 'Air & Space';
      case DoshaType.pitta:
        return 'Fire & Water';
      case DoshaType.kapha:
        return 'Earth & Water';
    }
  }

  String get description {
    switch (this) {
      case DoshaType.vata:
        return 'Creative, quick-thinking, and energetic. Governs movement and communication.';
      case DoshaType.pitta:
        return 'Intelligent, focused, and determined. Governs digestion and metabolism.';
      case DoshaType.kapha:
        return 'Calm, steady, and nurturing. Governs structure and stability.';
    }
  }

  static DoshaType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'vata':
        return DoshaType.vata;
      case 'pitta':
        return DoshaType.pitta;
      case 'kapha':
        return DoshaType.kapha;
      default:
        return DoshaType.vata;
    }
  }
}

/// Result from dosha assessment
class DoshaResult extends Equatable {
  final double vata;
  final double pitta;
  final double kapha;
  final DoshaType dominant;
  final DateTime? assessedAt;

  const DoshaResult({
    required this.vata,
    required this.pitta,
    required this.kapha,
    required this.dominant,
    this.assessedAt,
  });

  /// Get percentage for each dosha
  double get total => vata + pitta + kapha;
  double get vataPercent => total > 0 ? (vata / total) * 100 : 0;
  double get pittaPercent => total > 0 ? (pitta / total) * 100 : 0;
  double get kaphaPercent => total > 0 ? (kapha / total) * 100 : 0;

  /// Calculate dominant dosha from scores
  factory DoshaResult.calculate({
    required double vata,
    required double pitta,
    required double kapha,
  }) {
    DoshaType dominant;
    if (vata >= pitta && vata >= kapha) {
      dominant = DoshaType.vata;
    } else if (pitta >= vata && pitta >= kapha) {
      dominant = DoshaType.pitta;
    } else {
      dominant = DoshaType.kapha;
    }

    return DoshaResult(
      vata: vata,
      pitta: pitta,
      kapha: kapha,
      dominant: dominant,
      assessedAt: DateTime.now(),
    );
  }

  factory DoshaResult.fromJson(Map<String, dynamic> json) {
    return DoshaResult(
      vata: (json['vata'] as num).toDouble(),
      pitta: (json['pitta'] as num).toDouble(),
      kapha: (json['kapha'] as num).toDouble(),
      dominant: DoshaType.fromString(json['dominant'] as String),
      assessedAt: json['assessedAt'] != null
          ? DateTime.parse(json['assessedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vata': vata,
      'pitta': pitta,
      'kapha': kapha,
      'dominant': dominant.name,
      'assessedAt': assessedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [vata, pitta, kapha, dominant, assessedAt];
}

/// Dosha quiz question
class DoshaQuizQuestion {
  final String id;
  final String category;
  final String question;
  final String questionHindi;
  final List<DoshaQuizOption> options;

  const DoshaQuizQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.questionHindi,
    required this.options,
  });
}

/// Dosha quiz option
class DoshaQuizOption {
  final String text;
  final String textHindi;
  final DoshaType dosha;
  final int points;

  const DoshaQuizOption({
    required this.text,
    required this.textHindi,
    required this.dosha,
    this.points = 1,
  });
}
