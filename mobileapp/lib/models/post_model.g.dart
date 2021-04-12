// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationData _$PaginationDataFromJson(Map<String, dynamic> json) {
  return PaginationData()
    ..list = (json['nodes'] as List<dynamic>)
        ?.map((e) => PostData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..meta =
        PaginationMetaData.fromJson(json['pageInfo'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PaginationDataToJson(PaginationData instance) =>
    <String, dynamic>{
      'nodes': instance.list,
      'pageInfo': instance.meta,
    };

PostData _$PostDataFromJson(Map<String, dynamic> json) {
  return PostData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..type = PostType.fromJsonValue(json['kind'])
    ..isHalf = toBool(json['isHalf'])
    ..date = toDate(json['publishedAt'])
    ..texts = (json['text'] as List<dynamic>)?.map((e) => e as String)?.toList()
    ..stories = (json['stories'] as List<dynamic>)
        ?.map((e) => StoryData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..videoUrl = json['videoUrl'] as String
    ..durationSeconds = json['videoDuration'] as int
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$PostDataToJson(PostData instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kind', PostType.toJsonValue(instance.type));
  val['isHalf'] = instance.isHalf;
  val['publishedAt'] = instance.date.toIso8601String();
  val['text'] = instance.texts;
  val['stories'] = instance.stories;
  val['videoUrl'] = instance.videoUrl;
  val['videoDuration'] = instance.durationSeconds;
  val['imageUrl'] = instance.imageUrl;
  return val;
}

StoryData _$StoryDataFromJson(Map<String, dynamic> json) {
  return StoryData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..texts = (json['text'] as List<dynamic>)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$StoryDataToJson(StoryData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'text': instance.texts,
    };

PaginationMetaData _$PaginationMetaDataFromJson(Map<String, dynamic> json) {
  return PaginationMetaData()
    ..cursor = json['endCursor'] as String
    ..hasNextPage = json['hasNextPage'] as bool;
}

Map<String, dynamic> _$PaginationMetaDataToJson(PaginationMetaData instance) =>
    <String, dynamic>{
      'endCursor': instance.cursor,
      'hasNextPage': instance.hasNextPage,
    };
