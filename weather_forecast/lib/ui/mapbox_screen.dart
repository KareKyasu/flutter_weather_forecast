import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/model/area_model.dart';

class MapboxScreen extends StatefulWidget {
  static const routeName = '/mapbox_screen';
  @override
  _MapboxScreenState createState() => _MapboxScreenState();
}

class _MapboxScreenState extends State<MapboxScreen> {
  @override
  Widget build(BuildContext context) {
    final areaModel = Provider.of<AreaModel>(context, listen: true);
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
        center: LatLng(double.parse(areaModel.areaEntity.lat),
            double.parse(areaModel.areaEntity.lon)),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/takanojo/ckg4oq3r52x9z19qljjvqz567/tiles/{z}/{x}/{y}?access_token={accessToken}",
          additionalOptions: {
            'accessToken': DotEnv().env['MAPBOX_API_KEY'].toString(),
          },
        ),
      ],
    ));
  }
}
