import 'dart:convert';

import 'package:weather_app/business_layer/network/api_constants.dart';
import 'package:weather_app/business_layer/network/app_network.dart';
import 'package:weather_app/business_layer/network/exception_type.dart';
import 'package:weather_app/business_layer/network/http_request_methods.dart';
import 'package:weather_app/business_layer/util/helper/log_helper.dart';
import 'package:weather_app/data_layer/models/base_api_response_model.dart';
import 'package:weather_app/data_layer/models/weather_res_model.dart';

/// The [WeatherRepository] class handles login and user details for your app.
class WeatherRepository {
  /// Private constructor for singleton
  WeatherRepository._privateConstructor();

  /// Singleton instance creation
  static final _instance = WeatherRepository._privateConstructor();

  /// Get the singleton instance
  static WeatherRepository get instance => _instance;

  /// A private tag used for logging within the [WeatherRepository] class.
  final String _tag = "WeatherRepository: ";

  /// Methode used calls the weather API and returns the parsed response data.
  ///
  /// and returns the response data as a [BaseApiResponseModel]. If the request
  /// is successful, it contains the parsed response data. If an exception
  /// occurs, it includes the exception type.

  /// Returns: A [Future] of [BaseApiResponseModel] representing the API response.
  Future<BaseApiResponseModel> fetchCurrentWeather(
      {required double lat, required double lng}) async {
    try {
      BaseApiResponseModel response = await AppNetwork().request(
        url: ApiConstants.weatherUrl(lat, lng),
        requestType: HttpRequestMethods.get,
      );
      LogHelper.logData(_tag + response.data.toString());
      if (response.data != null) {
        final responseBody =
            jsonDecode(utf8.decode(response.data.toString().runes.toList()));
        return BaseApiResponseModel(
          data: WeatherResModel.fromJson(responseBody!),
        );
      } else {
        return BaseApiResponseModel(exceptionType: response.exceptionType);
      }
    } catch (e) {
      LogHelper.logError(_tag + e.toString());
      return BaseApiResponseModel(exceptionType: ExceptionType.parseException);
    }
  }
}
