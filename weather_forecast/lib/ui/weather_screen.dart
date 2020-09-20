import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/model/area_model.dart';
import 'package:weather_forecast/ui/area_setting_screen.dart';

class WeatherScreen extends StatelessWidget {
  static const routeName = '/weather_screen';

  @override
  Widget build(BuildContext context) {
    final areaModel = Provider.of<AreaModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("天気予報"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            InkWell(
              child: Text(areaModel.areaEntity.area ?? ""),
              onTap: () {
                Navigator.pushNamed(context, AreaSettingScreen.routeName);
              },
            ),
            Image.network(
              areaModel.weatherEntity != null
                  ? "http://openweathermap.org/img/wn/" +
                      areaModel.weatherEntity.icon +
                      ".png"
                  : "",
              fit: BoxFit.contain,
              width: 300,
              height: 300,
            ),
            Text(areaModel.weatherEntity != null
                ? "最低気温 " + areaModel.weatherEntity.min_temp.toStringAsFixed(2)
                : ""),
            Text(areaModel.weatherEntity != null
                ? "最高気温 " + areaModel.weatherEntity.max_temp.toStringAsFixed(2)
                : ""),
          ],
        ),
      ),
    );
  }
}
