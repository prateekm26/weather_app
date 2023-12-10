import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:weather_app/data_layer/res/numbers.dart';

/// A utility class for handling screen navigation in Flutter applications.
class ScreenNavigation {
  /// Private constructor to prevent direct instantiation of this class.
  ScreenNavigation._privateConstructor();

  /// Method used to create a custom animated route for navigation.
  ///
  /// [widget]: The destination widget to navigate to.
  ///
  /// [routeNames]: (Optional) The name of the route, which can be used for
  /// navigation history and debugging and automatic screen capturing log on
  /// [FirebaseAnalytics].
  ///
  /// [showPageRoute]: (Optional) A boolean value indicating whether to
  /// use a [PageRouteBuilder].
  ///
  /// Returns a Flutter [Route] object that can be used for navigation.
  static Route createRoute({
    required Widget widget,
    String? routeNames,
    bool showPageRoute = false,
  }) {
    if (Platform.isAndroid || showPageRoute) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(d_0, d_0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(
            CurveTween(
              curve: curve,
            ),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        settings: RouteSettings(name: routeNames),
      );
    } else {
      return CupertinoPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
        settings: RouteSettings(name: routeNames),
      );
    }
  }
}
