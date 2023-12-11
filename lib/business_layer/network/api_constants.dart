import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  /// Private constructor to prevent class instantiation
  ApiConstants._privateConstructor();

  /// Api URLS DEVELOPMENT
  static const urlDevServer = "https://api.openweathermap.org/data/2.5/";
  static const devApiKey = '';

  /// Api URLS PRODUCTION
  static const urlProdServer = '';
  static const prodApiKey = '';

  /// Api URLS TESTING
  static const urlTestServer = '';
  static const testApiKey = '';

  static const googleLink = "google.com";

  /// weather api endpoint
  static weatherUrl(double lat, double lng) {
    return "weather?lat=$lat&lon=$lng&appid=${dotenv.env['WEATHER_API_KEY']}&lang=en";
  }
}
