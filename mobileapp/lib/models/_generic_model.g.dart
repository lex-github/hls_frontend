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

Map<String, dynamic> _$GenericDataToJson(GenericData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('imageUrl', instance.imageUrl);
  return val;
}
