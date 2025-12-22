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

import 'es/app_localizations_es.dart';
import 'de/app_localizations_de.dart';
import 'sv/app_localizations_sv.dart';

/// Delegate for loading [AppLocalizations] based on the device's locale.
///
/// This delegate is registered with MaterialApp to provide automatic
/// localization support. It loads the appropriate localization class
/// based on the language code (e.g., 'en' for English, 'fi' for Finnish).
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fi', 'sv', 'de', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'fi':
        return SynchronousFuture<AppLocalizations>(AppLocalizationsFi());
      case 'sv':
        return SynchronousFuture<AppLocalizations>(AppLocalizationsSv());
      case 'de':
        return SynchronousFuture<AppLocalizations>(AppLocalizationsDe());
      case 'es':
        return SynchronousFuture<AppLocalizations>(AppLocalizationsEs());
      default:
        return SynchronousFuture<AppLocalizations>(AppLocalizationsEn());
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
