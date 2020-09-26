import 'package:weather_forecast/api/weather_api.dart';
import 'package:weather_forecast/entity/area_entity.dart';
import 'package:weather_forecast/entity/weather_entity.dart';

class WeatherRepository {
  final WeatherApi weatherApi;
  const WeatherRepository(this.weatherApi);

  Future<WeatherEntity> getWeather(AreaEntity areaEntity) async {
    return weatherApi.getWeather(areaEntity);
  }
}
