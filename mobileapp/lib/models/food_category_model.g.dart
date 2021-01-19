// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodCategoryData _$FoodCategoryDataFromJson(Map<String, dynamic> json) {
  return FoodCategoryData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..image = json['icon'] == null
        ? null
        : ImageData.fromJson(json['icon'] as Map<String, dynamic>)
    ..children = (json['subcategories'] as List)
        ?.map((e) => e == null
            ? null
            : FoodCategoryData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..parent = json['parentCategory'] == null
        ? null
        : FoodCategoryData.fromJson(
            json['parentCategory'] as Map<String, dynamic>)
    ..foods = (json['foods'] as List)
        ?.map((e) =>
            e == null ? null : FoodData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$FoodCategoryDataToJson(FoodCategoryData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('icon', instance.image);
  writeNotNull('subcategories', instance.children);
  writeNotNull('parentCategory', instance.parent);
  writeNotNull('foods', instance.foods);
  writeNotNull('imageUrl', instance.imageUrl);
  return val;
}
