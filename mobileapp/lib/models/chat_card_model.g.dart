// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCardData _$ChatCardDataFromJson(Map<String, dynamic> json) {
  return ChatCardData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUri = json['imageUri'] as String
    ..key = json['key'] as String
    ..questionType = ChatQuestionType.fromJsonValue(json['questionType'])
    ..addons = json['addons'] == null
        ? null
        : ChatValidationData.fromJson(json['addons'] as Map<String, dynamic>)
    ..questions = (json['questions'] as List)
        ?.map((e) => e == null
            ? null
            : ChatQuestionData.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ChatCardDataToJson(ChatCardData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('imageUri', instance.imageUri);
  writeNotNull('key', instance.key);
  writeNotNull(
      'questionType', ChatQuestionType.toJsonValue(instance.questionType));
  writeNotNull('addons', instance.addons);
  writeNotNull('questions', instance.questions);
  return val;
}

ChatQuestionData _$ChatQuestionDataFromJson(Map<String, dynamic> json) {
  return ChatQuestionData()..text = json['text'] as String;
}

Map<String, dynamic> _$ChatQuestionDataToJson(ChatQuestionData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  return val;
}

ChatValidationData _$ChatValidationDataFromJson(Map<String, dynamic> json) {
  return ChatValidationData()..regexp = json['regexp'] as String;
}

Map<String, dynamic> _$ChatValidationDataToJson(ChatValidationData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('regexp', instance.regexp);
  return val;
}
