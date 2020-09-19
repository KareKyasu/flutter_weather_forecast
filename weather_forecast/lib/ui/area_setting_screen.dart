import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/area_model.dart';

class AreaSettingScreen extends StatelessWidget {
  static const routeName = '/area_setting_screen';
  var listTitles = ['東京', '大阪', "神戸"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("地域設定"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _areaItem(context, listTitles[index], true);
          },
          itemCount: listTitles.length,
        ));
  }

  Widget _areaItem(BuildContext context, String area, bool check) {
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
                child: area == areaModel.area ? Icon(Icons.check) : Icon(null),
              ),
              Text(
                area,
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
