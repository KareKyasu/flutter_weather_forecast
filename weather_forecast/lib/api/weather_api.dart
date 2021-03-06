import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/entity/area_entity.dart';
import 'package:weather_forecast/entity/weather_entity.dart';

class WeatherApi {
  static const host = "https://api.openweathermap.org";
  static const path = "/data/2.5/weather";

  Future<WeatherEntity> getWeather(AreaEntity areaEntity) async {
    final response = await http.get("$host$path" +
        "?lat=" +
        areaEntity.lat +
        "&lon=" +
        areaEntity.lon +
        "&appid=" +
        DotEnv().env['OPENWEATHERMAP_API_KEY'].toString());

    return WeatherEntity.fromJson(json.decode(response.body));
  }
}
