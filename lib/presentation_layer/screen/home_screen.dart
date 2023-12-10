import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/business_layer/bloc/weather_app_bloc.dart';
import 'package:weather_app/business_layer/bloc/weather_app_state.dart';
import 'package:weather_app/business_layer/util/helper/util_helper.dart';
import 'package:weather_app/data_layer/city_model.dart';
import 'package:weather_app/data_layer/res/images.dart';
import 'package:weather_app/presentation_layer/widget/common_dropdown.dart';

import '../widget/common_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  Cities? selectedCity;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WeatherAppBloc weatherAppBloc = WeatherAppBloc();
    return BlocConsumer<WeatherAppBloc, WeatherAppState>(
      bloc: weatherAppBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          //extendBodyBehindAppBar: true,
          /*    appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),*/
          backgroundColor: Colors.black,
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 45, 40, 20),
      child: Stack(
        children: [
          const BackgroundCircles(),
          const OrangeRectangle(),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
          BlocBuilder<WeatherAppBloc, WeatherAppState>(
            builder: (context, state) {
              if (state is WeatherAppSuccess) {
                return weatherDetailWidget(context, state);
              } else if (state is WeatherAppFailure) {
                // print("failure");
                /* DialogHelper().showRetryAlertDialog(context, retry: () {
                  print("retry");
                });*/
                return Container();
              } else {
                return _loadingWidget();
              }
            },
          )
        ],
      ),
    );
  }

  Widget weatherDetailWidget(BuildContext context, WeatherAppSuccess state) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            //dropdown to select city
            child: CommonDropDownField(
              selectedValue: selectedCity,
              onChange: (city) {
                setState(() {
                  /* if (kDebugMode) {
                    print(" city: [${city!.lat!},${city.lng!}]");
                  }*/
                  selectedCity = city;
                  context
                      .read<WeatherAppBloc>()
                      .add(FetchWeather(lat: city!.lat!, lng: city.lng!));
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomText(
            text: getWishText(),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.pin_drop,
                color: Colors.white,
                size: 20,
              ),
              CustomText(
                text: "${state.weather.name}",
                fontWeight: FontWeight.w300,
                fontSize: 15,
              ),
            ],
          ),
          Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: AppImages.getWeatherIcon(
                    state.weather.weather?[0].id ?? 200)),
          ),
          Center(
            child: CustomText(
              text:
                  "${UtilHelper.instance.kevinToCelsius(state.weather.main!.temp!)}°C",
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: CustomText(
              text: state.weather.weather![0].main!.toUpperCase(),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: CustomText(
              text: DateFormat('EEEE dd •').add_jm().format(DateTime.now()),
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ImageTextRow(
                    imagePath: AppImages.sunrise,
                    title: "Sunrise",
                    content: DateFormat()
                        .add_jm()
                        .format(DateTime.fromMillisecondsSinceEpoch(
                          state.weather.sys!.sunrise! * 1000,
                        ))),
              ),
              Expanded(
                child: ImageTextRow(
                  imagePath: AppImages.sunset,
                  title: "Sunset",
                  content: DateFormat()
                      .add_jm()
                      .format(DateTime.fromMillisecondsSinceEpoch(
                        state.weather.sys!.sunset! * 1000,
                      )),
                ),
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ImageTextRow(
                    imagePath: AppImages.maxTemp,
                    title: "Temp Max",
                    content:
                        "${UtilHelper.instance.kevinToCelsius(state.weather.main!.tempMax!)}°C"),
              ),
              Expanded(
                child: ImageTextRow(
                    imagePath: AppImages.minTemp,
                    title: "Temp Min",
                    content:
                        "${UtilHelper.instance.kevinToCelsius(state.weather.main!.tempMin!)}°C"),
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ImageTextRow(
                    imagePath: AppImages.windSpeed,
                    title: "Wind Speed",
                    content: "${state.weather.wind!.speed!.round()} m/s"),
              ),
              Expanded(
                child: ImageTextRow(
                    imagePath: AppImages.humidity,
                    title: "Humidity",
                    content: "${state.weather.main!.humidity!.round()}%"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// app loading widget
  Widget _loadingWidget() {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14,
            child: child,
          );
        },
        child: Image.asset(
          AppImages.loader,
          height: 40,
          width: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  /// greeting text
  String getWishText() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    print(now.toLocal().toString());

    if (currentHour >= 5 && currentHour < 12) {
      return "Good Morning!";
    } else if (currentHour >= 12 && currentHour < 17) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }
}

// orange colour background
class OrangeRectangle extends StatelessWidget {
  const OrangeRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1.2),
      child: Container(
        height: 300,
        width: 600,
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}

class CircleContainer extends StatelessWidget {
  final Color color;

  const CircleContainer({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class BackgroundCircles extends StatelessWidget {
  const BackgroundCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Align(
          alignment: AlignmentDirectional(3, -0.3),
          child: CircleContainer(color: Colors.purple),
        ),
        Align(
          alignment: AlignmentDirectional(-3, -0.3),
          child: CircleContainer(color: Colors.purple),
        ),
      ],
    );
  }
}

class ImageTextRow extends StatelessWidget {
  final String imagePath;
  final String title;
  final String content;

  const ImageTextRow({
    required this.imagePath,
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          scale: 12,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
            CustomText(
              text: content,
              fontSize: 15,
            ),
          ],
        ),
      ],
    );
  }
}
