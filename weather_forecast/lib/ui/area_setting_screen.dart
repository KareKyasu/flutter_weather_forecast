import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/entity/area_entity.dart';

import '../model/area_model.dart';

class AreaSettingScreen extends StatefulWidget {
  static const routeName = '/area_setting_screen';

  @override
  _AreaSettingScreenState createState() => _AreaSettingScreenState();
}

class _AreaSettingScreenState extends State<AreaSettingScreen> {
  @override
  void initState() {
    super.initState();
    this.loadLocalJson();
  }

  List<AreaEntity> areas;
  Future loadLocalJson() async {
    String jsonString = await rootBundle.loadString('json/coordinates.json');
    setState(() {
      final jsonResponse = json.decode(jsonString)['areas'] as List;
      areas = jsonResponse.map((area) => AreaEntity.fromJson(area)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("地域設定"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _areaItem(context, areas[index]);
          },
          itemCount: areas.length,
        ));
  }

  Widget _areaItem(BuildContext context, AreaEntity area) {
    final areaModel = Provider.of<AreaModel>(context, listen: true);
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: new Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: area.area == areaModel.areaEntity.area
                    ? Icon(Icons.check)
                    : Icon(null),
              ),
              Text(
                area.area,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ],
          )),
      onTap: () {
        areaModel.update(area);
        Navigator.pop(context);
      },
    );
  }
}
