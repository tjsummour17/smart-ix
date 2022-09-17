import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ix/src/providers/locale_provider.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/viewmodels/devices_view_model.dart';
import 'package:smart_ix/src/viewmodels/main_page_view_model.dart';
import 'package:smart_ix/src/views/widgets/container_decoration.dart';
import 'package:smart_ix/src/views/widgets/device_card.dart';
import 'package:smart_ix/src/views/widgets/loading_widget.dart';
import 'package:smart_ix/src/views/widgets/main_button.dart';
import 'package:smart_ix/src/views/widgets/weather_card.dart';
import 'package:weather/weather.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final String _newsLink = 'https://news.google.com';

  Widget _deviceItemBuilder(BuildContext context, int index) {
    DevicesViewModel devicesViewModel = context.watch();
    return DeviceCard(device: devicesViewModel.devices[index]);
  }

  @override
  void initState() {
    super.initState();
    DevicesViewModel devicesViewModel = context.read();
    devicesViewModel.getDevices();
  }

  @override
  Widget build(BuildContext context) {
    MainPageViewModel mainPageViewModel = context.watch();
    LocaleProvider localeProvider = context.watch();
    Weather? weather = mainPageViewModel.weather;
    DevicesViewModel devicesViewModel = context.watch();
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        if (weather != null)
          WeatherCard(weather: weather)
        else
          MainButton(
            onPressed: () => mainPageViewModel.getCurrentWeather(
              languageCode: localeProvider.locale.languageCode,
            ),
            child: Text(context.appLocalizations.enableWeather),
          ),
        const SizedBox(height: 20),
        Container(
          decoration: ContainerDecoration.cardStyle(context),
          child: ListTile(
            title: Text(context.appLocalizations.news),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => launchUrl(Uri.parse(_newsLink)),
          ),
        ),
        Stack(
          children: [
            if (devicesViewModel.devices.isNotEmpty)
              GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shrinkWrap: true,
                itemBuilder: _deviceItemBuilder,
                itemCount: devicesViewModel.devices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Text(context.appLocalizations.thereAreNoSignedDevices),
                ),
              ),
            if (devicesViewModel.isLoading) const LoadingWidget()
          ],
        )
      ],
    );
  }
}
