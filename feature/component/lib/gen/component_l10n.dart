import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';

import 'l10n/component_localizations.dart';
import 'l10n/component_localizations_en.dart';

class ComponentS {
  static ComponentLocalizations? _current;

  static ComponentLocalizations get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static ComponentLocalizations of(BuildContext context) {
    return ComponentLocalizations.of(context)!;
  }

  static const LocalizationsDelegate<ComponentLocalizations> delegate = _LocalizationsDelegate();
}

class _LocalizationsDelegate extends LocalizationsDelegate<ComponentLocalizations> {
  const _LocalizationsDelegate();

  @override
  Future<ComponentLocalizations> load(Locale locale) {
    ComponentLocalizations fastLocalizations = lookupLocalizations(locale);
    ComponentS._current = fastLocalizations;
    return SynchronousFuture<ComponentLocalizations>(fastLocalizations);
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationsDelegate old) => false;
}

ComponentLocalizations lookupLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ComponentLocalizationsEn();
  }

  throw FlutterError(
      'ComponentLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
