// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodCategoryData _$FoodCategoryDataFromJson(Map<String, dynamic> json) {
  return FoodCategoryData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..image = ImageData.fromJson(json['icon'] as Map<String, dynamic>)
    ..children = (json['subcategories'] as List<dynamic>)
        ?.map((e) => FoodCategoryData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..parent = FoodCategoryData.fromJson(
        json['parentCategory'] as Map<String, dynamic>)
    ..foods = (json['foods'] as List<dynamic>)
        ?.map((e) => FoodData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$FoodCategoryDataToJson(FoodCategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.image,
      'subcategories': instance.children,
      'parentCategory': instance.parent,
      'foods': instance.foods,
      'imageUrl': instance.imageUrl,
    };
