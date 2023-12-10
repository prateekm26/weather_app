import 'package:equatable/equatable.dart';
import 'package:weather_app/data_layer/models/weather_res_model.dart';

sealed class WeatherAppState extends Equatable {
  const WeatherAppState();

  @override
  List<Object> get props => [];
}

class WeatherAppInitial extends WeatherAppState {}

final class WeatherAppLoading extends WeatherAppState {}

final class WeatherAppFailure extends WeatherAppState {
  final String message;
  const WeatherAppFailure({required this.message});
}

final class WeatherAppSuccess extends WeatherAppState {
  final WeatherResModel weather;

  const WeatherAppSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}
