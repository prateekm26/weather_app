import 'package:flutter/material.dart';
import 'package:weather_app/business_layer/localization/app_localizations.dart';

/// A custom Flutter [LocalizationsDelegate] for the [AppLocalizations] class.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// Creates a [AppLocalizationsDelegate] instance.
  const AppLocalizationsDelegate();

  /// Check if the specified [locale] is supported.
  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  /// Load translations for the specified [locale].
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  /// Determines whether the delegate should reload based on
  /// the old [AppLocalizationsDelegate].
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  /// English locale object.
  static const Locale enLocale = Locale('en');

  /// List of supported locales in the app.
  static List<Locale> get supportedLocales => [enLocale];
}
