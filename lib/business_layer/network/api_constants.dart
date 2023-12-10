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
    return "weather?lat=$lat&lon=$lng&appid=$weatherApiKey&lang=en";
  }

  static const weatherApiKey = "3e9be206447bf46fa39c45840f2ccea9";
}
