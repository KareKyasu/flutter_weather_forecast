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
            Text(areaModel.weatherResponse ?? ""),
          ],
        ),
      ),
    );
  }
}
