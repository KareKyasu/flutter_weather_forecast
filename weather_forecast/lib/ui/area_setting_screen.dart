import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/data/CurrentLocation.dart';
import 'package:weather_forecast/entity/area_entity.dart';

import '../model/area_model.dart';

class AreaSettingScreen extends StatefulWidget {
  static const routeName = '/area_setting_screen';

  @override
  _AreaSettingScreenState createState() => _AreaSettingScreenState();
}

class _AreaSettingScreenState extends State<AreaSettingScreen> {
  List<AreaEntity> areas = List(47);

  Future loadLocalJson() async {
    String jsonString = await rootBundle.loadString('json/coordinates.json');
    setState(() {
      final jsonResponse = json.decode(jsonString)['areas'] as List;
      areas = jsonResponse.map((area) => AreaEntity.fromJson(area)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadLocalJson();
  }

  @override
  Widget build(BuildContext context) {
    final areaModel = Provider.of<AreaModel>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: Text("地域設定"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _areaItem(context, areaModel,
                  AreaEntity(area: CurrentLocation.area, lon: null, lat: null));
            } else {
              return _areaItem(context, areaModel, areas[index - 1]);
            }
          },
          itemCount: 48,
        ));
  }

  Widget _areaItem(BuildContext context, AreaModel areaModel, AreaEntity area) {
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
                area.area ?? "",
              ),
            ],
          )),
      onTap: () async {
        bool isPop = true;
        if (area.area == CurrentLocation.area) {
          bool isGetLocation = await areaModel.checkLocation();
          if (!isGetLocation) isPop = false;
        }
        if (isPop) {
          areaModel.update(area);
          Navigator.pop(context);
        } else {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("位置情報エラー"),
                    content: Text("設定から位置情報の取得を許可してください"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ));
        }
      },
    );
  }
}
