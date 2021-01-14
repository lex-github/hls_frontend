import 'package:hls/helpers/convert.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/helpers/enums.dart';

part '_generic_model.g.dart';

@JsonSerializable(includeIfNull: false)
class GenericData extends GenericEnum {
  @JsonKey(fromJson: toInt)
  int id;
  String title;
  String imageUrl;

  bool get isValid => id != null;

  GenericData();

  factory GenericData.fromJson(Map<String, dynamic> json) =>
    _$GenericDataFromJson(json);
  Map<String, dynamic> toJson() => _$GenericDataToJson(this);

  @override
  String toString() => 'GenericData(id: $id, title: $title)';

  @override
  bool operator ==(Object other) => other is GenericData && other.id == id;

  @override
  int get hashCode => id;
}