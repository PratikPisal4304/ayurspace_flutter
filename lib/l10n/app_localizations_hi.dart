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
  String get navChat => 'चैट';

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
  String get achievementsPlantScans => 'पौधा खोजकर्ता';

  @override
  String get achievementsRemedies => 'उपचार विशेषज्ञ';

  @override
  String get achievementsWellness => 'स्वास्थ्य गुरु';

  @override
  String get achievementsStreak => 'साप्ताहिक स्ट्रीक';

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
  String get pause => 'रुकें';

  @override
  String get resume => 'जारी रखें';

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

  @override
  String get plantAbout => 'कथा';

  @override
  String get plantBenefits => 'स्वास्थ्य लाभ';

  @override
  String get plantDoshas => 'दोष संतुलन';

  @override
  String get plantSeasons => 'सर्वोत्तम मौसम';

  @override
  String get plantCompounds => 'सक्रिय तत्व';

  @override
  String get plantUses => 'पारंपरिक उपयोग';

  @override
  String get plantDosage => 'अनुशंसित खुराक';

  @override
  String get plantPrecautions => 'सावधानियां';

  @override
  String get plantContraindications => 'निषेध';

  @override
  String get plantDifficulty => 'उगाने में कठिनाई';

  @override
  String get plantTips => 'उगाने के सुझाव';

  @override
  String get plantHarvest => 'कटाई का समय';

  @override
  String get plantDetails => 'पौधे का विवरण';

  @override
  String get plantCategory => 'श्रेणी';

  @override
  String get plantPartUsed => 'प्रयुक्त भाग';

  @override
  String get plantOrigin => 'मूल';

  @override
  String get plantDoshaBalance => 'दोष संतुलन';

  @override
  String get plantTaste => 'स्वाद (रस)';

  @override
  String get plantNames => 'नाम';

  @override
  String get nameEnglish => 'अंग्रेज़ी';

  @override
  String get nameHindi => 'हिंदी';

  @override
  String get nameScientific => 'वैज्ञानिक';

  @override
  String get nameSanskrit => 'संस्कृत';

  @override
  String get ayurvedicProps => 'आयुर्वेदिक गुण';

  @override
  String get propBalances => 'संतुलित करता है';

  @override
  String get propPotency => 'वीर्य';

  @override
  String get propPostDigestive => 'विपाक';

  @override
  String get actionFindRemedies => 'उपचार खोजें';

  @override
  String get actionSave => 'सहेजें';

  @override
  String get actionSaved => 'सहेजा गया';

  @override
  String get actionShare => 'साझा करें';

  @override
  String get tabOverview => 'अवलोकन';

  @override
  String get tabUses => 'उपयोग';

  @override
  String get tabGrowing => 'खेती';

  @override
  String get tabAyurveda => 'आयुर्वेद';

  @override
  String get scannerTitle => 'पादप स्कैनर';

  @override
  String get scannerSubtitle => 'किसी भी आयुर्वेदिक पौधे की पहचान करें';

  @override
  String get pointToIdentify => 'पहचान करने के लिए पौधे की ओर इंगित करें';

  @override
  String get clearPhotoHint => 'पत्तियों या पूरे पौधे की स्पष्ट तस्वीर लें';

  @override
  String get analyzing => 'पौधे का विश्लेषण किया जा रहा है...';

  @override
  String get aiPowered => 'Plant.id + Gemini AI का उपयोग';

  @override
  String get identificationFailed => 'पहचान विफल रही';

  @override
  String get scanAgain => 'पुनः स्कैन करें';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get fullInfo => 'पूर्ण जानकारी';

  @override
  String get recentScans => 'हालिया स्कैन';

  @override
  String get gallery => 'गैलरी';

  @override
  String get takePhoto => 'तस्वीर लें';

  @override
  String get ayurvedicInfo => 'आयुर्वेदिक जानकारी';

  @override
  String get aiDisclaimer =>
      'यह जानकारी एआई द्वारा निर्मित है। कृपया आयुर्वेदिक चिकित्सक से सत्यापित करें।';

  @override
  String get ayurvedicDatabase => 'आयुर्वेदिक डेटाबेस';

  @override
  String get aiGeneratedInfo => 'AI जनित जानकारी';

  @override
  String confidenceMatch(int percent) {
    return '$percent% मिलान';
  }

  @override
  String get moreDailyTips => 'अधिक दैनिक सुझाव जल्द आ रहे हैं!';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsNotifications => 'सूचनाएं';

  @override
  String get settingsPushNotifications => 'पुश सूचनाएं';

  @override
  String get settingsPushSubtitle => 'दैनिक सुझाव और अनुस्मारक प्राप्त करें';

  @override
  String get settingsDailyTips => 'दैनिक स्वास्थ्य सुझाव';

  @override
  String get settingsDailyTipsSubtitle =>
      'प्रतिदिन सुबह आयुर्वेदिक सुझाव प्राप्त करें';

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get settingsDarkMode => 'डार्क मोड';

  @override
  String get settingsDarkModeSubtitle => 'डार्क थीम पर स्विच करें';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageSubtitle => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get settingsData => 'डेटा और भंडारण';

  @override
  String get settingsAutoBackup => 'स्वचालित बैकअप';

  @override
  String get settingsAutoBackupSubtitle => 'क्लाउड पर डेटा बैकअप';

  @override
  String get settingsClearCache => 'कैश साफ़ करें';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsDeleteAccount => 'खाता हटाएं';

  @override
  String get settingsAbout => 'हमारे बारे में';

  @override
  String get settingsAppVersion => 'ऐप संस्करण';

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsSignOutConfirm => 'क्या आप वाकई साइन आउट करना चाहते हैं?';

  @override
  String get settingsClearCacheConfirm => 'यह सभी कैश्ड डेटा को साफ़ कर देगा।';

  @override
  String get settingsCacheCleared => 'कैश सफलतापूर्वक साफ़ किया गया';

  @override
  String get settingsDarkModeComingSoon => 'डार्क मोड जल्द आ रहा है! 🌙';

  @override
  String get settingsDeleteAccountTitle => 'खाता हटाएं';

  @override
  String get settingsDeleteAccountMsg =>
      'क्या आप वाकई अपना खाता हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती और आप अपने सभी सहेजे गए डेटा खो देंगे।';

  @override
  String get settingsDeleteAccountRequested =>
      'खाता हटाने का अनुरोध किया गया। सहायता शीघ्र ही आपसे संपर्क करेगी।';

  @override
  String get settingsSelectLanguage => 'भाषा चुनें';

  @override
  String settingsLanguageComingSoon(String lang) {
    return '$lang भाषा जल्द आ रही है!';
  }

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get editProfileSaveChanges => 'परिवर्तन सहेजें';

  @override
  String get editProfileNameShort => 'नाम कम से कम 2 अक्षर का होना चाहिए';

  @override
  String get editProfileInvalidEmail => 'कृपया एक वैध ईमेल दर्ज करें';

  @override
  String get editProfileUpdated => 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई!';

  @override
  String get editProfileSelectAvatar => 'अवतार चुनें';

  @override
  String get editProfileName => 'नाम';

  @override
  String get editProfileEmail => 'ईमेल';

  @override
  String get doshaProfileTitle => 'आपकी दोष प्रोफाइल';

  @override
  String get doshaProfileNoAssessment => 'आपका दोष';

  @override
  String get doshaDiscoverTitle => 'अपना दोष जानें';

  @override
  String get doshaDiscoverSubtitle =>
      'अपनी अनूठी मन-शरीर संरचना जानने और व्यक्तिगत स्वास्थ्य सलाह प्राप्त करने के लिए आयुर्वेदिक मूल्यांकन लें।';

  @override
  String doshaYouAre(String dosha) {
    return 'आप $dosha हैं';
  }

  @override
  String get doshaBreakdown => 'दोष विवरण';

  @override
  String doshaAbout(String dosha) {
    return '$dosha के बारे में';
  }

  @override
  String get doshaBalancingDiet => 'संतुलनकारी आहार';

  @override
  String get doshaFavor => '✅ सेवन करें';

  @override
  String get doshaAvoid => '❌ परहेज़ करें';

  @override
  String get doshaSeasonImpact => 'वर्तमान ऋतु प्रभाव';

  @override
  String doshaSeasonOf(String dosha) {
    return '$dosha की ऋतु';
  }

  @override
  String get doshaSeasonWarning =>
      'विशेष ध्यान दें! यह ऋतु स्वाभाविक रूप से आपके प्रमुख दोष को बढ़ाती है।';

  @override
  String doshaSeasonNeutral(String dosha) {
    return 'यह ऋतु आपके प्रमुख दोष को संतुलित करने में सहायक हो सकती है, लेकिन $dosha वृद्धि से सावधान रहें।';
  }

  @override
  String get doshaRetakeQuiz => 'पुनः क्विज़ लें';

  @override
  String get chatAyurBot => 'आयुरबॉट';

  @override
  String get chatExpert => 'आयुर्वेद विशेषज्ञ';

  @override
  String get chatThinking => 'सोच रहा है...';

  @override
  String get chatNewChat => 'नई चैट';

  @override
  String get chatHistory => 'चैट इतिहास';

  @override
  String get chatStartNew => 'नई चैट शुरू करें';

  @override
  String get chatStartNewConfirm => 'नई चैट शुरू करें?';

  @override
  String get chatStartNewMsg => 'यह वर्तमान वार्तालाप को साफ़ कर देगा।';

  @override
  String get chatRecentConversations => 'हाल की बातचीत';

  @override
  String get chatNoConversations => 'अभी तक कोई बातचीत नहीं';

  @override
  String get chatClearAll => 'सब इतिहास मिटाएं';

  @override
  String get chatClearAllMsg =>
      'यह आपकी सभी चैट वार्तालापों को हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get chatDeleteAll => 'सभी हटाएं';

  @override
  String get chatSwipeHint => 'हटाने के लिए चैट पर बाएं स्वाइप करें';

  @override
  String get chatStartConversation => 'बातचीत शुरू करें';

  @override
  String get chatDismiss => 'खारिज करें';

  @override
  String get chatTypeMessage => 'आयुर्वेद के बारे में पूछें...';

  @override
  String memberSince(String date) {
    return '$date से सदस्य';
  }

  @override
  String get wellnessHub => 'स्वास्थ्य केंद्र';

  @override
  String get dailyRoutine => 'दैनिक दिनचर्या';

  @override
  String get balanceDosha => 'अपना दोष संतुलित करें';

  @override
  String get seasonalWisdom => 'ऋतुचर्या';

  @override
  String get delete => 'हटाएं';

  @override
  String get save => 'सहेजें';

  @override
  String get share => 'साझा करें';
}
