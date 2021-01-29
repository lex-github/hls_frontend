import 'package:hls/helpers/convert.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_filter_model.g.dart';

@JsonSerializable(includeIfNull: false)
class FoodFilterData extends GenericData {
  String key;
  FilterValueData values;
  String section;

  FoodFilterData();

  int get min => toInt(values.min);
  int get max => toInt(values.max);

  factory FoodFilterData.fromJson(Map<String, dynamic> json) =>
      _$FoodFilterDataFromJson(json);
  Map<String, dynamic> toJson() => _$FoodFilterDataToJson(this);

  @override
  String toString() => 'FoodFilterData(key: $key)';
}

@JsonSerializable(includeIfNull: false)
class FilterValueData {
  @JsonKey(fromJson: toDouble)
  double min;
  @JsonKey(fromJson: toDouble)
  double max;

  FilterValueData();

  factory FilterValueData.fromJson(Map<String, dynamic> json) =>
    _$FilterValueDataFromJson(json);
  Map<String, dynamic> toJson() => _$FilterValueDataToJson(this);

  @override
  String toString() => 'FilterValueData(min: $min, max: $max)';
}