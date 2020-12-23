import 'package:hls/models/chat_card_model.dart';
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
  @JsonKey(fromJson: toInt)
  int activeDialogId;
  @JsonKey(
      name: 'finishedDialogs',
      fromJson: ChatDialogType.fromJsonList,
      toJson: ChatDialogType.toJsonList)
  List<ChatDialogType> chatDialogsCompleted;

  UserData();

  // getters

  String get avatarUri => null;
  List<ChatDialogType> get chatDialogsNotCompleted => ChatDialogType.values
      .where((x) => !(chatDialogsCompleted?.contains(x) ?? false))
      .toList(growable: false);
  ChatDialogType get dialog => chatDialogsNotCompleted.firstOrNull;

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
