import 'package:flutter/material.dart';
import 'package:smart_ix/src/models/device.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/views/device_details_page.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({Key? key, required this.device}) : super(key: key);

  final Device device;

  Widget _buildStatus() => Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: device.status == DeviceStatus.on
              ? Colors.green
              : device.status == DeviceStatus.off
                  ? const Color(0xFFFF0000)
                  : Colors.orange,
        ),
        child: Center(
          child: Text(
            device.status.name,
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
    final Device device = this.device;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  device.nickName,
                  style: context.textTheme.titleMedium,
                ),
              ),
              _buildStatus(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            device.name,
            style: context.textTheme.titleSmall,
          ),
          if (device is AirConditioner) ...[
            const SizedBox(height: 10),
            Text(
              '${context.appLocalizations.temperature}: ${device.temperature}',
              style: context.textTheme.titleSmall,
            )
          ],
          const Spacer(),
          Text(
            '${device.brand} - ${device.modelNumber}',
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
      onPressed: () => Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceDetailsPage(device: device),
        ),
      ),
    );
  }
}
