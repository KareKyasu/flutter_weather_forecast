class WeatherEntity {
  double min_temp;
  double max_temp;
  String weather_type;
  String icon;
  WeatherEntity.fromJson(Map<String, dynamic> json)
      : min_temp = json['main']['temp_min'] - 273.15,
        max_temp = json['main']['temp_max'] - 273.15,
        weather_type = json['weather'][0]['description'],
        icon = json['weather'][0]['icon'];
}
