import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ix/src/models/device.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/viewmodels/devices_view_model.dart';
import 'package:smart_ix/src/views/widgets/main_button.dart';

class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);
  final Device device;

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  Widget _buildStatus() => Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.device.status == DeviceStatus.on
              ? Colors.green
              : widget.device.status == DeviceStatus.off
                  ? const Color(0xFFFF0000)
                  : Colors.orange,
        ),
        child: Center(
          child: Text(
            widget.device.status.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    DevicesViewModel devicesViewModel = context.read();
    return Scaffold(
      appBar: AppBar(
        title: Text(device.nickName),
        actions: [
          Center(child: _buildStatus()),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Row(
            children: [
              Text(
                context.appLocalizations.deviceName,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  initialValue: device.nickName,
                  style: context.textTheme.titleMedium,
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      device.nickName = value.trim();
                      devicesViewModel.updateDevice(device);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            device.name,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          if (device is AirConditioner) ...[
            Text(
              '${context.appLocalizations.temperature}: ${device.temperature}',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
          ],
          Text('${device.brand} - ${device.modelNumber}'),
          const SizedBox(height: 15),
          if (device is AirConditioner) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    device.decreaseTemperature();
                    devicesViewModel.updateDevice(device);
                  }),
                  icon: const Icon(Icons.remove_circle),
                  iconSize: 30,
                  color: const Color(0xFFFF0000),
                ),
                Text(
                  device.temperature.toString(),
                  style: context.textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => setState(() {
                    device.increaseTemperature();
                    devicesViewModel.updateDevice(device);
                  }),
                  icon: const Icon(Icons.add_circle),
                  iconSize: 30,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
          Wrap(
            spacing: 15,
            children: DeviceStatus.values
                .map(
                  (e) => MainButton(
                    onPressed: () {
                      if (e == DeviceStatus.on) {
                        device.turnOn();
                      } else if (e == DeviceStatus.off) {
                        device.turnOff();
                      } else {
                        device.sleepMode();
                      }
                      setState(() {});
                      devicesViewModel.updateDevice(device);
                    },
                    child: Text(
                      e == DeviceStatus.sleep ? 'Sleep Mode' : 'Turn ${e.name}',
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 75),
          Center(
            child: MainButton(
              backgroundColor: context.colorScheme.error,
              child: Text(context.appLocalizations.deleteDevice),
              onPressed: () {
                devicesViewModel.deleteDevise(device);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
