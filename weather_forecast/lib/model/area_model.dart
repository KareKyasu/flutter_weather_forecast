import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/data/shared_preference_keys.dart';

class AreaModel with ChangeNotifier {
  String _area = '';
  String get area => _area;
  AreaModel() {
    setup();
  }
  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 初回起動ならば東京をセット
    if (prefs.getBool(SharedPreferencesKeys.appFirstOpen) ?? true) {
      prefs.setBool(SharedPreferencesKeys.appFirstOpen, false);
      String area = '東京';
      prefs.setString(SharedPreferencesKeys.settingArea, area);
      _area = area;
      notifyListeners();
    } else {
      String area =
          (await prefs.getString(SharedPreferencesKeys.settingArea) ?? '');
      _area = area;
      notifyListeners();
    }
  }

  void update(String area) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferencesKeys.settingArea, area);
    _area = area;
    notifyListeners();
  }
}
