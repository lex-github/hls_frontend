// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodData _$FoodDataFromJson(Map<String, dynamic> json) {
  return FoodData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..structure = (json['structure'] as List)
        ?.map((e) => e == null
            ? null
            : FoodSectionData.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$FoodDataToJson(FoodData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('structure', instance.structure);
  return val;
}

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

Map<String, dynamic> _$FoodSectionDataToJson(FoodSectionData instance) {
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
  writeNotNull('quantity', instance.quantity);
  writeNotNull('section', instance.section);
  writeNotNull('unit', instance.unit);
  return val;
}

ImageData _$ImageDataFromJson(Map<String, dynamic> json) {
  return ImageData()..url = json['url'] as String;
}

Map<String, dynamic> _$ImageDataToJson(ImageData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  return val;
}
