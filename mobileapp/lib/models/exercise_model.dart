import 'package:hls/helpers/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/models/_generic_model.dart';

part 'exercise_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ExerciseData extends GenericData {
  @JsonKey(name: 'icon')
  ImageData image;
  @JsonKey(name: 'inputData')
  List<ExerciseInputData> input;
  @JsonKey(
      name: 'kind',
      fromJson: ExerciseType.fromJsonValue,
      toJson: ExerciseType.toJsonValue)
  ExerciseType type;
  String videoUrl;


  ExerciseData();

  // getters
  @override
  String get imageUrl => image?.url;

  List<GenericEnum> get values => [
        for (final i in input)
          GenericEnum<String>(title: i.title, value: i.type),
      ];

  List<GenericEnum> valuesFor(String type) {
    final input = this
        .input
        .firstWhere((input) => input.type == type, orElse: () => null);
    if (input == null) return null;

    return [
      for (int i = input.min; i <= input.max; i++)
        GenericEnum(title: "$i", value: i)
    ];
  }

  factory ExerciseData.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseDataToJson(this);

  @override
  String toString() => 'ExerciseData('
    '\n\ttitle: $title'
    '\n\ttype: $type'
    ')';
}

@JsonSerializable(includeIfNull: false)
class ExerciseInputData extends GenericData {
  @JsonKey(name: 'inputType')
  String type;
  int min;
  int max;

  ExerciseInputData();

  factory ExerciseInputData.fromJson(Map<String, dynamic> json) =>
      _$ExerciseInputDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseInputDataToJson(this);

  @override
  String toString() => 'ExerciseInputData(title: $title)';
}

class ExerciseType extends GenericEnum<String> {
  const ExerciseType({String value}) : super(value: value);

  static ExerciseType fromValue(value) => values
      .firstWhere((x) => x.value == value, orElse: () => ExerciseType.OTHER);

  static ExerciseType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = ExerciseType(value: '?');
  static const REALTIME = ExerciseType(value: 'REALTIME');
  static const HISTORY = ExerciseType(value: 'HISTORY');

  static const values = [REALTIME, HISTORY];

  @override
  String toString() => '$value';
}

// class ExerciseInputType extends GenericEnum<String> {
//   const ExerciseInputType({String value}) : super(value: value);
//
//   static ExerciseInputType fromValue(value) =>
//       values.firstWhere((x) => x.value == value,
//           orElse: () => ExerciseInputType.OTHER);
//
//   static ExerciseInputType fromJsonValue(value) => fromValue(value);
//   static int toJsonValue(item) => item?.value;
//
//   static const OTHER = ExerciseInputType(value: '?');
//   static const DURATION = ExerciseInputType(value: 'DURATION');
//   static const QUANTITY = ExerciseInputType(value: 'QUANTITY');
//   static const DISTANCE = ExerciseInputType(value: 'DISTANCE');
//
//   static const values = [DURATION, QUANTITY, DISTANCE];
//
//   @override
//   String toString() => '$value';
// }
