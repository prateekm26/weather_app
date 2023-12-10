import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather_app/business_layer/bloc/weather_app_bloc.dart';
import 'package:weather_app/business_layer/localization/app_localizations_delegate.dart';
import 'package:weather_app/business_layer/util/helper/flavor_configuration_helper.dart';
import 'package:weather_app/data_layer/geolocator_helper.dart';
import 'package:weather_app/presentation_layer/screen/home_screen.dart';

void main() {
  runApp(MyApp());

  /// Sets the server configuration of the application
  FlavorConfig.setServerConfig();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  late String _locale = 'en';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: GeolocatorHelper.instance.determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BlocProvider<WeatherAppBloc>(
                create: (context) => WeatherAppBloc()
                  ..add(FetchWeather(
                      lat: snapshot.data!.latitude,
                      lng: snapshot.data!.longitude)),
                child: const HomeScreen(),
              );
            } else {
              return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.white, size: 40));
            }
          }),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(_locale),
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
    );
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
