import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stats_model.g.dart';


@JsonSerializable(includeIfNull: false)
class StatsData extends GenericData {
  @JsonKey(name: 'scheduleDate')
  String date;
  @JsonKey(name: 'yesterdayAsleepTime')
  String asleepTime;
  @JsonKey(name: 'dailyRating')
  StatsDailyRating daily;
  // @JsonKey(name: 'scheduleEatings')
  // List <StatsScheduleEatings> eatings;


  StatsData();

  // getters
  // @override
  // String get imageUrl => image.url;
  // bool get canExpand => children.isNullOrEmpty && foods.length > 1;

  factory StatsData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$StatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatsDataToJson(this);



  // @override
  // String toString() => 'FoodCategoryData('
  //     '\n\tid: $id'
  //     '\n\ttitle: $title'
  //     '\n\tchildren: $children'
  //     '\n\tfoods: $foods'
  //     ')';
}

@JsonSerializable(includeIfNull: false)
class StatsDailyRating {
  @JsonKey(name: 'mode')
  double schedule;
  @JsonKey(name: 'activity')
  double exercise;
  @JsonKey(name: 'eating')
  double nutrition;


  StatsDailyRating();

  // getters

  factory StatsDailyRating.fromJson(Map<String, dynamic> json) =>
      _$StatsDailyRatingFromJson(json);
  Map<String, dynamic> toJson() => _$StatsDailyRatingToJson(this);

  @override
  String toString() => 'StatsDailyRating('
      '\n\tschedule: $schedule'
      '\n\texercise: $exercise'
      '\n\tnutrition: $nutrition'
      ')';
}

@JsonSerializable(includeIfNull: false)
class StatsScheduleEatings {
  @JsonKey(name: 'scheduleItem')
  StatsScheduleItem scheduleItem;



  StatsScheduleEatings();

  // getters


  factory StatsScheduleEatings.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleEatingsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleEatingsToJson(this);

  // @override
  // String toString() => 'StatsDailyRating('
  //     '\n\tschedule: $schedule'
  //     '\n\texercise: $exercise'
  //     '\n\tnutrition: $nutrition'
  //     ')';
}

@JsonSerializable(includeIfNull: false)
class StatsScheduleItem {
  @JsonKey(name: 'kind')
  String kind;



  StatsScheduleItem();

  // getters


  factory StatsScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleItemFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleItemToJson(this);

@override
String toString() => 'StatsScheduleItem('
    '\n\tkind: $kind'
    ')';
}