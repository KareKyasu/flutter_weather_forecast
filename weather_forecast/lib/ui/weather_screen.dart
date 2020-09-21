import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.place),
                      areaModel.areaEntity != null
                          ? Text(
                              areaModel.areaEntity.area,
                              style: TextStyle(fontSize: 20.0),
                            )
                          : Text(""),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AreaSettingScreen.routeName);
                  },
                ),
              ],
            ),
            Center(
              child: areaModel.weatherEntity != null
                  ? Lottie.asset(areaModel.weatherEntity.getLottieJson())
                  : Text(""),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TempBox(
                    "最低気温",
                    areaModel.weatherEntity != null
                        ? areaModel.weatherEntity.min_temp.toStringAsFixed(2)
                        : "",
                    '#2196f3'),
                TempBox(
                    "最高気温",
                    areaModel.weatherEntity != null
                        ? areaModel.weatherEntity.max_temp.toStringAsFixed(2)
                        : "",
                    '#ff9800'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget TempBox(String head, String value, String colorCode) {
    return Column(
      children: <Widget>[
        Text(
          head,
          style: TextStyle(fontSize: 18.0, color: HexColor.fromHex(colorCode)),
        ),
        Text(
          value + "℃",
          style: TextStyle(fontSize: 30.0, color: HexColor.fromHex(colorCode)),
        ),
      ],
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
