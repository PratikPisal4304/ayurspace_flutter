// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'आयुर्स्पेस';

  @override
  String get navHome => 'होम';

  @override
  String get navRemedies => 'उपचार';

  @override
  String get navScan => 'स्कैन';

  @override
  String get navWellness => 'स्वास्थ्य';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get greetingMorning => 'सुप्रभात';

  @override
  String get greetingAfternoon => 'शुभ दोपहर';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String get dailyTip => 'दैनिक टिप';

  @override
  String get featuredRemedies => 'विशेष उपचार';

  @override
  String get featuredPlants => 'विशेष पौधे';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get searchHint => 'उपचार, पौधे खोजें...';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get doshaQuiz => 'दोष क्विज़';

  @override
  String get plantScan => 'पौधा स्कैन';

  @override
  String get consultAi => 'AI परामर्श';

  @override
  String get myHealth => 'मेरा स्वास्थ्य';

  @override
  String get wellnessScoreTitle => 'आपका स्वास्थ्य स्कोर';

  @override
  String get wellnessKeepUp => 'बहुत अच्छा काम कर रहे हैं! 🌿';

  @override
  String get remediesSubtitle => 'पारंपरिक आयुर्वेदिक समाधान';

  @override
  String get clearFilters => 'फ़िल्टर हटाएं';

  @override
  String remediesFound(int count) {
    return '$count उपचार मिले';
  }

  @override
  String get errorGeneric => 'कुछ गलत हो गया';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get noRemediesFound => 'कोई उपचार नहीं मिला';

  @override
  String get profileBookmarks => 'बुकमार्क किए गए पौधे';

  @override
  String get profileFavorites => 'पसंदीदा उपचार';

  @override
  String get profileDoshaQuiz => 'दोष क्विज़ लें';

  @override
  String get profileHelp => 'सहायता और समर्थन';

  @override
  String get profileAbout => 'आयुर्स्पेस के बारे में';

  @override
  String get statsPlants => 'पौधे\nस्कैन किए';

  @override
  String get statsRemedies => 'उपचार\nआजमाए';

  @override
  String get statsWellness => 'स्वास्थ्य\nस्कोर';

  @override
  String get achievementsTitle => 'उपलब्धियां';

  @override
  String doshaResultTitle(String dosha) {
    return 'आपका दोष: $dosha';
  }

  @override
  String get doshaDiscover => 'अपना दोष जानें';

  @override
  String get doshaViewDetails => 'विवरण देखने के लिए टैप करें';

  @override
  String get doshaTakeQuiz => 'जानने के लिए क्विज़ लें';

  @override
  String streakDays(int count) {
    return '$count दिन की स्ट्रीक';
  }
}
