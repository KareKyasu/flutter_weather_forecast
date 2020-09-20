class AreaEntity {
  String area;
  String lon;
  String lat;
  AreaEntity({this.area, this.lon, this.lat});

  factory AreaEntity.fromJson(Map<String, dynamic> json) {
    return AreaEntity(area: json['area'], lon: json['lon'], lat: json['lat']);
  }

  Map<String, dynamic> toJson() => {
        'area': area,
        'lon': lon,
        'lat': lat,
      };
}
