import 'package:flutter/widgets.dart';
import 'package:weather_app/business_layer/localization/en_text.dart';

class AppLocalizations {
  static late AppLocalizations current;
  static late Locale locale;

  /// Private constructor to initialize the localization with a given locale.
  AppLocalizations._(Locale appLocale) {
    current = this;
  }

  /// Load the localization with a specified [appLocale].
  /// Returns a [Future] of [AppLocalizations] with the specified locale.
  static Future<AppLocalizations> load(Locale appLocale) {
    locale = appLocale;
    return Future.value(AppLocalizations._(appLocale));
  }

  /// Localizations are usually accessed using the [InheritedWidget] "of" syntax.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Map of values for supported languages.
  static final Map<String, Map<String, String>> _localizedValues = {
    /// English text
    "en": EnglishText.text,
  };

  ///Getters of all keys of supported language map
  String get title => _localizedValues[locale.languageCode]?['title'] ?? "";

  String get apiExceptionMessage =>
      _localizedValues[locale.languageCode]?['api_exception'] ?? "";

  String get timeoutExceptionMessage =>
      _localizedValues[locale.languageCode]?['timeout_exception'] ?? "";

  String get socketExceptionMessage =>
      _localizedValues[locale.languageCode]?['socket_exception'] ?? "";

  String get parseExceptionMessage =>
      _localizedValues[locale.languageCode]?['parse_exception'] ?? "";
}
