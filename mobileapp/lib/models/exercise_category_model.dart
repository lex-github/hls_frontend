import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exercise_category_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ExerciseCategoryData extends GenericData {
  @JsonKey(name: 'icon')
  ImageData image;
  @JsonKey(name: 'subcategories')
  List<ExerciseCategoryData> children;
  @JsonKey(name: 'trainings')
  List<ExerciseData> exercises;

  ExerciseCategoryData();

  // getters
  @override
  String get imageUrl => image.url;

  factory ExerciseCategoryData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$ExerciseCategoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseCategoryDataToJson(this);

  @override
  String toString() => 'ExerciseCategoryData('
      '\n\tid: $id'
      '\n\ttitle: $title'
      '\n\tchildren: $children'
      '\n\texercises: $exercises'
      ')';
}
