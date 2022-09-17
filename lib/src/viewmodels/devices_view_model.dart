import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:smart_ix/src/models/device.dart';
import 'package:smart_ix/src/repo/device_firebase_repo.dart';

class DevicesViewModel with ChangeNotifier {
  DeviceFirebaseRepo repo = DeviceFirebaseRepo();
  bool _isLoading = true;
  List<Device> _devices = [];

  List<Device> get devices => _devices;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addDevice(Device device) async {
    isLoading = true;
    await repo.add(device: device);
    _devices.add(device);
    isLoading = false;
  }

  Future<void> updateDevice(Device device) async {
    isLoading = true;
    await repo.update(device: device);
    int index = _devices.indexWhere((element) => element.id == device.id);
    _devices[index] = device;
    isLoading = false;
  }

  Future<void> deleteDevise(Device device) async {
    isLoading = true;
    await repo.delete(deviceId: device.id);
    _devices.removeWhere((element) => element.id == device.id);
    isLoading = false;
  }

  Future<void> getDevices() async {
    _devices = (await repo.get()) ?? [];
    isLoading = false;
  }

  Future<bool> tryAddDevice(String? code) async {
    if (code != null) {
      try {
        log(code);
        final device =
            Device.fromJson(jsonDecode(code) as Map<String, dynamic>);
        await addDevice(device);
        return true;
      } catch (e) {
        log(e.toString());
        return false;
      }
    }
    return false;
  }
}
