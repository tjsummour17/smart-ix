import 'package:flutter/material.dart';
import 'package:smart_ix/src/services/weather_service.dart';
import 'package:weather/weather.dart';

class MainPageViewModel with ChangeNotifier {
  Weather? _weather;

  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  Weather? get weather => _weather;

  void changePage(int value) {
    _pageIndex = value;
    notifyListeners();
  }

  Future<void> getCurrentWeather({required String languageCode}) async {
    _weather =
        await WeatherService(languageCode: languageCode).getWeatherStatus();
    notifyListeners();
  }
}
