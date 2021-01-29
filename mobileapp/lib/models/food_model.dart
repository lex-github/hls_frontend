import 'package:hls/helpers/convert.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/_generic_model.dart';

part 'food_model.g.dart';

@JsonSerializable(includeIfNull: false)
class FoodData extends GenericData {
  @JsonKey(name: 'icon')
  ImageData image;
  @JsonKey(name: 'foodCategory')
  FoodCategoryData category;
  List<FoodSectionData> structure;

  FoodData();

  FoodSectionData getByKey(String key) =>
      structure?.firstWhere((x) => x.key == key, orElse: () => null);

  // getters
  @override
  String get imageUrl => image?.url;

  // getters
  FoodSectionData get water => getByKey('water');
  FoodSectionData get carbs => getByKey('carbohydrates');
  FoodSectionData get fats => getByKey('fats');
  FoodSectionData get proteins => getByKey('proteins');

  Map<String, List<FoodSectionData>> get sections => structure?.fold(
      {},
      (sections, x) =>
          x.section.isNullOrEmpty ? sections : sections.setList(x.section, x));

  factory FoodData.fromJson(Map<String, dynamic> json) =>
      _$FoodDataFromJson(json);
  Map<String, dynamic> toJson() => _$FoodDataToJson(this);

  @override
  String toString() => 'FoodData(title: $title)';
}

@JsonSerializable(includeIfNull: false)
class FoodSectionData extends GenericData {
  String key;
  @JsonKey(fromJson: toDouble)
  double quantity;
  String section;
  String unit;

  FoodSectionData();

  factory FoodSectionData.fromJson(Map<String, dynamic> json) =>
      _$FoodSectionDataFromJson(json);
  Map<String, dynamic> toJson() => _$FoodSectionDataToJson(this);

  @override
  String toString() => 'FoodSectionData(title: $title)';
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
