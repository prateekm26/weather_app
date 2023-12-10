import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:weather_app/app_settings.dart';

/// A utility class for logging data and errors in a Flutter application.
class LogHelper {
  // Private constructor to prevent instantiation.
  LogHelper._privateConstructor();

  /// Logs a general message with using the [Logger].
  /// The [message] parameter represents the message we want to log.
  /// The optional [logName] parameter can be used to specify a custom log name.
  /// This method logs the message using the [Logger] and [developer.log] if
  /// the app is not in production mode or not in release mode.
  static void logData(var message, {String logName = ""}) {
    if (!MyAppSettings.isProduction || !kReleaseMode) {
      Logger().d(message);
      developer.log(message.toString(), name: logName);
    }
  }

  /// Logs an error message.
  /// The [message] parameter represents the error message you want to log.
  /// The optional [logName] parameter can be used to specify a custom log name.
  /// This method logs the error message using the [Logger] and [developer.log]
  /// if the app is not in production mode or not in release mode.
  static void logError(var message, {String logName = ""}) {
    if (!MyAppSettings.isProduction || !kReleaseMode) {
      Logger().e(message);
      developer.log(message.toString(), name: logName);
    }
  }

  /// Logs a general message without using the [Logger].
  /// The [message] parameter represents the message you want to log.
  /// The optional [logName] parameter can be used to specify a custom log name.
  /// This method logs the message using [developer.log] if the app is not in
  /// production mode or not in release mode.
  static void logMessage(String message, {String logName = ""}) {
    if (!MyAppSettings.isProduction || !kReleaseMode) {
      developer.log(message, name: logName);
    }
  }
}
