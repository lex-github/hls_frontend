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
  @JsonKey(name: 'scheduleEatings')
  List <StatsScheduleEatings> eatings;
  @JsonKey(name: 'consumedFoodComponents')
  List <StatsScheduleComponents> components;


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
class StatsScheduleEatings{
  @JsonKey(name: 'scheduleItem')
  StatsScheduleItem scheduleItem;
  @JsonKey(name: 'food')
  StatsScheduleFood scheduleFood;



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
class StatsScheduleComponents{
  @JsonKey(name: 'value')
  double value;
  @JsonKey(name: 'lowerLimit')
  double lowerLimit;
  @JsonKey(name: 'upperLimit')
  double upperLimit;
  @JsonKey(name: 'foodComponent')
  StatsScheduleFoodComponents foodComponent;



  StatsScheduleComponents();

  // getters




  factory StatsScheduleComponents.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleComponentsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleComponentsToJson(this);

  // @override
  // String toString() => 'StatsDailyRating('
  //     '\n\tschedule: $schedule'
  //     '\n\texercise: $exercise'
  //     '\n\tnutrition: $nutrition'
  //     ')';
}


@JsonSerializable(includeIfNull: false)
class StatsScheduleFoodComponents {
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'unit')
  String unit;
  @JsonKey(name: 'section')
  String section;


  StatsScheduleFoodComponents();

  // getters

  factory StatsScheduleFoodComponents.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleFoodComponentsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleFoodComponentsToJson(this);

  @override
  String toString() => 'StatsScheduleFoodComponents('
      '\n\ttitle: $title'
      '\n\tunit: $unit'
      '\n\tsection: $section'
      ')';
}

@JsonSerializable(includeIfNull: false)
class StatsScheduleFood {
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'portion')
  double portion;
  @JsonKey(name: 'structure')
  List <StatsScheduleStructure> structure;




  StatsScheduleFood();

  // getters


  factory StatsScheduleFood.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleFoodFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleFoodToJson(this);

  @override
  String toString() => 'StatsScheduleFood('
      '\n\ttitle: $title'
      '\n\tportion: $portion'
      ')';
}


@JsonSerializable(includeIfNull: false)
class StatsScheduleStructure{
  @JsonKey(name: 'key')
  String key;
  @JsonKey(name: 'quantity')
  double quantity;
  @JsonKey(name: 'section')
  String section;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'unit')
  String unit;



  StatsScheduleStructure();

  // getters




  factory StatsScheduleStructure.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleStructureFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleStructureToJson(this);

@override
String toString() => 'StatsScheduleStructure('
    '\n\tkey: $key'
    '\n\tquantity: $quantity'
    '\n\tsection: $section'
    '\n\ttitle: $title'
    '\n\tunit: $unit'
    ')';
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

