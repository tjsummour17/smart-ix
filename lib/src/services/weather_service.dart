import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  WeatherService({
    this.languageCode = 'en',
  });

  final String languageCode;
  static const String _apiKey = '5f531f6a48ca531abf73f87db2904333';

  Language get weatherLanguage {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return Language.ENGLISH;
      case 'ar':
        return Language.ARABIC;
      case 'de':
        return Language.GERMAN;
      case 'tr':
        return Language.TURKISH;
      default:
        return Language.ENGLISH;
    }
  }

  Future<Weather> getWeatherStatus() async {
    final WeatherFactory _weatherFactory = WeatherFactory(
      _apiKey,
    );
    Position currentLocation = await _getCurrentLocation();
    return await _weatherFactory.currentWeatherByLocation(
      currentLocation.latitude,
      currentLocation.longitude,
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
