import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/api/weather_api.dart';
import 'package:weather_forecast/data/CurrentLocation.dart';
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

    // 初回起動時かチェック
    if (prefs.getBool(SharedPreferencesKeys.appFirstOpen) ?? true) {
      // 東京をセット
      prefs.setBool(SharedPreferencesKeys.appFirstOpen, false);
      AreaEntity areaEntity =
          AreaEntity(area: '東京都', lon: '139.6917222', lat: '35.68956667');
      prefs.setString(
          SharedPreferencesKeys.areaEntity, json.encode(areaEntity));
      _areaEntity = areaEntity;
      _weatherEntity = await getWeather();
      await notifyListeners();
    } else
    // 二回目以降
    {
      // 最後に設定したものをロード
      AreaEntity areaEntity = (await AreaEntity.fromJson(
              json.decode(prefs.getString(SharedPreferencesKeys.areaEntity))) ??
          AreaEntity(area: '東京都', lon: '139.6917222', lat: '35.68956667'));
      // 現在位置を設定していた場合
      if (areaEntity.area == CurrentLocation.area) {
        bool isGetLocation = await checkLocation();

        // 権限を確かめ、有効なら現在地取得
        if (isGetLocation) {
          List<String> loc = await getLocation();
          areaEntity.lon = loc[0];
          areaEntity.lat = loc[1];
        } else
        // 権限無効なら東京に変更する
        {
          AreaEntity areaEntity =
              AreaEntity(area: '東京都', lon: '139.6917222', lat: '35.68956667');
        }
      }
      _areaEntity = areaEntity;
      _weatherEntity = await getWeather();
      await notifyListeners();
    }
  }

  Future<List<String>> getLocation() async {
    Location location = new Location();
    LocationData _locationData = await location.getLocation();
    return [
      _locationData.longitude.toString(),
      _locationData.latitude.toString()
    ];
  }

  Future<bool> checkLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<bool> update(AreaEntity areaEntity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (areaEntity.area == CurrentLocation.area) {
      List<String> loc = await getLocation();
      areaEntity.lon = loc[0];
      areaEntity.lat = loc[1];
    }
    prefs.setString(SharedPreferencesKeys.areaEntity, json.encode(areaEntity));
    _areaEntity = areaEntity;
    _weatherEntity = await getWeather();
    notifyListeners();
  }

  Future<WeatherEntity> getWeather() async {
    return weatherRepository.getWeather(_areaEntity);
  }
}
