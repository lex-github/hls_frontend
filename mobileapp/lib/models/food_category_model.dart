import 'package:hls/helpers/convert.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/models/_generic_model.dart';

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

  factory FoodCategoryData.fromJson(Map<String, dynamic> json) =>
      _$FoodCategoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$FoodCategoryDataToJson(this);

  @override
  String toString() => 'FoodCategoryData(title: $title)';
}

@JsonSerializable(includeIfNull: false)
class FoodData extends GenericData {
  FoodData();

  factory FoodData.fromJson(Map<String, dynamic> json) =>
    _$FoodDataFromJson(json);
  Map<String, dynamic> toJson() => _$FoodDataToJson(this);

  @override
  String toString() => 'FoodData(title: $title)';
}

@JsonSerializable(includeIfNull: false)
class ImageData {
  String url;

  ImageData();

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);
  Map<String, dynamic> toJson() => _$ImageDataToJson(this);

  @override
  String toString() => 'ImageData(url: $url)';
}