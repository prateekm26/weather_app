part of 'weather_app_bloc.dart';

abstract class WeatherAppEvent extends Equatable {
  const WeatherAppEvent();
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherAppEvent {
  final double lat;
  final double lng;

  const FetchWeather({required this.lat, required this.lng});

  @override
  List<Object> get props => [lat, lng];
}
