class AreaEntity {
  String area;
  String lon;
  String lat;
  AreaEntity({this.area, this.lon, this.lat});

  AreaEntity.fromJson(Map<String, dynamic> json)
      : area = json['area'],
        lon = json['lon'],
        lat = json['lat'];

  Map<String, dynamic> toJson() => {
        'area': area,
        'lon': lon,
        'lat': lat,
      };
}
