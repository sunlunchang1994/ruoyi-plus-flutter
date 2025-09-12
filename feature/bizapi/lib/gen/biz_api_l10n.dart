import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';

import 'l10n/biz_api_localizations.dart';

class BizApiS {
  static BizApiLocalizations? _current;

  static BizApiLocalizations get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static BizApiLocalizations of(BuildContext context) {
    return BizApiLocalizations.of(context)!;
  }

  static const LocalizationsDelegate<BizApiLocalizations> delegate = _LocalizationsDelegate();
}

class _LocalizationsDelegate extends LocalizationsDelegate<BizApiLocalizations> {
  const _LocalizationsDelegate();

  @override
  Future<BizApiLocalizations> load(Locale locale) {
    BizApiLocalizations fastLocalizations = lookupLocalizations(locale);
    BizApiS._current = fastLocalizations;
    return SynchronousFuture<BizApiLocalizations>(fastLocalizations);
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationsDelegate old) => false;
}

BizApiLocalizations lookupLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
  }

  throw FlutterError(
      'BizApiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
