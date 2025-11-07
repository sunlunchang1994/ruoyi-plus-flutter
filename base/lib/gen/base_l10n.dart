import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/base_localizations.dart';
import 'l10n/base_localizations_en.dart';

class BaseS {
  static get current {
    return S._current;
  }

  static const delegate  = S.delegate;
}

class S {
  static BaseLocalizations? _current;

  static BaseLocalizations get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static BaseLocalizations of(BuildContext context) {
    return BaseLocalizations.of(context)!;
  }

  static const LocalizationsDelegate<BaseLocalizations> delegate = _LocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

class _LocalizationsDelegate extends LocalizationsDelegate<BaseLocalizations> {
  const _LocalizationsDelegate();

  @override
  Future<BaseLocalizations> load(Locale locale) {
    BaseLocalizations fastLocalizations = lookupLocalizations(locale);
    S._current = fastLocalizations;
    return SynchronousFuture<BaseLocalizations>(lookupLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationsDelegate old) => false;
}

BaseLocalizations lookupLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return BaseLocalizationsEn();
  }

  throw FlutterError(
    'BaseLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
