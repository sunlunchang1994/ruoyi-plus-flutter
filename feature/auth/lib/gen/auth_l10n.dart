import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/auth_localizations.dart';
import 'l10n/auth_localizations_en.dart';

class AuthS {
  static get current {
    return S._current;
  }

  static const delegate  = S.delegate;
}

class S {
  static AuthLocalizations? _current;

  static AuthLocalizations get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static AuthLocalizations of(BuildContext context) {
    return AuthLocalizations.of(context)!;
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate = _LocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

class _LocalizationsDelegate extends LocalizationsDelegate<AuthLocalizations> {
  const _LocalizationsDelegate();

  @override
  Future<AuthLocalizations> load(Locale locale) {
    AuthLocalizations fastLocalizations = lookupLocalizations(locale);
    S._current = fastLocalizations;
    return SynchronousFuture<AuthLocalizations>(lookupLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationsDelegate old) => false;
}

AuthLocalizations lookupLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AuthLocalizationsEn();
  }

  throw FlutterError(
    'AuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
