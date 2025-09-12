import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'biz_api_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BizApiLocalizations
/// returned by `BizApiLocalizations.of(context)`.
///
/// Applications need to include `BizApiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/biz_api_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BizApiLocalizations.localizationsDelegates,
///   supportedLocales: BizApiLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the BizApiLocalizations.supportedLocales
/// property.
abstract class BizApiLocalizations {
  BizApiLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BizApiLocalizations? of(BuildContext context) {
    return Localizations.of<BizApiLocalizations>(context, BizApiLocalizations);
  }

  static const LocalizationsDelegate<BizApiLocalizations> delegate = _BizApiLocalizationsDelegate();

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

  /// No description provided for @user_label_logging_in.
  ///
  /// In en, this message translates to:
  /// **'正在登录'**
  String get user_label_logging_in;

  /// No description provided for @user_toast_login_login_successful.
  ///
  /// In en, this message translates to:
  /// **'登录成功'**
  String get user_toast_login_login_successful;

  /// No description provided for @user_toast_login_login_failed.
  ///
  /// In en, this message translates to:
  /// **'登录失败'**
  String get user_toast_login_login_failed;
}

class _BizApiLocalizationsDelegate extends LocalizationsDelegate<BizApiLocalizations> {
  const _BizApiLocalizationsDelegate();

  @override
  Future<BizApiLocalizations> load(Locale locale) {
    return SynchronousFuture<BizApiLocalizations>(lookupBizApiLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_BizApiLocalizationsDelegate old) => false;
}

BizApiLocalizations lookupBizApiLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return BizApiLocalizationsEn();
  }

  throw FlutterError(
    'BizApiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
