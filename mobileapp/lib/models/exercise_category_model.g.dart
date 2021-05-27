// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseCategoryData _$ExerciseCategoryDataFromJson(Map<String, dynamic> json) {
  return ExerciseCategoryData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..image = ImageData.fromJson(json['icon'] as Map<String, dynamic>)
    ..children = (json['subcategories'] as List<dynamic>)
        .map((e) => ExerciseCategoryData.fromJson(e as Map<String, dynamic>))
        .toList()
    ..exercises = (json['trainings'] as List<dynamic>)
        .map((e) => ExerciseData.fromJson(e as Map<String, dynamic>))
        .toList()
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$ExerciseCategoryDataToJson(
        ExerciseCategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.image,
      'subcategories': instance.children,
      'trainings': instance.exercises,
      'imageUrl': instance.imageUrl,
    };
