import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('hi')
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
      <String>['en', 'hi'].contains(locale.languageCode);

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
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
