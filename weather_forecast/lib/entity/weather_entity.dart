class WeatherEntity {
  final double min_temp;
  final double max_temp;
  final String weather_type;
  final String icon;

  WeatherEntity({this.min_temp, this.max_temp, this.weather_type, this.icon});

  factory WeatherEntity.fromJson(Map<String, dynamic> json) {
    return WeatherEntity(
        min_temp: json['main']['temp_min'] - 273.15,
        max_temp: json['main']['temp_max'] - 273.15,
        weather_type: json['weather'][0]['description'],
        icon: json['weather'][0]['icon']);
  }
}
