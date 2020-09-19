import 'package:weather_forecast/api/weather_api.dart';
import 'package:weather_forecast/entity/area_entity.dart';

class WeatherRepository {
  final WeatherApi weatherApi;
  const WeatherRepository(this.weatherApi);

  Future<String> getWeather(AreaEntity areaEntity) async {
    return await weatherApi.getWeather(areaEntity);
  }
}
