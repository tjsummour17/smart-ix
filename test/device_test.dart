import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ix/src/models/device.dart';

void main() async {
  test('Turn On Air Conditioner', () {
    Device device = AirConditioner(
      name: 'name',
      nickName: 'nickName',
      brand: 'brand',
      modelNumber: 'modelNumber',
      status: DeviceStatus.off,
    );
    device.turnOn();
    expect(DeviceStatus.on, equals(device.status));
  });

  test('Turn off Air Conditioner', () {
    Device device = AirConditioner(
      name: 'name',
      nickName: 'nickName',
      brand: 'brand',
      modelNumber: 'modelNumber',
      status: DeviceStatus.on,
    );
    device.turnOff();
    expect(DeviceStatus.off, equals(device.status));
  });

  test('Sleep Air Conditioner', () {
    Device device = AirConditioner(
      name: 'name',
      nickName: 'nickName',
      brand: 'brand',
      modelNumber: 'modelNumber',
      status: DeviceStatus.on,
    );
    device.sleepMode();
    expect(DeviceStatus.off, equals(device.status));
  });

  test('Change Air Conditioner temperature', () {
    AirConditioner device = AirConditioner(
      name: 'name',
      nickName: 'nickName',
      brand: 'brand',
      modelNumber: 'modelNumber',
      status: DeviceStatus.on,
    );
    device.temperature = 17;
    device.increaseTemperature();
    expect(18, equals(device.temperature));

    device.temperature = 30;
    device.increaseTemperature();
    expect(30, equals(device.temperature));

    device.temperature = 17;
    device.decreaseTemperature();
    expect(16, equals(device.temperature));

    device.temperature = 16;
    device.decreaseTemperature();
    expect(16, equals(device.temperature));
  });
}
