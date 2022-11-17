import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/weather_api/weather_api.dart';
import 'package:weather_app/domain/weather_json/coord.dart';
import 'package:weather_app/domain/weather_json/weather_data.dart';
import 'package:weather_app/resourses/bg.dart';
import 'package:weather_app/ui/theme/app_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';

class WeatherProvider extends ChangeNotifier {
  // Создаем приватный параметр для хранения координат
  static Coords? _coords;
  Coords? get coords => _coords;
  // Создаем              приватный параметр для хранения информации о погоде
  static WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;
  // Получение текущих данных о погоде
  static Current? _current;
  Current? get current => _current;

  // Кельвин
  final _kelvin = -273.15;

  static bool? checkInternet;

  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          checkInternet = true;
          break;
        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          print('You are disconnected from the internet.');
          checkInternet = false;
          break;
      }
    },
  );

  Future<bool> checkStatus() async {
    bool isConnected = true;

    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');

            isConnected = true;

            break;
          case InternetConnectionStatus.disconnected:
            // ignore: avoid_print
            print('You are disconnected from the internet.');
            isConnected = false;
            break;
        }
      },
    );
    print(listener);

    return isConnected;

    // await Future<void>.delayed(const Duration(seconds: 30));
    // await listener.cancel();
  }

  final TextEditingController cityController = TextEditingController();

  Future<WeatherData?> setUp({String? cityName}) async {
    final pref = await SharedPreferences.getInstance();
    cityName = pref.getString('current-city');
    _coords = await WeatherApi.getCoords(cityName ?? 'Tashkent');
    _weatherData = await WeatherApi.getWeather(_coords);
    _current = _weatherData?.current;
    return weatherData;
  }

  void setCurrentCity(BuildContext context, {String? cityName}) async {
    cityName = cityController.text;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('current-city', cityName);
    await setUp(cityName: pref.getString('current-city'))
        .then(
          (value) => Navigator.of(context).pop(),
        )
        .then((value) => cityController.clear());
    notifyListeners();
  }

  // Метод для получения текущей темпиратуры

  int _currentTemp = 0;
  int get currentTemp => _currentTemp;

  // Обработка текущей темпиратуры
  int setCurrentTemp() {
    _currentTemp = ((_current?.temp ?? -_kelvin) + _kelvin).round();
    return currentTemp;
  }

  // Обработка статуса погоды
  String _currentStatus = 'Error';
  String get currentStatus => _currentStatus;

  String getCurrentStatus() {
    _currentStatus = current?.weather?[0].description ?? 'Ошибка';
    return capitalize(currentStatus);
  }

  //
  int _currentMinTemp = 0;
  int get currentMinTemp => _currentMinTemp;

  int setCurrentMinTemp() {
    _currentMinTemp =
        ((weatherData?.daily?[0].temp?.min ?? -_kelvin) + _kelvin).round();
    return currentMinTemp;
  }

  int _currentMaxTemp = 0;
  int get currentMaxTemp => _currentMaxTemp;

  int setCurrentMaxTemp() {
    _currentMaxTemp =
        ((weatherData?.daily?[0].temp?.max ?? -_kelvin) + _kelvin).round();
    return currentMaxTemp;
  }

  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  String? _currentTime;
  String? get currentTime => _currentTime;

  String setCurrentTime() {
    final getTime = (_current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    _currentTime = DateFormat('HH:mm').format(setTime);

    return currentTime ?? 'Error';
  }

  String? _sunset;
  String? get sunset => _sunset;

  String setCurrentSunset() {
    try {
      final getSunsetTime =
          (_current?.sunset ?? 0) + (weatherData?.timezoneOffset ?? 0);
      final setSunset =
          DateTime.fromMillisecondsSinceEpoch(getSunsetTime * 1000);
      _sunset = DateFormat('HH:mm').format(setSunset);
      return sunset ?? 'Error';
    } catch (e) {
      print(e);
    }
    return 'Error';
  }

  String? _sunrise;
  String? get sunrise => _sunrise;

  String setCurrentSunrise() {
    setDailyDays();
    try {
      final getSunriseTime =
          (_current?.sunrise ?? 0) + (weatherData?.timezoneOffset ?? 0);
      final setSunrise =
          DateTime.fromMillisecondsSinceEpoch(getSunriseTime * 1000);
      _sunrise = DateFormat('HH:mm').format(setSunrise);
      return sunrise ?? 'Error';
    } catch (e) {
      print(e);
    }

    return 'Error';
  }

  List<double> _valuesList = [];
  List<double> get valuesList => _valuesList;

  double setValues(int index) {
    _valuesList.add(current?.windSpeed ?? 0);
    _valuesList
        .add(((current?.feelsLike ?? -_kelvin) + _kelvin).roundToDouble());
    _valuesList.add((current?.humidity ?? 0.0) / 1);
    _valuesList.add((current?.visibility ?? 0) / 1000);

    return valuesList[index];
  }

  int? _dailyDayTemp = 0;
  int? get dailyDayTemp => _dailyDayTemp;

  int setDailyDayTemp(int index) {
    _dailyDayTemp =
        ((weatherData?.daily?[index].temp?.day ?? -_kelvin) + _kelvin).round();
    return dailyDayTemp ?? 0;
  }

  int? _dailyNightTemp;
  int? get dailyNightTemp => _dailyNightTemp;

  int setDailyNightTemp(int index) {
    _dailyNightTemp =
        ((weatherData?.daily?[index].temp?.night ?? -_kelvin) + _kelvin)
            .round();

    return dailyNightTemp ?? 0;
  }

  final String _iconUrlPath = 'http://openweathermap.org/img/wn/';

  String setDailyIcon(int index) {
    final String getIcon = '${weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = _iconUrlPath + getIcon + '.png';
    return setIcon;
  }

  final List<String> _date = [];
  List<String> get date => _date;

  List<Daily> _daily = [];
  List<Daily> get daily => _daily;

  void setDailyDays() {
    _daily = weatherData!.daily!;
    for (var i = 0; i < _daily.length; i++) {
      if (i == 0 && _date.isNotEmpty) _date.clear();

      if (i == 0) {
        _date.add('Сегодня');
      } else {
        var timeNum = ((_daily[i].dt!) * 1000);
        var itemDate = DateTime.fromMillisecondsSinceEpoch(timeNum);
        _date.add(capitalize(DateFormat('EEEE', 'ru').format(itemDate)));
      }
    }
  }

  String _setCurrentState = Bg.clearBg;
  String get setCurrentState => _setCurrentState;

  String setTheme() {
    int id = _current?.weather?[0].id ?? -1;

    if (id == null ||
        id == -1 ||
        _current?.sunset == null ||
        _current?.dt == null) return Bg.clearBg;

    try {
      if (_current!.sunset! > _current!.dt!) {
        if (id >= 200 && id <= 531) {
          _setCurrentState = Bg.rainBg;
          AppColors.textColor = const Color(0xFF030708);
          AppColors.valueColor = const Color(0xFF002C25);
          AppColors.boxBgColor = const Color.fromRGBO(106, 141, 135, 0.5);
        } else if (id >= 600 && id <= 622) {
          _setCurrentState = Bg.snowBg;
          AppColors.textColor = const Color(0xFF030708);
          AppColors.valueColor = const Color(0xFF002C25);
          AppColors.boxBgColor = const Color.fromRGBO(109, 160, 192, 0.5);
        } else if (id >= 701 && id <= 781) {
          _setCurrentState = Bg.fogBg;
          AppColors.textColor = const Color(0xFF323232);
          AppColors.valueColor = const Color(0xFFFFFFFF);
          AppColors.boxBgColor = const Color.fromRGBO(142, 141, 141, 0.5);
        } else if (id >= 801 && id <= 804) {
          _setCurrentState = Bg.cloudyBg;
          AppColors.textColor = const Color(0xFF001C39);
          AppColors.valueColor = const Color(0xFFFFFFFF);
          AppColors.boxBgColor = const Color.fromRGBO(140, 155, 170, 0.5);
        } else {
          _setCurrentState = Bg.clearBg;
          AppColors.textColor = const Color(0xFF002535);
          AppColors.valueColor = const Color(0xFFFFFFFF);
          AppColors.boxBgColor = const Color.fromRGBO(80, 130, 155, 0.3);
        }
      } else {
        if (id >= 200 && id <= 531) {
          _setCurrentState = Bg.rainNightBg;
          AppColors.textColor = const Color(0xFFC6C6C6);
          AppColors.valueColor = const Color(0xFFFFFFFF);
          AppColors.boxBgColor = const Color.fromRGBO(35, 35, 35, 0.5);
        } else if (id >= 600 && id <= 622) {
          _setCurrentState = Bg.snowNightBg;
          AppColors.textColor = const Color(0xFFE6E6E6);
          AppColors.valueColor = const Color(0xFFF9DADA);
          AppColors.boxBgColor = const Color.fromRGBO(12, 23, 27, 0.5);
        } else if (id >= 701 && id <= 781) {
          _setCurrentState = Bg.fogNightBg;
          AppColors.textColor = const Color(0xFFFFFFFF);
          AppColors.valueColor = const Color(0xFF999999);
          AppColors.boxBgColor = const Color.fromRGBO(35, 35, 35, 0.5);
        } else if (id >= 801 && id <= 804) {
          _setCurrentState = Bg.cloudyNightBg;
          AppColors.textColor = const Color(0xFFE2E2E2);
          AppColors.valueColor = const Color(0xFF7E8386);
          AppColors.boxBgColor = const Color.fromRGBO(12, 23, 27, 0.5);
        } else {
          _setCurrentState = Bg.clearNightBg;
          AppColors.textColor = const Color(0xFFFFFFFF);
          AppColors.valueColor = const Color(0xFF51DAFF);
          AppColors.boxBgColor = const Color.fromRGBO(47, 97, 148, 0.5);
        }
      }
    } catch (e) {
      return Bg.clearBg;
    }

    return setCurrentState;
  }

  Future<void> addFavorite(BuildContext context, {String? cityName}) async {
    var box = Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox);
    List cities = [];
    var values = box.values.toList();
    for (var i = 0; i < values.length; i++) {
      cities.add(values[i].cityName);
    }

    if (cities.contains(cityName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'Город '),
                TextSpan(
                  text: '$cityName',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' есть в избранных'),
              ],
            ),
          ),
        ),
      );
    } else {
      box
          .add(FavoriteHistory(
            weatherData?.timezone ?? 'Error',
            setCurrentState,
            AppColors.textColor.value,
          ))
          .then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'Город '),
                      TextSpan(
                        text: '$cityName',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' добавлен в избранное'),
                    ],
                  ),
                ),
              ),
            ),
          );
    }
  }

  Future<void> deleteFavorite(int index, BuildContext context,
      {String? cityName}) async {
    var box = Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox);
    box
        .deleteAt(index)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: RichText(
                    text: TextSpan(children: [
                  const TextSpan(text: 'Город '),
                  TextSpan(
                      text: '$cityName',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' удален из избранных'),
                ])),
              ),
            ));
  }

  WeatherProvider() {
    setUp();
    checkStatus();
    listener;
    checkInternet;
    notifyListeners();
  }
}
