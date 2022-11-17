import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/domain/weather_json/coord.dart';
import 'package:weather_app/domain/weather_json/weather_data.dart';

class WeatherApi {
  static  final String _apiKey = dotenv.get('API_KEY');
  static const String _host = 'api.openweathermap.org';

  static Future<Coords?> getCoords(String cityName) async {
    const path = 'data/2.5/weather';
    Uri url = Uri(
      scheme: 'https',
      host: _host,
      path: path,
      queryParameters: {
        'q': cityName,
        'appid': _apiKey,
        'lang': 'ru',
      },
    );

    try {
      final data = await _jsonRequest(url);
      final coords = Coords.fromJson(data);
      return coords;
    } catch (e) {
      final Map<String, dynamic> data = await _jsonRequest(url);
      final coords = Coords.fromJson(data);
      return coords;
    }
  }

  static Future<WeatherData?> getWeather(Coords? coords) async {
    if (coords != null) {
      const path = 'data/2.5/onecall';
      Uri url = Uri(
        scheme: 'https',
        host: _host,
        path: path,
        queryParameters: {
          'appid': _apiKey,
          'lang': 'ru',
          'lat': coords.lat.toString(),
          'lon': coords.lon.toString(),
          'exclude': 'hourly,minutely',
        },
      );

      final data = await _jsonRequest(url);
      final weatherData = WeatherData.fromJson(data);
      return weatherData;
    }

    return null;
  }

  static Future<Map<String, dynamic>> _jsonRequest(Uri url) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(url);
      final responce = await request.close();
      final json = await responce.transform(utf8.decoder).toList();
      final jsonString = json.join();
      final data = jsonDecode(jsonString);
      client.close();
      return data;
    } catch (e) {
      print(e);
    }
    return {};
  }
}
