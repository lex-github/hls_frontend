import 'package:flutter/rendering.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
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
  List<ChatQuestionData> questions;
  ChatQuestionStyleData style;
  ChatValidationData addons;
  Map<String, ChatAnswerData> answers;
  Map<String, List<ChatQuestionData>> results;

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
  @JsonKey(name: 'image_url')
  String imageUrl;
  @JsonKey(fromJson: toColor, toJson: colorToString)
  Color color;

  ChatQuestionData();

  factory ChatQuestionData.fromJson(Map<String, dynamic> json) =>
      _$ChatQuestionDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatQuestionDataToJson(this);

  @override
  String toString() => '$text';
}

@JsonSerializable(includeIfNull: false)
class ChatQuestionStyleData {
  @JsonKey(name: 'row')
  int rows;
  @JsonKey(name: 'column')
  int columns;

  ChatQuestionStyleData();

  factory ChatQuestionStyleData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$ChatQuestionStyleDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatQuestionStyleDataToJson(this);

  @override
  String toString() => '[$rows x $columns]';
}

@JsonSerializable(includeIfNull: false)
class ChatValidationData {
  String regexp;
  @JsonKey(fromJson: toInt)
  int duration;
  @JsonKey(name: 'should_require_result')
  bool shouldRequireResult;

  ChatValidationData();

  factory ChatValidationData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$ChatValidationDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatValidationDataToJson(this);

  @override
  String toString() => '$regexp';
}

@JsonSerializable(includeIfNull: false)
class ChatAnswerData {
  @JsonKey(name: 'image_url')
  String imageUrl;
  String text;
  String value;

  ChatAnswerData();

  factory ChatAnswerData.fromJson(Map<String, dynamic> json) =>
      _$ChatAnswerDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatAnswerDataToJson(this);

  @override
  String toString() => '$text';
}

@JsonSerializable(includeIfNull: false)
class ChatDialogStatusData extends GenericData {
  @JsonKey(
      name: 'name',
      fromJson: ChatDialogType.fromJsonValue,
      toJson: ChatDialogType.toJsonValue)
  ChatDialogType type;
  @JsonKey(
      fromJson: ChatDialogStatus.fromJsonValue,
      toJson: ChatDialogStatus.toJsonValue)
  ChatDialogStatus status;
  List<ChatHistoryData> history;
  //UserData user;

  ChatDialogStatusData();

  factory ChatDialogStatusData.fromJson(Map<String, dynamic> json) =>
      _$ChatDialogStatusDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDialogStatusDataToJson(this);

  @override
  String toString() => 'ChatDialogStatusData('
      '\n\ttype: $type '
      '\n\thistory: $history'
      ')';
}

@JsonSerializable(includeIfNull: false)
class ChatHistoryData {
  ChatHistoryData();

  int order;
  List<ChatQuestionData> question;
  List<ChatAnswerData> answer;

  factory ChatHistoryData.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatHistoryDataToJson(this);

  @override
  String toString() => 'ChatHistoryData('
      '\n\tquestion: $question'
      '\n\tanswer: $answer'
      ')';
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

class ChatDialogStatus extends GenericEnum<String> {
  const ChatDialogStatus({String value}) : super(value: value);

  static ChatDialogStatus fromValue(value) =>
      values.firstWhere((x) => x.value == value, orElse: () => null);

  static ChatDialogStatus fromJsonValue(value) => fromValue(value);
  static toJsonValue(item) => item?.value;

  static const ACTIVE = ChatDialogStatus(value: 'active');
  static const PENDING = ChatDialogStatus(value: 'pending');
  static const FINISHED = ChatDialogStatus(value: 'finished');

  static const values = [ACTIVE, PENDING, FINISHED];

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
