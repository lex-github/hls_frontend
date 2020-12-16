import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/models/_generic_model.dart';

part 'user_model.g.dart';

@JsonSerializable(includeIfNull: false)
class UserData extends GenericData {
  String name;
  String email;
  @JsonKey(name: 'phoneNumber')
  String phone;
  @JsonKey(name: 'data')
  UserDetailsData details;

  String get avatarUri => null;

  UserData();

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() => 'UserData(id: $id, name: $name)';
}

@JsonSerializable(includeIfNull: false)
class UserDetailsData {
  int age;
  @JsonKey(fromJson: GenderType.fromJson, toJson: GenderType.toJsonValue)
  GenderType gender;
  int weight;

  UserDetailsData();

  factory UserDetailsData.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailsDataToJson(this);

  @override
  String toString() =>
      'UserDetailsData(age: $age, gender: $gender, weight: $weight)';
}

class GenderType extends GenericEnum<int> {
  const GenderType({int value, String imageTitle, IconData icon})
      : assert(icon != null || imageTitle != null),
        super(value: value, imageTitle: imageTitle, icon: icon);

  static GenderType fromValue(value) => values
      .firstWhere((x) => x.value == value, orElse: () => GenderType.OTHER);
  static GenderType fromJson(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = GenderType(value: 0, icon: Icons.error);
  static const MALE = GenderType(
      value: 1,
      //imageTitle: 'icons/male',
      icon: Icons.error);
  static const FEMALE = GenderType(
      value: 2,
      //imageTitle: 'icons/female'
      icon: Icons.error);

  static const values = [MALE, FEMALE];

  @override
  String toString() => '$value';
}
