import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../model/area_model.dart';

class WeatherMapScreen extends StatefulWidget {
  static const routeName = '/weather_map_screen';
  @override
  _WeatherMapScreenState createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Future<void> _goToTheLake(AreaModel areaModel) async {
    var loc = CameraPosition(
        target: LatLng(double.parse(areaModel.areaEntity.lat),
            double.parse(areaModel.areaEntity.lon)),
        zoom: 14.4746);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(loc));
  }

  @override
  Widget build(BuildContext context) {
    final areaModel = Provider.of<AreaModel>(context, listen: true);
    return Scaffold(
      body: GoogleMap(
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
          _goToTheLake(areaModel);
        },
      ),
    );
  }
}
