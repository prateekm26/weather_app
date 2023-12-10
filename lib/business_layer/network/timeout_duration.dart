/// A utility class for managing timeout durations when using the [Dio] API.
class TimeoutDuration {
  /// Private constructor to prevent class instantiation
  TimeoutDuration._privateConstructor();

  /// The duration for establishing a connection to the server.
  static const connectionTimeout = Duration(milliseconds: 25000);

  /// The duration for receiving data from the server.
  static const receiveTimeout = Duration(milliseconds: 25000);

  /// The duration for sending data to the server.
  static const sendTimeout = Duration(milliseconds: 25000);
}
