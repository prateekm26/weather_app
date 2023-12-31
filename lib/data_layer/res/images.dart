import 'package:flutter/material.dart';

class AppImages {
  static String sunrise = 'assets/sunrise.png';
  static String sunset = 'assets/sunset.png';
  static String minTemp = 'assets/min_temp.png';
  static String maxTemp = 'assets/max_temp.png';
  static String windSpeed = 'assets/wind_speed.png';
  static String humidity = 'assets/humidity.png';
  static String loader = "assets/loader.png";

  ///return weather icon based on weather condition code
  static Widget getWeatherIcon(int code) {
    print("Weather code $code");
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/5.png');
      case == 800:
        return Image.asset('assets/6.png');
      case == 801:
        return Image.asset('assets/7.png');
      case > 801 && <= 804:
        return Image.asset('assets/8.png');
      default:
        return Image.asset('assets/7.png');
    }
  }
}
