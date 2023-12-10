import 'package:flutter/material.dart';
import 'package:weather_app/business_layer/localization/app_localizations.dart';
import 'package:weather_app/business_layer/network/exception_type.dart';
import 'package:weather_app/business_layer/util/helper/device_info_helper.dart';
import 'package:weather_app/data_layer/res/numbers.dart';
import 'package:weather_app/data_layer/res/strings.dart';

/// A utility class for various helper methods and properties.
class UtilHelper {
  /// Private constructor for singleton
  UtilHelper._privateConstructor();

  /// Singleton instance creation
  static final _instance = UtilHelper._privateConstructor();

  /// Get the singleton instance
  static UtilHelper get instance => _instance;

  // Language code for the application.
  String languageCode = LanguageConstants.englishLanguageCode;

  /// Method used to returns a two-letter locale code from the given full
  /// locale string.
  String getLocale(String locale) {
    if (locale.length > i_1) {
      return locale.substring(i_0, i_2);
    } else if (locale.length <= i_1) {
      return locale;
    } else {
      return "en";
    }
  }

  /// Method used to closes the keyboard if it's open
  /// in the provided [BuildContext].
  void closeKeyboard(BuildContext context) {
    if (DeviceInfo.isKeyBoardOpen(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  /// Method used to returns a error message or
  /// returns an empty string if the message is null.
  String getError(String? errorMessage) {
    return errorMessage ?? "";
  }

  /// Method used to Get an exception message based on the provided [ExceptionType].
  /// Returns a corresponding message or an empty string if no match is found.
  /// The [ExceptionType] parameter specifies the type of exception to handle.
  /// Possible values are [ExceptionType.apiException],
  /// [ExceptionType.timeOutException], [ExceptionType.socketException],
  /// [ExceptionType.parseException], [ExceptionType.otherException],
  /// [ExceptionType.cancelException], or [ExceptionType.noException].
  String getExceptionMessage(ExceptionType exceptionType) {
    switch (exceptionType) {
      case ExceptionType.apiException:
        return AppLocalizations.current.apiExceptionMessage;
      case ExceptionType.timeOutException:
        return AppLocalizations.current.timeoutExceptionMessage;
      case ExceptionType.socketException:
        return AppLocalizations.current.socketExceptionMessage;
      case ExceptionType.parseException:
        return AppLocalizations.current.parseExceptionMessage;
      case ExceptionType.otherException:
        return ""; // TODO: Handle this case message.
      case ExceptionType.cancelException:
        return ""; // TODO: Handle this case message.
      case ExceptionType.noException:
        return "";
    }
  }

  /// Convert temperature to Celsius

  int kevinToCelsius(double kelvin) {
    return (kelvin - 273.15).round();
  }
}
