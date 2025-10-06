/// Localization delegate for the BluePills application.
///
/// This library provides the delegate that loads the appropriate
/// localization based on the device's locale.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'app_localizations.dart';
import 'en/app_localizations_en.dart';
import 'fi/app_localizations_fi.dart';

/// Delegate for loading [AppLocalizations] based on the device's locale.
///
/// This delegate is registered with MaterialApp to provide automatic
/// localization support. It loads the appropriate localization class
/// based on the language code (e.g., 'en' for English, 'fi' for Finnish).
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'fi':
        return SynchronousFuture<AppLocalizations>(AppLocalizationsFi());
      default:
        return SynchronousFuture<AppLocalizations>(AppLocalizationsEn());
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
