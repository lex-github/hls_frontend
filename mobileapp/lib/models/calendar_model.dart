import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar_model.g.dart';


@JsonSerializable(includeIfNull: false)
class CalendarData extends GenericData {
  @JsonKey(name: 'scheduleDate')
  String date;
  @JsonKey(name: 'dailyRating')
  DailyRating daily;


  CalendarData();

  // getters
  // @override
  // String get imageUrl => image.url;
  // bool get canExpand => children.isNullOrEmpty && foods.length > 1;

  factory CalendarData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$CalendarDataFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarDataToJson(this);

}

@JsonSerializable(includeIfNull: false)
class DailyRating {
  @JsonKey(name: 'mode')
  double schedule;
  @JsonKey(name: 'activity')
  double exercise;
  @JsonKey(name: 'eating')
  double nutrition;


  DailyRating();

  // getters

  factory DailyRating.fromJson(Map<String, dynamic> json) =>
      _$DailyRatingFromJson(json);
  Map<String, dynamic> toJson() => _$DailyRatingToJson(this);

  @override
  String toString() => 'DailyRating('
      '\n\tschedule: $schedule'
      '\n\texercise: $exercise'
      '\n\tnutrition: $nutrition'
      ')';
}
