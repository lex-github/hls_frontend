import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_category_model.g.dart';

@JsonSerializable(includeIfNull: false)
class FoodCategoryData extends GenericData {
  @JsonKey(name: 'icon')
  ImageData image;
  @JsonKey(name: 'subcategories')
  List<FoodCategoryData> children;
  @JsonKey(name: 'parentCategory')
  FoodCategoryData parent;
  List<FoodData> foods;

  FoodCategoryData();

  // getters
  @override
  String get imageUrl => image.url;
  bool get canExpand => children.isNullOrEmpty && foods.length > 1;

  factory FoodCategoryData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$FoodCategoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$FoodCategoryDataToJson(this);

  @override
  String toString() => 'FoodCategoryData('
      '\n\tid: $id'
      '\n\ttitle: $title'
      '\n\tchildren: $children'
      '\n\tfoods: $foods'
      ')';
}
