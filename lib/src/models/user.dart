import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
@HiveType(typeId: 0)
class User {
  const User({
    this.id = '',
    required this.name,
    required this.phone,
    required this.email,
    this.password = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String password;

  User copy({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    bool? isVerified,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
