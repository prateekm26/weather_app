import 'package:flutter/material.dart';
import 'package:weather_app/app_settings.dart';
import 'package:weather_app/business_layer/network/api_constants.dart';

/// Enum to represent different flavors of the app.
enum Flavor {
  dev, // Development flavor
  qa, // Quality Assurance flavor
  production, // Production flavor
}

/// Class to hold values specific to each flavor.
class FlavorValues {
  FlavorValues({
    required this.baseUrl, // Base URL for API endpoints
    required this.apiKey, // API Key for the flavor
  });

  final String baseUrl; // Base URL for API endpoints
  final String apiKey; // API Key for the flavor
}

/// Class to configure the app's flavor and associated values.
class FlavorConfig {
  final Flavor flavor; // The current flavor of the app
  final String name; // The name of the flavor
  final Color color; // Color associated with the flavor
  final FlavorValues values; // Flavor-specific values (baseUrl and apiKey)
  static late FlavorConfig _instance; // Singleton instance for FlavorConfig

  /// Factory constructor to create a FlavorConfig instance.
  factory FlavorConfig({
    required Flavor flavor, // The flavor to configure
    Color color =
        Colors.blue, // Color associated with the flavor (default: blue)
    required FlavorValues values, // Flavor-specific values (baseUrl and apiKey)
  }) {
    _instance = FlavorConfig._internal(
        flavor, enumName(flavor.toString()), color, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  /// Getter to access the singleton instance of FlavorConfig.
  static FlavorConfig get instance {
    return _instance;
  }

  // Check if the current flavor is Production.
  static bool isProduction() => _instance.flavor == Flavor.production;

  /// Check if the current flavor is Development.
  static bool isDevelopment() => _instance.flavor == Flavor.dev;

  /// Check if the current flavor is Quality Assurance.
  static bool isQA() => _instance.flavor == Flavor.qa;

  /// Utility method to extract the enum name from the string representation.
  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }

  /// Method to set the server configuration based on the app settings.
  static void setServerConfig() {
    if (MyAppSettings.isProduction) {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          baseUrl: ApiConstants.urlProdServer,
          apiKey: ApiConstants.prodApiKey,
        ),
      );
    } else if (MyAppSettings.isQA) {
      FlavorConfig(
        flavor: Flavor.qa,
        values: FlavorValues(
          baseUrl: ApiConstants.urlTestServer,
          apiKey: ApiConstants.testApiKey,
        ),
      );
    } else {
      FlavorConfig(
        flavor: Flavor.dev,
        values: FlavorValues(
          baseUrl: ApiConstants.urlDevServer,
          apiKey: ApiConstants.devApiKey,
        ),
      );
    }
  }
}
