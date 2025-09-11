import 'package:fast/gen/l10n/fast_localizations.dart';
import 'package:fast/gen/l10n/fast_localizations_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';

class FastS {
  static FastLocalizations? _current;

  static FastLocalizations get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static FastLocalizations of(BuildContext context) {
    return FastLocalizations.of(context)!;
  }

  static const LocalizationsDelegate<FastLocalizations> delegate = _LocalizationsDelegate();

}

class _LocalizationsDelegate extends LocalizationsDelegate<FastLocalizations> {
  const _LocalizationsDelegate();

  @override
  Future<FastLocalizations> load(Locale locale) {
    FastLocalizations fastLocalizations = lookupLocalizations(locale);
    FastS._current = fastLocalizations;
    return SynchronousFuture<FastLocalizations>(fastLocalizations);
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationsDelegate old) => false;
}

FastLocalizations lookupLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FastLocalizationsEn();
  }

  throw FlutterError(
      'FastLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
