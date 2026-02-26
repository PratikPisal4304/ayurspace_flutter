import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'AyurSpace'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get navRemedies;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get navWellness;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greetingEvening;

  /// No description provided for @dailyTip.
  ///
  /// In en, this message translates to:
  /// **'Daily Tip'**
  String get dailyTip;

  /// No description provided for @dailyTipContent.
  ///
  /// In en, this message translates to:
  /// **'Start your day with warm water and a teaspoon of honey to boost digestion and energy.'**
  String get dailyTipContent;

  /// No description provided for @featuredRemedies.
  ///
  /// In en, this message translates to:
  /// **'Featured Remedies'**
  String get featuredRemedies;

  /// No description provided for @featuredPlants.
  ///
  /// In en, this message translates to:
  /// **'Featured Plants'**
  String get featuredPlants;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search remedies, plants...'**
  String get searchHint;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @doshaQuiz.
  ///
  /// In en, this message translates to:
  /// **'Dosha Quiz'**
  String get doshaQuiz;

  /// No description provided for @plantScan.
  ///
  /// In en, this message translates to:
  /// **'Plant Scan'**
  String get plantScan;

  /// No description provided for @consultAi.
  ///
  /// In en, this message translates to:
  /// **'Consult AI'**
  String get consultAi;

  /// No description provided for @myHealth.
  ///
  /// In en, this message translates to:
  /// **'My Health'**
  String get myHealth;

  /// No description provided for @wellnessScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Wellness Score'**
  String get wellnessScoreTitle;

  /// No description provided for @wellnessKeepUp.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work! 🌿'**
  String get wellnessKeepUp;

  /// No description provided for @remediesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Traditional Ayurvedic solutions'**
  String get remediesSubtitle;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @remediesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} remedies found'**
  String remediesFound(int count);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noRemediesFound.
  ///
  /// In en, this message translates to:
  /// **'No remedies found'**
  String get noRemediesFound;

  /// No description provided for @profileBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Plants'**
  String get profileBookmarks;

  /// No description provided for @profileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorite Remedies'**
  String get profileFavorites;

  /// No description provided for @profileDoshaQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Dosha Quiz'**
  String get profileDoshaQuiz;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileHelp;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About AyurSpace'**
  String get profileAbout;

  /// No description provided for @statsPlants.
  ///
  /// In en, this message translates to:
  /// **'Plants\nScanned'**
  String get statsPlants;

  /// No description provided for @statsRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies\nTried'**
  String get statsRemedies;

  /// No description provided for @statsWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness\nScore'**
  String get statsWellness;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsPlantScans.
  ///
  /// In en, this message translates to:
  /// **'Plant Explorer'**
  String get achievementsPlantScans;

  /// No description provided for @achievementsRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedy Master'**
  String get achievementsRemedies;

  /// No description provided for @achievementsWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness Guru'**
  String get achievementsWellness;

  /// No description provided for @achievementsStreak.
  ///
  /// In en, this message translates to:
  /// **'Week Streak'**
  String get achievementsStreak;

  /// No description provided for @doshaResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dosha: {dosha}'**
  String doshaResultTitle(String dosha);

  /// No description provided for @doshaDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Dosha'**
  String get doshaDiscover;

  /// No description provided for @doshaViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get doshaViewDetails;

  /// No description provided for @doshaTakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take the quiz to find out'**
  String get doshaTakeQuiz;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDays(int count);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContWith.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your wellness journey'**
  String get signInToContWith;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountYet;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startWellnessJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your Ayurvedic wellness journey'**
  String get startWellnessJourney;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get sessionComplete;

  /// No description provided for @meditationGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job on your meditation practice.'**
  String get meditationGreatJob;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @quickMeditation.
  ///
  /// In en, this message translates to:
  /// **'Quick Meditation'**
  String get quickMeditation;

  /// No description provided for @sleepSounds.
  ///
  /// In en, this message translates to:
  /// **'Sleep Sounds'**
  String get sleepSounds;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing: {sound}'**
  String nowPlaying(String sound);

  /// No description provided for @dayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} Day Streak!'**
  String dayStreakTitle(int count);

  /// No description provided for @startWellnessToday.
  ///
  /// In en, this message translates to:
  /// **'Start your wellness journey today'**
  String get startWellnessToday;

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep it up! You\'re doing great.'**
  String get keepItUp;

  /// No description provided for @minsMediated.
  ///
  /// In en, this message translates to:
  /// **'Mins Meditated'**
  String get minsMediated;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @morningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Morning Routine'**
  String get morningRoutine;

  /// No description provided for @eveningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Evening Routine'**
  String get eveningRoutine;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: support@ayurspace.app'**
  String get helpEmail;

  /// No description provided for @helpWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website: www.ayurspace.app'**
  String get helpWebsite;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @faqScanner.
  ///
  /// In en, this message translates to:
  /// **'How do I use the plant scanner?'**
  String get faqScanner;

  /// No description provided for @faqDosha.
  ///
  /// In en, this message translates to:
  /// **'What is my dosha?'**
  String get faqDosha;

  /// No description provided for @faqRemedies.
  ///
  /// In en, this message translates to:
  /// **'Are remedies safe to use?'**
  String get faqRemedies;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutVersion;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Your complete Ayurveda companion. Discover traditional herbs, personalized remedies, and wellness practices based on ancient wisdom.'**
  String get aboutDescription;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 AyurSpace. All rights reserved.'**
  String get aboutCopyright;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sendLink;

  /// No description provided for @validEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmailRequired;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}'**
  String passwordResetSent(String email);

  /// No description provided for @plantAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get plantAbout;

  /// No description provided for @plantBenefits.
  ///
  /// In en, this message translates to:
  /// **'Health Benefits'**
  String get plantBenefits;

  /// No description provided for @plantDoshas.
  ///
  /// In en, this message translates to:
  /// **'Balances Doshas'**
  String get plantDoshas;

  /// No description provided for @plantSeasons.
  ///
  /// In en, this message translates to:
  /// **'Best Seasons'**
  String get plantSeasons;

  /// No description provided for @plantCompounds.
  ///
  /// In en, this message translates to:
  /// **'Active Compounds'**
  String get plantCompounds;

  /// No description provided for @plantUses.
  ///
  /// In en, this message translates to:
  /// **'Traditional Uses'**
  String get plantUses;

  /// No description provided for @plantDosage.
  ///
  /// In en, this message translates to:
  /// **'Recommended Dosage'**
  String get plantDosage;

  /// No description provided for @plantPrecautions.
  ///
  /// In en, this message translates to:
  /// **'Precautions'**
  String get plantPrecautions;

  /// No description provided for @plantContraindications.
  ///
  /// In en, this message translates to:
  /// **'Contraindications'**
  String get plantContraindications;

  /// No description provided for @plantDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Growing Difficulty'**
  String get plantDifficulty;

  /// No description provided for @plantTips.
  ///
  /// In en, this message translates to:
  /// **'Growing Tips'**
  String get plantTips;

  /// No description provided for @plantHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest Time'**
  String get plantHarvest;

  /// No description provided for @plantDetails.
  ///
  /// In en, this message translates to:
  /// **'Plant Details'**
  String get plantDetails;

  /// No description provided for @plantCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get plantCategory;

  /// No description provided for @plantPartUsed.
  ///
  /// In en, this message translates to:
  /// **'Part Used'**
  String get plantPartUsed;

  /// No description provided for @plantOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get plantOrigin;

  /// No description provided for @plantDoshaBalance.
  ///
  /// In en, this message translates to:
  /// **'Dosha Balance'**
  String get plantDoshaBalance;

  /// No description provided for @plantTaste.
  ///
  /// In en, this message translates to:
  /// **'Taste Profile (Rasa)'**
  String get plantTaste;

  /// No description provided for @plantNames.
  ///
  /// In en, this message translates to:
  /// **'Names'**
  String get plantNames;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get nameEnglish;

  /// No description provided for @nameHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get nameHindi;

  /// No description provided for @nameScientific.
  ///
  /// In en, this message translates to:
  /// **'Scientific'**
  String get nameScientific;

  /// No description provided for @nameSanskrit.
  ///
  /// In en, this message translates to:
  /// **'Sanskrit'**
  String get nameSanskrit;

  /// No description provided for @ayurvedicProps.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic Properties'**
  String get ayurvedicProps;

  /// No description provided for @propBalances.
  ///
  /// In en, this message translates to:
  /// **'Balances'**
  String get propBalances;

  /// No description provided for @propPotency.
  ///
  /// In en, this message translates to:
  /// **'Potency (Virya)'**
  String get propPotency;

  /// No description provided for @propPostDigestive.
  ///
  /// In en, this message translates to:
  /// **'Post-Digestive (Vipaka)'**
  String get propPostDigestive;

  /// No description provided for @actionFindRemedies.
  ///
  /// In en, this message translates to:
  /// **'Find Remedies'**
  String get actionFindRemedies;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get actionSaved;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabUses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get tabUses;

  /// No description provided for @tabGrowing.
  ///
  /// In en, this message translates to:
  /// **'Growing'**
  String get tabGrowing;

  /// No description provided for @tabAyurveda.
  ///
  /// In en, this message translates to:
  /// **'Ayurveda'**
  String get tabAyurveda;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Scanner'**
  String get scannerTitle;

  /// No description provided for @scannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Identify any Ayurvedic plant'**
  String get scannerSubtitle;

  /// No description provided for @pointToIdentify.
  ///
  /// In en, this message translates to:
  /// **'Point at a plant to identify'**
  String get pointToIdentify;

  /// No description provided for @clearPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of leaves or the whole plant'**
  String get clearPhotoHint;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing plant...'**
  String get analyzing;

  /// No description provided for @aiPowered.
  ///
  /// In en, this message translates to:
  /// **'Using Plant.id + Gemini AI'**
  String get aiPowered;

  /// No description provided for @identificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Identification Failed'**
  String get identificationFailed;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @fullInfo.
  ///
  /// In en, this message translates to:
  /// **'Full Info'**
  String get fullInfo;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @ayurvedicInfo.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic Information'**
  String get ayurvedicInfo;

  /// No description provided for @aiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This information is AI-generated. Please verify with an Ayurvedic practitioner.'**
  String get aiDisclaimer;

  /// No description provided for @ayurvedicDatabase.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic Database'**
  String get ayurvedicDatabase;

  /// No description provided for @aiGeneratedInfo.
  ///
  /// In en, this message translates to:
  /// **'AI Generated Info'**
  String get aiGeneratedInfo;

  /// No description provided for @confidenceMatch.
  ///
  /// In en, this message translates to:
  /// **'{percent}% match'**
  String confidenceMatch(int percent);

  /// No description provided for @moreDailyTips.
  ///
  /// In en, this message translates to:
  /// **'More daily tips coming soon!'**
  String get moreDailyTips;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive daily tips and reminders'**
  String get settingsPushSubtitle;

  /// No description provided for @settingsDailyTips.
  ///
  /// In en, this message translates to:
  /// **'Daily Wellness Tips'**
  String get settingsDailyTips;

  /// No description provided for @settingsDailyTipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get Ayurvedic tips each morning'**
  String get settingsDailyTipsSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get settingsDarkModeSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get settingsData;

  /// No description provided for @settingsAutoBackup.
  ///
  /// In en, this message translates to:
  /// **'Auto Backup'**
  String get settingsAutoBackup;

  /// No description provided for @settingsAutoBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backup data to cloud'**
  String get settingsAutoBackupSubtitle;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settingsAppVersion;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get settingsSignOutConfirm;

  /// No description provided for @settingsClearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will clear all cached data. Downloaded content may need to be re-downloaded.'**
  String get settingsClearCacheConfirm;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get settingsCacheCleared;

  /// No description provided for @settingsDarkModeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Dark mode coming soon! 🌙'**
  String get settingsDarkModeComingSoon;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and you will lose all your saved data, including Dosha profile, bookmarks, and streaks.'**
  String get settingsDeleteAccountMsg;

  /// No description provided for @settingsDeleteAccountRequested.
  ///
  /// In en, this message translates to:
  /// **'Account deletion requested. Support will contact you shortly.'**
  String get settingsDeleteAccountRequested;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsLanguageComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{lang} language coming soon!'**
  String settingsLanguageComingSoon(String lang);

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfileSaveChanges;

  /// No description provided for @editProfileNameShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get editProfileNameShort;

  /// No description provided for @editProfileInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get editProfileInvalidEmail;

  /// No description provided for @editProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfileUpdated;

  /// No description provided for @editProfileSelectAvatar.
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get editProfileSelectAvatar;

  /// No description provided for @editProfileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editProfileName;

  /// No description provided for @editProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editProfileEmail;

  /// No description provided for @doshaProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dosha Profile'**
  String get doshaProfileTitle;

  /// No description provided for @doshaProfileNoAssessment.
  ///
  /// In en, this message translates to:
  /// **'Your Dosha'**
  String get doshaProfileNoAssessment;

  /// No description provided for @doshaDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Dosha'**
  String get doshaDiscoverTitle;

  /// No description provided for @doshaDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take the Ayurvedic assessment to reveal your unique mind-body constitution and unlock personalized wellness advice.'**
  String get doshaDiscoverSubtitle;

  /// No description provided for @doshaYouAre.
  ///
  /// In en, this message translates to:
  /// **'You are {dosha}'**
  String doshaYouAre(String dosha);

  /// No description provided for @doshaBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Dosha Breakdown'**
  String get doshaBreakdown;

  /// No description provided for @doshaAbout.
  ///
  /// In en, this message translates to:
  /// **'About {dosha}'**
  String doshaAbout(String dosha);

  /// No description provided for @doshaBalancingDiet.
  ///
  /// In en, this message translates to:
  /// **'Balancing Diet (Ahara)'**
  String get doshaBalancingDiet;

  /// No description provided for @doshaFavor.
  ///
  /// In en, this message translates to:
  /// **'✅ Favor'**
  String get doshaFavor;

  /// No description provided for @doshaAvoid.
  ///
  /// In en, this message translates to:
  /// **'❌ Avoid'**
  String get doshaAvoid;

  /// No description provided for @doshaSeasonImpact.
  ///
  /// In en, this message translates to:
  /// **'Current Season Impact'**
  String get doshaSeasonImpact;

  /// No description provided for @doshaSeasonOf.
  ///
  /// In en, this message translates to:
  /// **'Season of {dosha}'**
  String doshaSeasonOf(String dosha);

  /// No description provided for @doshaSeasonWarning.
  ///
  /// In en, this message translates to:
  /// **'Pay extra attention! This season naturally increases your dominant dosha. Stick strictly to your balancing routines.'**
  String get doshaSeasonWarning;

  /// No description provided for @doshaSeasonNeutral.
  ///
  /// In en, this message translates to:
  /// **'This season may help balance your dominant dosha, but remain mindful of {dosha} aggravation.'**
  String doshaSeasonNeutral(String dosha);

  /// No description provided for @doshaRetakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get doshaRetakeQuiz;

  /// No description provided for @chatAyurBot.
  ///
  /// In en, this message translates to:
  /// **'AyurBot'**
  String get chatAyurBot;

  /// No description provided for @chatExpert.
  ///
  /// In en, this message translates to:
  /// **'Ayurveda Expert'**
  String get chatExpert;

  /// No description provided for @chatThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get chatThinking;

  /// No description provided for @chatNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get chatNewChat;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @chatStartNew.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get chatStartNew;

  /// No description provided for @chatStartNewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat?'**
  String get chatStartNewConfirm;

  /// No description provided for @chatStartNewMsg.
  ///
  /// In en, this message translates to:
  /// **'This will clear the current conversation.'**
  String get chatStartNewMsg;

  /// No description provided for @chatRecentConversations.
  ///
  /// In en, this message translates to:
  /// **'Recent Conversations'**
  String get chatRecentConversations;

  /// No description provided for @chatNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chatNoConversations;

  /// No description provided for @chatClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get chatClearAll;

  /// No description provided for @chatClearAllMsg.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your chat conversations. This action cannot be undone.'**
  String get chatClearAllMsg;

  /// No description provided for @chatDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get chatDeleteAll;

  /// No description provided for @chatSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on a chat to delete it'**
  String get chatSwipeHint;

  /// No description provided for @chatStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get chatStartConversation;

  /// No description provided for @chatDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get chatDismiss;

  /// No description provided for @chatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Ask about Ayurveda...'**
  String get chatTypeMessage;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(String date);

  /// No description provided for @wellnessHub.
  ///
  /// In en, this message translates to:
  /// **'Wellness Hub'**
  String get wellnessHub;

  /// No description provided for @dailyRoutine.
  ///
  /// In en, this message translates to:
  /// **'Daily Routine (Dinacharya)'**
  String get dailyRoutine;

  /// No description provided for @balanceDosha.
  ///
  /// In en, this message translates to:
  /// **'Balance Your Dosha'**
  String get balanceDosha;

  /// No description provided for @seasonalWisdom.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Wisdom (Ritucharya)'**
  String get seasonalWisdom;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
