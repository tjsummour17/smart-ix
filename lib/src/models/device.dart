import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

enum DeviceStatus { on, off, sleep }

abstract class Device {
  Device({
    required this.type,
    required this.name,
    required this.nickName,
    required this.brand,
    required this.modelNumber,
    required this.status,
    this.id = '',
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    if (type == 'airConditioner') {
      return AirConditioner.fromJson(json);
    } else if (type == 'dishwasher') {
      return Dishwasher.fromJson(json);
    } else if (type == 'washingMachine') {
      return WashingMachine.fromJson(json);
    }

    throw 'Type is not supported';
  }

  final String type;
  final String name;
  final String modelNumber;
  final String brand;
  final String id;
  DeviceStatus status;
  String nickName;

  void turnOn();

  void turnOff();

  void sleepMode();

  Map<String, dynamic> toJson();
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class AirConditioner extends Device {
  AirConditioner({
    required super.name,
    required super.nickName,
    required super.brand,
    required super.modelNumber,
    required super.status,
    super.id,
  }) : super(type: 'airConditioner');

  factory AirConditioner.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerFromJson(json);

  @JsonKey(defaultValue: 17)
  int temperature = 17;

  @override
  void turnOff() {
    status = DeviceStatus.off;
  }

  @override
  void sleepMode() {
    status = DeviceStatus.off;
  }

  @override
  void turnOn() {
    status = DeviceStatus.on;
  }

  void increaseTemperature() {
    if (temperature < 30) temperature++;
  }

  void decreaseTemperature() {
    if (temperature > 16) temperature--;
  }

  @override
  Map<String, dynamic> toJson() => _$AirConditionerToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class Dishwasher extends Device {
  Dishwasher({
    required super.name,
    required super.nickName,
    required super.brand,
    required super.modelNumber,
    required super.status,
    super.id,
  }) : super(type: 'dishwasher');

  factory Dishwasher.fromJson(Map<String, dynamic> json) =>
      _$DishwasherFromJson(json);

  @override
  void turnOff() {
    status = DeviceStatus.off;
  }

  @override
  void turnOn() {
    status = DeviceStatus.on;
  }

  @override
  void sleepMode() {
    status = DeviceStatus.sleep;
  }

  @override
  Map<String, dynamic> toJson() => _$DishwasherToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class WashingMachine extends Device {
  WashingMachine({
    required super.name,
    required super.nickName,
    required super.brand,
    required super.modelNumber,
    required super.status,
    super.id,
  }) : super(type: 'washingMachine');

  factory WashingMachine.fromJson(Map<String, dynamic> json) =>
      _$WashingMachineFromJson(json);

  @override
  void turnOff() {
    status = DeviceStatus.off;
  }

  @override
  void sleepMode() {
    status = DeviceStatus.sleep;
  }

  @override
  void turnOn() {
    status = DeviceStatus.on;
  }

  @override
  Map<String, dynamic> toJson() => _$WashingMachineToJson(this);
}
