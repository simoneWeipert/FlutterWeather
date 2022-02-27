// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:flutter_mon_app/weather.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DataService {
  getWeatherForecast(String city) async {
    final queryParam = {
      'q': city,
      'appid': '574df417951f863c43182bcff40aeead',
      'units': 'imperial'
    };

    //api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    final uri =
        Uri.https('api.openweathermap.org', 'data/2.5/forecast', queryParam);
    final response = await http.get(uri);

    // print the data we get for now
    print(response.body);
    final json = jsonDecode(response.body);

    return parseForecast(json);
  }

  parseForecast(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];

    //so only one entry per day bc it is convinient
    String dayBefore = '';

    //weather data
    List<WeatherResponse> days = [];
    final String cityName;
    String weekday;
    String date;
    TemperatureInfo tempInfo;
    WeatherInfo weatherInfo;

    //set city name here bc it's in the "header"
    cityName = json['city']['name'];
    print(cityName);

    for (var elem in list) {
      //pre-processing so I can compare the days
      //Date of forecast
      var dateNotFormat =
          DateTime.fromMillisecondsSinceEpoch(elem['dt'] * 1000);
      //today
      var today = DateFormat('dd MMM y').format(DateTime.now());
      var dateData = DateFormat('dd MMM y').format(dateNotFormat);

      if (dayBefore != dateData) {
        //set weekday
        today == dateData
            ? weekday = 'Today'
            : weekday = DateFormat('EEEE').format(dateNotFormat);

        //set date
        date = dateData;

        //set tempInfo
        var tempInfoJson = elem['main'];
        tempInfo = TemperatureInfo.fromJson(tempInfoJson);

        //set weatherInfo
        var weatherInfoJson = elem['weather'][0];
        weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

        //put data in one weather response
        WeatherResponse daily = WeatherResponse(
            weekday: weekday,
            date: date,
            cityName: cityName,
            tempInfo: tempInfo,
            weatherInfo: weatherInfo);

        //add to list
        days.add(daily);
      }
      //print(DateFormat('dd-MMM-y').format(date));
      dayBefore = dateData;
    }

    print(days.toString());
    return days;
  }
}
