// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodData _$FoodDataFromJson(Map<String, dynamic> json) {
  return FoodData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..image = ImageData.fromJson(json['icon'] as Map<String, dynamic>)
    ..category =
        FoodCategoryData.fromJson(json['foodCategory'] as Map<String, dynamic>)
    ..structure = (json['structure'] as List<dynamic>)
        ?.map((e) => FoodSectionData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..championOn =
        (json['championOn'] as List<dynamic>)?.map((e) => e as String)?.toList()
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$FoodDataToJson(FoodData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.image,
      'foodCategory': instance.category,
      'structure': instance.structure,
      'championOn': instance.championOn,
      'imageUrl': instance.imageUrl,
    };

FoodSectionData _$FoodSectionDataFromJson(Map<String, dynamic> json) {
  return FoodSectionData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..key = json['key'] as String
    ..quantity = toDouble(json['quantity'])
    ..section = json['section'] as String
    ..unit = json['unit'] as String;
}

Map<String, dynamic> _$FoodSectionDataToJson(FoodSectionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'key': instance.key,
      'quantity': instance.quantity,
      'section': instance.section,
      'unit': instance.unit,
    };
