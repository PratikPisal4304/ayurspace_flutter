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
  String get navDiscover => 'खोजें';

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
  String get dailyTipContent =>
      'पाचन और ऊर्जा बढ़ाने के लिए गुनगुने पानी के साथ एक चम्मच शहद से अपना दिन शुरू करें।';

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

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get signInToContWith =>
      'अपनी स्वास्थ्य यात्रा जारी रखने के लिए साइन इन करें';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get signIn => 'साइन इन';

  @override
  String get or => 'या';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get noAccountYet => 'खाता नहीं है?';

  @override
  String get signUp => 'साइन अप';

  @override
  String get continueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get startWellnessJourney =>
      'अपनी आयुर्वेदिक स्वास्थ्य यात्रा शुरू करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get sessionComplete => 'सत्र पूर्ण!';

  @override
  String get meditationGreatJob => 'आपके ध्यान अभ्यास पर बधाई।';

  @override
  String get done => 'पूर्ण';

  @override
  String get howAreYouFeeling => 'आप कैसा महसूस कर रहे हैं?';

  @override
  String get quickMeditation => 'त्वरित ध्यान';

  @override
  String get sleepSounds => 'नींद की ध्वनियाँ';

  @override
  String nowPlaying(String sound) {
    return 'अभी बज रहा है: $sound';
  }

  @override
  String dayStreakTitle(int count) {
    return '$count दिन की स्ट्रीक!';
  }

  @override
  String get startWellnessToday => 'आज अपनी स्वास्थ्य यात्रा शुरू करें';

  @override
  String get keepItUp => 'जारी रखें! आप बहुत अच्छा कर रहे हैं।';

  @override
  String get minsMediated => 'मिनट ध्यान';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get dayStreak => 'दिन स्ट्रीक';

  @override
  String get morning => 'सुबह';

  @override
  String get evening => 'शाम';

  @override
  String get morningRoutine => 'सुबह की दिनचर्या';

  @override
  String get eveningRoutine => 'शाम की दिनचर्या';

  @override
  String get stop => 'रोकें';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get helpEmail => 'ईमेल: support@ayurspace.app';

  @override
  String get helpWebsite => 'वेबसाइट: www.ayurspace.app';

  @override
  String get faqs => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get faqScanner => 'मैं पौधा स्कैनर का उपयोग कैसे करूं?';

  @override
  String get faqDosha => 'मेरा दोष क्या है?';

  @override
  String get faqRemedies => 'क्या उपचार उपयोग करने के लिए सुरक्षित हैं?';

  @override
  String get close => 'बंद करें';

  @override
  String get aboutVersion => 'संस्करण 1.0.0';

  @override
  String get aboutDescription =>
      'आपका संपूर्ण आयुर्वेद साथी। प्राचीन ज्ञान पर आधारित पारंपरिक जड़ी-बूटियों, व्यक्तिगत उपचारों और स्वास्थ्य प्रथाओं की खोज करें।';

  @override
  String get aboutCopyright => '© 2024 आयुर्स्पेस। सर्वाधिकार सुरक्षित।';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get resetPasswordDesc =>
      'अपना ईमेल पता दर्ज करें और हम आपको पासवर्ड रीसेट करने के लिए एक लिंक भेजेंगे।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get sendLink => 'लिंक भेजें';

  @override
  String get validEmailRequired => 'कृपया एक वैध ईमेल दर्ज करें';

  @override
  String passwordResetSent(String email) {
    return '$email पर पासवर्ड रीसेट लिंक भेजा गया';
  }
}
