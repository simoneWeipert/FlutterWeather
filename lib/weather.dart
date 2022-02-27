//from https://github.com/Kilo-Loco/30DaysOfFlutter/blob/main/day11_weather_app/lib/models.dart
// ignore_for_file: avoid_print

import 'dart:math';

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

class WeatherInfo {
  final String description;
  final String icon;

  WeatherInfo({required this.description, required this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}

class TemperatureInfo {
  final double temperature;

  TemperatureInfo({required this.temperature});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    double temp = (json['temp'] - 30) / 2;
    final temperature = roundDouble(temp, 2);
    return TemperatureInfo(temperature: temperature);
  }
}

class WeatherResponse {
  final String cityName;
  final String weekday;
  final String date;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@2x.png';
  }

  WeatherResponse(
      {required this.weekday,
      required this.date,
      required this.cityName,
      required this.tempInfo,
      required this.weatherInfo});
}
