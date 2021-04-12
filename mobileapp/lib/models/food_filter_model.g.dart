// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodFilterData _$FoodFilterDataFromJson(Map<String, dynamic> json) {
  return FoodFilterData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..key = json['key'] as String
    ..values = FilterValueData.fromJson(json['values'] as Map<String, dynamic>)
    ..section = json['section'] as String;
}

Map<String, dynamic> _$FoodFilterDataToJson(FoodFilterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'key': instance.key,
      'values': instance.values,
      'section': instance.section,
    };

FilterValueData _$FilterValueDataFromJson(Map<String, dynamic> json) {
  return FilterValueData()
    ..min = toDouble(json['min'])
    ..max = toDouble(json['max']);
}

Map<String, dynamic> _$FilterValueDataToJson(FilterValueData instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };
