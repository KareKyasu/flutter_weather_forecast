import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_forecast/ui/area_setting_screen.dart';
import 'package:weather_forecast/ui/weather_screen.dart';

class Routes {
  static RouteFactory onGenerateRoute = (RouteSettings settings) {
    switch (settings.name) {
      case WeatherScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => WeatherScreen(),
        );
      case AreaSettingScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => AreaSettingScreen(),
        );
      default:
        return null;
    }
  };
}
