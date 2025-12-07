import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported languages
enum AppLanguage {
  english('en', 'English', 'English'),
  hindi('hi', 'हिंदी', 'Hindi'),
  marathi('mr', 'मराठी', 'Marathi');

  final String code;
  final String nativeName;
  final String englishName;

  const AppLanguage(this.code, this.nativeName, this.englishName);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Language notifier
class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english);

  void setLanguage(AppLanguage language) {
    state = language;
  }

  void setLanguageByCode(String code) {
    state = AppLanguage.fromCode(code);
  }
}

/// Language provider
final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>(
  (ref) => LanguageNotifier(),
);
