// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCardData _$ChatCardDataFromJson(Map<String, dynamic> json) {
  return ChatCardData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..key = json['key'] as String
    ..questionType = ChatQuestionType.fromJsonValue(json['questionType'])
    ..questions = (json['questions'] as List)
        ?.map((e) => e == null
            ? null
            : ChatQuestionData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..style = json['style'] == null
        ? null
        : ChatQuestionStyleData.fromJson(json['style'] as Map<String, dynamic>)
    ..addons = json['addons'] == null
        ? null
        : ChatValidationData.fromJson(json['addons'] as Map<String, dynamic>)
    ..answers = (json['answers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : ChatAnswerData.fromJson(e as Map<String, dynamic>)),
    )
    ..results = (json['results'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : ChatQuestionData.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    );
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
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('key', instance.key);
  writeNotNull(
      'questionType', ChatQuestionType.toJsonValue(instance.questionType));
  writeNotNull('questions', instance.questions);
  writeNotNull('style', instance.style);
  writeNotNull('addons', instance.addons);
  writeNotNull('answers', instance.answers);
  writeNotNull('results', instance.results);
  return val;
}

ChatQuestionData _$ChatQuestionDataFromJson(Map<String, dynamic> json) {
  return ChatQuestionData()
    ..text = json['text'] as String
    ..imageUrl = json['image_url'] as String
    ..color = toColor(json['color']);
}

Map<String, dynamic> _$ChatQuestionDataToJson(ChatQuestionData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('color', colorToString(instance.color));
  return val;
}

ChatQuestionStyleData _$ChatQuestionStyleDataFromJson(
    Map<String, dynamic> json) {
  return ChatQuestionStyleData()
    ..rows = json['row'] as int
    ..columns = json['column'] as int;
}

Map<String, dynamic> _$ChatQuestionStyleDataToJson(
    ChatQuestionStyleData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('row', instance.rows);
  writeNotNull('column', instance.columns);
  return val;
}

ChatValidationData _$ChatValidationDataFromJson(Map<String, dynamic> json) {
  return ChatValidationData()
    ..regexp = json['regexp'] as String
    ..duration = toInt(json['duration'])
    ..shouldRequireResult = json['should_require_result'] as bool;
}

Map<String, dynamic> _$ChatValidationDataToJson(ChatValidationData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('regexp', instance.regexp);
  writeNotNull('duration', instance.duration);
  writeNotNull('should_require_result', instance.shouldRequireResult);
  return val;
}

ChatAnswerData _$ChatAnswerDataFromJson(Map<String, dynamic> json) {
  return ChatAnswerData()
    ..imageUrl = json['image_url'] as String
    ..text = json['text'] as String
    ..value = json['value'] as String;
}

Map<String, dynamic> _$ChatAnswerDataToJson(ChatAnswerData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('text', instance.text);
  writeNotNull('value', instance.value);
  return val;
}

ChatDialogStatusData _$ChatDialogStatusDataFromJson(Map<String, dynamic> json) {
  return ChatDialogStatusData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..type = ChatDialogType.fromJsonValue(json['name'])
    ..status = ChatDialogStatus.fromJsonValue(json['status']);
}

Map<String, dynamic> _$ChatDialogStatusDataToJson(
    ChatDialogStatusData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('name', ChatDialogType.toJsonValue(instance.type));
  writeNotNull('status', ChatDialogStatus.toJsonValue(instance.status));
  return val;
}
