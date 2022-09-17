// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirConditioner _$AirConditionerFromJson(Map<String, dynamic> json) =>
    AirConditioner(
      name: json['name'] as String,
      nickName: json['nickName'] as String,
      brand: json['brand'] as String,
      modelNumber: json['modelNumber'] as String,
      status: $enumDecode(_$DeviceStatusEnumMap, json['status']),
      id: json['id'] as String? ?? '',
    )..temperature = json['temperature'] as int? ?? 17;

Map<String, dynamic> _$AirConditionerToJson(AirConditioner instance) =>
    <String, dynamic>{
      'name': instance.name,
      'modelNumber': instance.modelNumber,
      'brand': instance.brand,
      'id': instance.id,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'nickName': instance.nickName,
      'temperature': instance.temperature,
    };

const _$DeviceStatusEnumMap = {
  DeviceStatus.on: 'on',
  DeviceStatus.off: 'off',
  DeviceStatus.sleep: 'sleep',
};

Dishwasher _$DishwasherFromJson(Map<String, dynamic> json) => Dishwasher(
      name: json['name'] as String,
      nickName: json['nickName'] as String,
      brand: json['brand'] as String,
      modelNumber: json['modelNumber'] as String,
      status: $enumDecode(_$DeviceStatusEnumMap, json['status']),
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$DishwasherToJson(Dishwasher instance) =>
    <String, dynamic>{
      'name': instance.name,
      'modelNumber': instance.modelNumber,
      'brand': instance.brand,
      'id': instance.id,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'nickName': instance.nickName,
    };

WashingMachine _$WashingMachineFromJson(Map<String, dynamic> json) =>
    WashingMachine(
      name: json['name'] as String,
      nickName: json['nickName'] as String,
      brand: json['brand'] as String,
      modelNumber: json['modelNumber'] as String,
      status: $enumDecode(_$DeviceStatusEnumMap, json['status']),
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$WashingMachineToJson(WashingMachine instance) =>
    <String, dynamic>{
      'name': instance.name,
      'modelNumber': instance.modelNumber,
      'brand': instance.brand,
      'id': instance.id,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'nickName': instance.nickName,
    };
