import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather_app/business_layer/bloc/weather_app_bloc.dart';
import 'package:weather_app/business_layer/localization/app_localizations_delegate.dart';
import 'package:weather_app/business_layer/util/helper/flavor_configuration_helper.dart';
import 'package:weather_app/data_layer/geolocator_helper.dart';
import 'package:weather_app/presentation_layer/screen/home_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

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
