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
    ..values = json['values'] == null
        ? null
        : FilterValueData.fromJson(json['values'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FoodFilterDataToJson(FoodFilterData instance) {
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
  writeNotNull('values', instance.values);
  return val;
}

FilterValueData _$FilterValueDataFromJson(Map<String, dynamic> json) {
  return FilterValueData()
    ..min = (json['min'] as num)?.toDouble()
    ..max = (json['max'] as num)?.toDouble();
}

Map<String, dynamic> _$FilterValueDataToJson(FilterValueData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('min', instance.min);
  writeNotNull('max', instance.max);
  return val;
}
