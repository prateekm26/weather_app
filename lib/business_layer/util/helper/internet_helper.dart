import 'dart:async';
import 'dart:io';

import 'package:weather_app/business_layer/network/api_constants.dart';

/// A singleton class for checking internet connection status in Flutter.
class NetworkConnection {
  // Private constructor to prevent direct instantiation.
  NetworkConnection._privateConstructor();

  /// The private instance of the [NetworkConnection] class.
  static final _instance = NetworkConnection._privateConstructor();

  /// Get the shared instance of the [NetworkConnection] class.
  static NetworkConnection get instance => _instance;

  /// Check the internet connection status asynchronously.
  ///
  /// This method checks if the device has an active internet connection by
  /// attempting to lookup the IP address of a known website [ApiConstants.googleLink].
  /// It returns a [Future<bool>] indicating whether the connection is successful.
  ///
  /// Returns `true` if the device has a valid internet connection, and `false`
  /// if there's no internet connection or if the operation times out.
  Future<bool> checkInternetConnection() async {
    bool checkConnection;
    try {
      final result = await InternetAddress.lookup(ApiConstants.googleLink)
          .timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        checkConnection = true;
      } else {
        checkConnection = false;
      }
    } on TimeoutException catch (_) {
      // Handle the case where the lookup operation times out.
      checkConnection = false;
    } on SocketException catch (_) {
      // Handle the case where a socket error occurs (no internet connection).
      checkConnection = false;
    }
    return checkConnection;
  }
}
