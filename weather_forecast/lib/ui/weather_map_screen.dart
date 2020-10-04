import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

import '../model/area_model.dart';

class WeatherMapScreen extends StatefulWidget {
  static const routeName = '/weather_map_screen';
  @override
  _WeatherMapScreenState createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Polyline> _polyline = {};

  String _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('json/map_styles/aubergine.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    controller.setMapStyle(_darkMapStyle);
  }

  Future<void> _goToSetArea(AreaModel areaModel) async {
    var loc = CameraPosition(
        target: LatLng(double.parse(areaModel.areaEntity.lat),
            double.parse(areaModel.areaEntity.lon)),
        zoom: 14.4746);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(loc));
  }

  Set<Polygon> _polygons() {
    var div_num = 10;
    var poly_num = div_num * div_num;
    var northernmost = 35.9;
    var southernmost = 35.5;
    var easternmost = 140.0;
    var westmost = 139.5;
    var lat_div = (northernmost - southernmost) / div_num;
    var lng_div = (easternmost - westmost) / div_num;

    Set<Polygon> polygonSet = new Set();

    List<LatLng> polygonCoords = new List();
    polygonCoords.add(LatLng(southernmost, westmost));
    polygonCoords.add(LatLng(southernmost, easternmost));
    polygonCoords.add(LatLng(northernmost, easternmost));
    polygonCoords.add(LatLng(northernmost, westmost));

    polygonSet.add(Polygon(
        polygonId: PolygonId('test'),
        points: polygonCoords,
        fillColor: Color.fromRGBO(255, 255, 255, 0.0),
        strokeColor: Colors.red));

    var i = 1;
    for (final lat in range(1, div_num + 1)) {
      print(lat);
      for (final lng in range(1, div_num + 1)) {
        var _northernmost = southernmost + lat_div * lat;
        var _southernmost = southernmost + lat_div * (lat - 1);
        var _easternmost = westmost + lng_div * lng;
        var _westmost = westmost + lng_div * (lng - 1);

        List<LatLng> polygonCoords = new List();
        polygonCoords.add(LatLng(_southernmost, _westmost));
        polygonCoords.add(LatLng(_southernmost, _easternmost));
        polygonCoords.add(LatLng(_northernmost, _easternmost));
        polygonCoords.add(LatLng(_northernmost, _westmost));

        polygonSet.add(Polygon(
            polygonId: PolygonId(lat.toString() + "_" + lng.toString()),
            points: polygonCoords,
            fillColor: Color.fromRGBO(
                (lat * 255 / div_num).toInt(),
                (lng * 255 / div_num).toInt(),
                (i * 255 / poly_num).toInt(),
                0.3),
            strokeColor: Colors.transparent));
        i += 1;
      }
    }
    return polygonSet;
  }

  @override
  Widget build(BuildContext context) {
    final areaModel = Provider.of<AreaModel>(context, listen: true);
    _setMapStyle();
    // https://pub.dev/packages/map_overlay
    return Scaffold(
      body: GoogleMap(
        polygons: _polygons(),
        mapType: MapType.normal,
        // mapToolbarEnabled: false,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(areaModel.areaEntity.lat),
              double.parse(areaModel.areaEntity.lon)),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white60,
        child: Icon(Icons.my_location),
        onPressed: () {
          _goToSetArea(areaModel);
        },
      ),
    );
  }
}
