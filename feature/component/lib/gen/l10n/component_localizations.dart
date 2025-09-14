import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'component_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ComponentLocalizations
/// returned by `ComponentLocalizations.of(context)`.
///
/// Applications need to include `ComponentLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/component_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ComponentLocalizations.localizationsDelegates,
///   supportedLocales: ComponentLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ComponentLocalizations.supportedLocales
/// property.
abstract class ComponentLocalizations {
  ComponentLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ComponentLocalizations? of(BuildContext context) {
    return Localizations.of<ComponentLocalizations>(context, ComponentLocalizations);
  }

  static const LocalizationsDelegate<ComponentLocalizations> delegate = _ComponentLocalizationsDelegate();

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

  /// No description provided for @comp_label_attachment.
  ///
  /// In en, this message translates to:
  /// **'附件'**
  String get comp_label_attachment;

  /// No description provided for @comp_label_unknown_file.
  ///
  /// In en, this message translates to:
  /// **'未知文件'**
  String get comp_label_unknown_file;

  /// No description provided for @comp_label_compressed_file.
  ///
  /// In en, this message translates to:
  /// **'压缩文件'**
  String get comp_label_compressed_file;

  /// No description provided for @comp_label_click_preview.
  ///
  /// In en, this message translates to:
  /// **'点击预览'**
  String get comp_label_click_preview;

  /// No description provided for @comp_label_please_wait_for_the_download_to_complete.
  ///
  /// In en, this message translates to:
  /// **'请等待下载完成'**
  String get comp_label_please_wait_for_the_download_to_complete;

  /// No description provided for @comp_label_add_attachments.
  ///
  /// In en, this message translates to:
  /// **'添加附件'**
  String get comp_label_add_attachments;

  /// No description provided for @comp_label_add_no_attachments.
  ///
  /// In en, this message translates to:
  /// **'没有附件'**
  String get comp_label_add_no_attachments;

  /// No description provided for @comp_label_get_attachments_error.
  ///
  /// In en, this message translates to:
  /// **'附件获取失败'**
  String get comp_label_get_attachments_error;
}

class _ComponentLocalizationsDelegate extends LocalizationsDelegate<ComponentLocalizations> {
  const _ComponentLocalizationsDelegate();

  @override
  Future<ComponentLocalizations> load(Locale locale) {
    return SynchronousFuture<ComponentLocalizations>(lookupComponentLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ComponentLocalizationsDelegate old) => false;
}

ComponentLocalizations lookupComponentLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return ComponentLocalizationsEn();
  }

  throw FlutterError(
    'ComponentLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
