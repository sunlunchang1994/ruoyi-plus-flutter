import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/sys_localizations.dart';
import 'l10n/sys_localizations_en.dart';

class SysS {
  static get current {
    return S._current;
  }

  static const delegate  = S.delegate;
}

class S {
  static SysLocalizations? _current;

  static SysLocalizations get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static SysLocalizations of(BuildContext context) {
    return SysLocalizations.of(context)!;
  }

  static const LocalizationsDelegate<SysLocalizations> delegate = _LocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

class _LocalizationsDelegate extends LocalizationsDelegate<SysLocalizations> {
  const _LocalizationsDelegate();

  @override
  Future<SysLocalizations> load(Locale locale) {
    SysLocalizations fastLocalizations = lookupLocalizations(locale);
    S._current = fastLocalizations;
    return SynchronousFuture<SysLocalizations>(lookupLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationsDelegate old) => false;
}

SysLocalizations lookupLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SysLocalizationsEn();
  }

  throw FlutterError(
    'SysLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
