import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/business_layer/bloc/weather_app_state.dart';
import 'package:weather_app/business_layer/repository/weather_repository.dart';
import 'package:weather_app/business_layer/util/helper/util_helper.dart';
import 'package:weather_app/data_layer/models/weather_res_model.dart';

part 'weather_app_event.dart';

class WeatherAppBloc extends Bloc<WeatherAppEvent, WeatherAppState> {
  WeatherAppBloc() : super(WeatherAppInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherAppLoading());
      final response = await WeatherRepository.instance
          .fetchCurrentWeather(lat: event.lat, lng: event.lng);

      if (response.data != null && response.data is WeatherResModel) {
        WeatherResModel weatherData = response.data;
        if (weatherData != null) {
          emit(WeatherAppSuccess(weatherData));
        } else {
          emit(const WeatherAppFailure(message: "Unable to fetch data"));
        }
      } else {
        emit(WeatherAppFailure(
            message: UtilHelper.instance
                .getExceptionMessage(response.exceptionType)));
      }
    });
  }
}
