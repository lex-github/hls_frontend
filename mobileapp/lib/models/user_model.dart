import 'package:hls/constants/strings.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/iterables.dart';
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
  @JsonKey(
      name: 'finishedDialogs',
      fromJson: DialogType.fromJsonList,
      toJson: DialogType.toJsonList)
  List<DialogType> chatDialogsCompleted;

  UserData();

  // getters

  String get avatarUri => null;
  List<DialogType> get chatDialogsNotCompleted => DialogType.values
      .where((x) => !(chatDialogsCompleted?.contains(x) ?? false))
      .toList(growable: false);
  DialogType get dialog => chatDialogsNotCompleted.firstOrNull;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() => 'UserData(id: $id, name: $name)';
}

@JsonSerializable(includeIfNull: false)
class UserDetailsData {
  int age;
  @JsonKey(fromJson: GenderType.fromJsonValue, toJson: GenderType.toJsonValue)
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

class GenderType extends GenericEnum<String> {
  const GenderType({String value}) : super(value: value);

  static GenderType fromValue(value) => values
      .firstWhere((x) => x.value == value, orElse: () => GenderType.OTHER);

  static GenderType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = GenderType(value: '?');
  static const MALE = GenderType(value: 'M');
  static const FEMALE = GenderType(value: 'F');

  static const values = [MALE, FEMALE];

  @override
  String toString() => '$value';
}

class DialogType extends GenericEnum<String> {
  const DialogType({String value, String title})
      : super(value: value, title: title);

  static DialogType fromValue(value) =>
      values.firstWhere((x) => x.value == value, orElse: () => null);

  static DialogType fromJsonValue(value) => fromValue(value);
  static List<DialogType> fromJsonList(List values) =>
      values.map(fromValue).toList(growable: false);
  static toJsonValue(item) => item?.value;
  static List toJsonList(List values) =>
      values.map(toJsonValue).toList(growable: false);

  static const WELCOME = DialogType(value: 'welcome', title: chatWelcomeTitle);
  static const NUTRITION =
      DialogType(value: 'nutrition', title: chatNutritionTitle);
  static const LIFESTYLE =
      DialogType(value: 'lifestyle', title: chatLifestyleTitle);
  static const MEDICAL = DialogType(value: 'medical', title: chatMedicalTitle);
  static const PHYSICAL =
      DialogType(value: 'physical', title: chatPhysicalTitle);

  static const values = [WELCOME, NUTRITION, LIFESTYLE, MEDICAL, PHYSICAL];

  @override
  String toString() => '$value';
}
