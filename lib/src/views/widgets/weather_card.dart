import 'package:flutter/material.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/views/widgets/container_decoration.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

class WeatherAssets {
  WeatherAssets._();

  static const String rainy = 'assets/images/weather/rainy.jpg';
  static const String cloudy = 'assets/images/weather/cloudy.jpg';
  static const String partlyCloudy = 'assets/images/weather/partly-cloudy.jpg';

  static String getImageBaseOnWeather(int code) {
    if (code >= 200 && code < 300) {
      return rainy;
    } else if (code >= 300 && code < 400) {
      return rainy;
    } else if (code == 800) {
      return partlyCloudy;
    } else if (code > 800) {
      return cloudy;
    } else {
      return partlyCloudy;
    }
  }
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key, required this.weather}) : super(key: key);
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ContainerDecoration.cardStyle(context).copyWith(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              WeatherAssets.getImageBaseOnWeather(
                weather.weatherConditionCode ?? 800,
              ),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: ContainerDecoration.cardStyle(context).borderRadius,
            color: Colors.black.withOpacity(0.25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${weather.weatherIcon}.png',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${weather.temperature?.celsius?.toStringAsFixed(1) ?? '-'} °C',
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                weather.weatherDescription ?? '',
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                '${weather.country} - ${weather.areaName}',
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    DateFormat('dd/MM/yyyy hh:mm')
                        .format(weather.date ?? DateTime.now()),
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
