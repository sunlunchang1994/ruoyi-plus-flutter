import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'main_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of MainLocalizations
/// returned by `MainLocalizations.of(context)`.
///
/// Applications need to include `MainLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/main_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: MainLocalizations.localizationsDelegates,
///   supportedLocales: MainLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the MainLocalizations.supportedLocales
/// property.
abstract class MainLocalizations {
  MainLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static MainLocalizations? of(BuildContext context) {
    return Localizations.of<MainLocalizations>(context, MainLocalizations);
  }

  static const LocalizationsDelegate<MainLocalizations> delegate = _MainLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @main_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get main_divide_text;

  /// No description provided for @analyse_label_title.
  ///
  /// In en, this message translates to:
  /// **'分析'**
  String get analyse_label_title;

  /// No description provided for @analyse_label_week_online.
  ///
  /// In en, this message translates to:
  /// **'在线统计'**
  String get analyse_label_week_online;

  /// No description provided for @analyse_label_traffic_trends.
  ///
  /// In en, this message translates to:
  /// **'流量趋势'**
  String get analyse_label_traffic_trends;

  /// No description provided for @analyse_label_month_visits.
  ///
  /// In en, this message translates to:
  /// **'月访问量'**
  String get analyse_label_month_visits;

  /// No description provided for @analyse_label_access_source.
  ///
  /// In en, this message translates to:
  /// **'访问来源'**
  String get analyse_label_access_source;

  /// No description provided for @analyse_label_access_trends.
  ///
  /// In en, this message translates to:
  /// **'访问趋势'**
  String get analyse_label_access_trends;
}

class _MainLocalizationsDelegate extends LocalizationsDelegate<MainLocalizations> {
  const _MainLocalizationsDelegate();

  @override
  Future<MainLocalizations> load(Locale locale) {
    return SynchronousFuture<MainLocalizations>(lookupMainLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_MainLocalizationsDelegate old) => false;
}

MainLocalizations lookupMainLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return MainLocalizationsEn();
  }

  throw FlutterError(
    'MainLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
