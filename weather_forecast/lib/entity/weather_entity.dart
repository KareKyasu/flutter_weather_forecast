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
        weather_type: json['weather'][0]['main'],
        icon: json['weather'][0]['icon']);
  }

  String getLottieJson() {
    print("hereeeeeeee");
    print(this.weather_type);
    switch (this.weather_type) {
      case 'Thunderstorm':
        return "json/4803-weather-storm.json";
      case 'Drizzle':
        return "json/4797-weather-rainynight.json";
      case 'Rain':
        return "json/4797-weather-rainynight.json";
      case 'Snow':
        return "json/4793-weather-snow.json";
      case 'Clear':
        return "json/4799-weather-night.json";
      case 'Clouds':
        return "json/4806-weather-windy.json";
      case 'Mist':
        return "json/4795-weather-mist.json";
      default:
        return "json/4795-weather-mist.json";
    }
  }
}
