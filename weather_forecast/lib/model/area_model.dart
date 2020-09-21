import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/api/weather_api.dart';
import 'package:weather_forecast/data/shared_preference_keys.dart';
import 'package:weather_forecast/entity/area_entity.dart';
import 'package:weather_forecast/entity/weather_entity.dart';
import 'package:weather_forecast/repository/weather_repository.dart';

class AreaModel with ChangeNotifier {
  AreaEntity _areaEntity;
  AreaEntity get areaEntity => _areaEntity;
  WeatherRepository weatherRepository;
  AreaModel() {
    weatherRepository = WeatherRepository(WeatherApi());
    setup();
  }
  WeatherEntity _weatherEntity;
  WeatherEntity get weatherEntity => _weatherEntity;

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(SharedPreferencesKeys.appFirstOpen) ?? true) {
      // 初回起動ならば東京をセット
      prefs.setBool(SharedPreferencesKeys.appFirstOpen, false);
      AreaEntity areaEntity =
          AreaEntity(area: '東京都', lon: '139.6917222', lat: '35.68956667');
      prefs.setString(
          SharedPreferencesKeys.areaEntity, json.encode(areaEntity));
      _areaEntity = areaEntity;
      await getWeather();
      await notifyListeners();
    } else {
      // 二回目以降は最後に設定したものをロード
      AreaEntity areaEntity = (await AreaEntity.fromJson(
              json.decode(prefs.getString(SharedPreferencesKeys.areaEntity))) ??
          AreaEntity(area: '東京都', lon: '139.6917222', lat: '35.68956667'));
      _areaEntity = areaEntity;
      await getWeather();
      await notifyListeners();
    }
  }

  void update(AreaEntity areaEntity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferencesKeys.areaEntity, json.encode(areaEntity));
    _areaEntity = areaEntity;
    await getWeather();
    await notifyListeners();
  }

  void getWeather() async {
    _weatherEntity = await weatherRepository.getWeather(_areaEntity);
  }
}
