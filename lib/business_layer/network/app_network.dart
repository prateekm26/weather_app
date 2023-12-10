import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:weather_app/business_layer/network/exception_type.dart';
import 'package:weather_app/business_layer/network/http_response_code.dart';
import 'package:weather_app/business_layer/network/timeout_duration.dart';
import 'package:weather_app/business_layer/util/helper/flavor_configuration_helper.dart';
import 'package:weather_app/business_layer/util/helper/internet_helper.dart';
import 'package:weather_app/business_layer/util/helper/log_helper.dart';
import 'package:weather_app/data_layer/models/base_api_response_model.dart';

class AppNetwork {
  /// Singleton instance of the AppNetwork class
  static AppNetwork? _instance;

  /// Base URL for network requests
  static final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  /// API key for network requests
  static final String _apiKey = FlavorConfig.instance.values.apiKey;

  /// Dio client for making network requests
  Dio? _dioClient;

  // Store cancel tokens
  final List<CancelToken> _cancelTokens = [];

  /// Internal method to create an instance of the [AppNetwork] class
  AppNetwork._create() {
    _dioClient = Dio(); // Initialize the Dio client
    (_dioClient?.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () => HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // Configure Dio for handling self-signed certificates
    _dioClient!.options.baseUrl = _baseUrl; // Set the base URL
    _dioClient!.options.responseType =
        ResponseType.json; // Set the response type to JSON
    _dioClient!.options.sendTimeout =
        TimeoutDuration.sendTimeout; // Set send timeout
    _dioClient!.options.connectTimeout =
        TimeoutDuration.connectionTimeout; // Set connection timeout
    _dioClient!.options.receiveTimeout =
        TimeoutDuration.receiveTimeout; // Set receive timeout
  }

  /// Factory constructor to get an instance of [AppNetwork]
  factory AppNetwork() {
    return _instance ??= AppNetwork
        ._create(); // Create and return a single instance of AppNetwork
  }

  /// Entry point method for all network request calls, gets data from the
  /// network and returns it to the caller
  Future<BaseApiResponseModel> request({
    required String url, // URL for the network request
    dynamic request, // Request data
    Map<String, dynamic>? queryParameter, // Query parameters
    final String? requestType, // Request type (e.g., GET, POST)
    bool? headerIncluded = true, // Whether to include headers
    Function? fileUploadProgress, // Progress callback for file uploads
    bool isMultipartEnabled = false, // Flag to enable multipart requests
    bool isCheckUnauthorizedAccess = true, // Check for unauthorized access
  }) async {
    /// Check for internet connection before making the request
    if (!(await NetworkConnection.instance.checkInternetConnection())) {
      /// The purpose of this block is to ensure that there is an active
      /// internet connection before attempting to make the network request.
      // If there is no internet connection, the method returns a response with
      // an exception type of 'socketException.' This indicates that the device
      // is not connected to the internet, and the request cannot be sent.
      // ExceptionType.socketException is typically used to handle cases where
      // there is no network connectivity or a socket-related issue preventing
      // network communication.
      return BaseApiResponseModel(exceptionType: ExceptionType.socketException);
    }
    try {
      final cancelToken = CancelToken();
      LogHelper.logData(_dioClient!.options.baseUrl + url);
      if (queryParameter != null) {
        LogHelper.logData("Debug Param Data $queryParameter");
      }
      if (request != null && !isMultipartEnabled) {
        LogHelper.logData("Debug Post Data ${jsonEncode(request)}");
      }
      if (request != null && isMultipartEnabled) {
        LogHelper.logData("Debug Post Data $request");
      }
      if (queryParameter != null) {
        LogHelper.logData("Debug Param Data $queryParameter");
      }

      /// Create options for the request, including the request type
      /// (GET, POST, etc.)
      var options = Options(method: requestType);

      /// Retrieve the user's access token from a [UserStateHiveHelper] asynchronously
      String?
          accessToken/*= await UserStateHiveHelper.instance.getAccessToken()*/;
      if (headerIncluded != null && headerIncluded) {
        // LogHelper.logData("Authorization => $accessToken");

        /// If headerIncluded is not null and is set to true. Set the request
        /// headers, including the Authorization and x-api-key headers
        options.headers = {
          "Authorization": accessToken,
          "x-api-key": _apiKey,
        };
      } else {
        /// If headerIncluded is null or set to false, set only the
        /// x-api-key header
        options.headers = {
          "x-api-key": _apiKey,
        };
      }
      if (isMultipartEnabled) {
        /// If isMultipartEnabled is true, set the content type to
        /// "multipart/form-data"
        options.contentType = "multipart/form-data";
      } else {
        /// If isMultipartEnabled is false, set the content type to
        /// "application/json"
        options.contentType = "application/json";
      }

      /// Make the network request
      Response serverResponse = await _dioClient!.request(
        url,
        data: await request,
        queryParameters: queryParameter ?? {},
        options: options,
        cancelToken: cancelToken,
        onSendProgress: (int sent, int total) {
          if (isMultipartEnabled) {
            LogHelper.logData("${sent / total * 100} total sent");
            if (fileUploadProgress != null) {
              fileUploadProgress(sent / total * 100);
            }
          }
        },
        onReceiveProgress: (int sent, int total) {
          LogHelper.logData("${sent / total * 100} total received");
        },
      );
      _removeCancelToken(cancelToken);
      LogHelper.logData("Request headers======> ${options.headers}");

      /// Handle different HTTP status codes
      switch (serverResponse.statusCode) {
        case HttpResponseCode.internalServerError:

          /// Handle internal server error response
          return BaseApiResponseModel(
            exceptionType: ExceptionType.apiException,
          );
        case HttpResponseCode.badGateway:

          /// Handle bad gateway response
          return BaseApiResponseModel(
            exceptionType: ExceptionType.apiException,
          );
        default:

          /// Handle other response cases (e.g., success)
          return BaseApiResponseModel(
            data: serverResponse,
            exceptionType: ExceptionType.noException,
          );
      }
    } on TimeoutException catch (error) {
      /// Log and handle timeout exception
      LogHelper.logError('Timeout Exception ====> $url, ${error.toString()}');
      return BaseApiResponseModel(
        exceptionType: ExceptionType.timeOutException,
      );
    } on SocketException catch (error) {
      /// Log and handle socket exception
      LogHelper.logError('Socket Exception ====> $url, ${error.toString()}');
      return BaseApiResponseModel(
        exceptionType: ExceptionType.socketException,
      );
    } on DioException catch (error) {
      /// Handle Dio-specific exceptions
      return _handleDioException(error, isCheckUnauthorizedAccess);
    } catch (error) {
      // Log and handle other exceptions
      LogHelper.logError('Other Exception ====> $url, ${error.toString()}');
      return BaseApiResponseModel(
        exceptionType: ExceptionType.otherException,
      );
    }
  }

  /// Method to handle [Dio] exceptions and map them to appropriate response
  /// models and return them. This method takes a [DioException] and a boolean
  /// flag to check for unauthorized access.
  BaseApiResponseModel _handleDioException(
    final DioException error,
    bool isCheckUnauthorizedAccess,
  ) {
    switch (error.type) {
      case DioExceptionType.cancel:
        LogHelper.logError("Request cancelled ====>${error.message}");
        return BaseApiResponseModel(
          exceptionType: ExceptionType.cancelException,
        );
      case DioExceptionType.connectionTimeout:
        LogHelper.logError(
            "Connection timeout ====> ${error.requestOptions.path}, ${error.message}}");
        return BaseApiResponseModel(
          exceptionType: ExceptionType.timeOutException,
        );
      case DioExceptionType.unknown:
        LogHelper.logError(
            "Other Error ====> ${error.requestOptions.path}, ${error.message}");
        return BaseApiResponseModel(
          exceptionType: ExceptionType.socketException,
        );
      case DioExceptionType.receiveTimeout:
        LogHelper.logError(
            "Receive Timeout Error ====> ${error.requestOptions.path}, ${error.message}");
        return BaseApiResponseModel(
          exceptionType: ExceptionType.timeOutException,
        );
      case DioExceptionType.sendTimeout:
        LogHelper.logError(
            "Send Timeout Error ====> ${error.requestOptions.path}, ${error.message}");
        return BaseApiResponseModel(
          exceptionType: ExceptionType.timeOutException,
        );
      case DioExceptionType.badResponse:
        LogHelper.logError(
            "Api Error Response Message ====> ${error.requestOptions.path}, ${error.message}, ${error.response}");
        if (isCheckUnauthorizedAccess &&
            (error.response?.statusCode == HttpResponseCode.unAuthorized)) {
          _sessionExpired();
          return BaseApiResponseModel(
            exceptionType: ExceptionType.otherException,
          );
        } else if (error.response?.statusCode ==
            HttpResponseCode.internalServerError) {
          return BaseApiResponseModel(
            exceptionType: ExceptionType.apiException,
          );
        } else if (error.response?.statusCode == HttpResponseCode.badGateway) {
          return BaseApiResponseModel(
            exceptionType: ExceptionType.apiException,
          );
        } else {
          return BaseApiResponseModel(
            data: error.response as Response,
            exceptionType: ExceptionType.noException,
          );
        }
      default:
        LogHelper.logError(
            "Api Other Error ====> ${error.requestOptions.path}, ${error.message}");
        return BaseApiResponseModel(
          exceptionType: ExceptionType.otherException,
        );
    }
  }

  // Method to cancel all requests
  void _cancelAllRequests() {
    /// Cancel each requests
    try {
      for (var cancelToken in _cancelTokens) {
        cancelToken.cancel("canceled");
      }

      /// Clear the list of cancel tokens
      _cancelTokens.clear();
    } on Exception catch (e) {
      LogHelper.logError("Error while cancelling all requests =====> $e");
    }
  }

  // Method to remove cancel tokens
  void _removeCancelToken(CancelToken cancelToken) {
    try {
      _cancelTokens.remove(cancelToken);
    } on Exception catch (e) {
      LogHelper.logError("Error while cancelling all requests =====> $e");
    }
  }

  /// Method used to open a session expired dialog.
  /// This method is responsible for displaying a dialog when the user's
  /// session has expired, prompting them ok to log in again.
  Future<void> _sessionExpired() async {
    try {
      /// Attempt to cancel all requests.
      _cancelAllRequests();

      /// TODO: Attempt to display the session expired dialog.
    } catch (e) {
      /// Handle any potential errors that may occur while displaying the dialog.
      LogHelper.logError(e.toString());
    }
  }
}
