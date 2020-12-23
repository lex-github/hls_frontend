import 'package:hls/constants/strings.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/models/_generic_model.dart';

part 'chat_card_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ChatCardData extends GenericData {
  String key;
  @JsonKey(
      fromJson: ChatQuestionType.fromJsonValue,
      toJson: ChatQuestionType.toJsonValue)
  ChatQuestionType questionType;
  ChatValidationData addons;
  List<ChatQuestionData> questions;
  // String email;
  // @JsonKey(name: 'phoneNumber')
  // String phone;
  // @JsonKey(name: 'data')
  // UserDetailsData details;
  // @JsonKey(fromJson: toInt)
  // int activeDialogId;

  ChatCardData();

  // getters

  factory ChatCardData.fromJson(Map<String, dynamic> json) =>
      _$ChatCardDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatCardDataToJson(this);

  @override
  String toString() => 'ChatCardData(id: $key)';
}

@JsonSerializable(includeIfNull: false)
class ChatQuestionData {
  String text;

  ChatQuestionData();

  factory ChatQuestionData.fromJson(Map<String, dynamic> json) =>
    _$ChatQuestionDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatQuestionDataToJson(this);

  @override
  String toString() => '$text';
}

@JsonSerializable(includeIfNull: false)
class ChatValidationData {
  String regexp;

  ChatValidationData();

  factory ChatValidationData.fromJson(Map<String, dynamic> json) =>
    _$ChatValidationDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatValidationDataToJson(this);

  @override
  String toString() => '$regexp';
}

class ChatDialogType extends GenericEnum<String> {
  const ChatDialogType({String value, String title})
      : super(value: value, title: title);

  static ChatDialogType fromValue(value) =>
      values.firstWhere((x) => x.value == value, orElse: () => null);

  static ChatDialogType fromJsonValue(value) => fromValue(value);
  static List<ChatDialogType> fromJsonList(List values) =>
      values.map(fromValue).toList(growable: false);
  static toJsonValue(item) => item?.value;
  static List toJsonList(List values) =>
      values.map(toJsonValue).toList(growable: false);

  static const WELCOME =
      ChatDialogType(value: 'welcome', title: chatWelcomeTitle);
  static const NUTRITION =
      ChatDialogType(value: 'nutrition', title: chatNutritionTitle);
  static const LIFESTYLE =
      ChatDialogType(value: 'lifestyle', title: chatLifestyleTitle);
  static const MEDICAL =
      ChatDialogType(value: 'medical', title: chatMedicalTitle);
  static const PHYSICAL =
      ChatDialogType(value: 'physical', title: chatPhysicalTitle);

  static const values = [WELCOME, NUTRITION, LIFESTYLE, MEDICAL, PHYSICAL];

  @override
  String toString() => '$value';
}

class ChatQuestionType extends GenericEnum<String> {
  const ChatQuestionType({String value}) : super(value: value);

  static ChatQuestionType fromValue(value) =>
      values.firstWhere((x) => x.value == value, orElse: () => null);

  static ChatQuestionType fromJsonValue(value) => fromValue(value);
  static toJsonValue(item) => item?.value;

  static const INPUT = ChatQuestionType(value: 'input');
  static const RADIO = ChatQuestionType(value: 'radio');
  static const CHECKBOX = ChatQuestionType(value: 'checkbox');
  static const TIMER = ChatQuestionType(value: 'timer');

  static const values = [INPUT, RADIO, CHECKBOX, TIMER];

  @override
  String toString() => '$value';
}
