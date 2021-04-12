// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_generic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericData _$GenericDataFromJson(Map<String, dynamic> json) {
  return GenericData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$GenericDataToJson(GenericData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
    };
