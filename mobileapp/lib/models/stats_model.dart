import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stats_model.g.dart';


@JsonSerializable(includeIfNull: false)
class StatsData extends GenericData {
  // @JsonKey(name: 'scheduleDate')
  // String date;
  @JsonKey(name: 'yesterdayAsleepTime')
  String asleepTime;
  @JsonKey(name: 'sleepDuration')
  int sleepDuration;
  @JsonKey(name: 'sleepReport')
  List<Object> sleepReport;
  @JsonKey(name: 'activityRating')
  StatsActivityRating activityRating;
  @JsonKey(name: 'foodRating')
  StatsFoodRating foodRating;
  @JsonKey(name: 'scheduleEatings')
  List <StatsScheduleEatings> eatings;
  @JsonKey(name: 'scheduleTrainings')
  List <StatsScheduleTrainings> scheduleTrainings;



  StatsData();

  // getters
  // @override
  // String get imageUrl => image.url;
  // bool get canExpand => children.isNullOrEmpty && foods.length > 1;

  factory StatsData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$StatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatsDataToJson(this);



  @override
  String toString() => 'asleepTime('
      '\n\tasleepTime: $asleepTime'
      '\n\tsleepReport: $sleepReport'
      ')';
}

@JsonSerializable(includeIfNull: false)
class StatsActivityRating {
  @JsonKey(name: 'activeLeisureRating')
  double activeLeisureRating;
  @JsonKey(name: 'motionRating')
  double motionRating;
  @JsonKey(name: 'trainingRating')
  double trainingRating;


  StatsActivityRating();

  // getters

  factory StatsActivityRating.fromJson(Map<String, dynamic> json) =>
      _$StatsActivityRatingFromJson(json);
  Map<String, dynamic> toJson() => _$StatsActivityRatingToJson(this);

  @override
  String toString() => 'StatsActivityRating('
      '\n\tactiveLeisureRating: $activeLeisureRating'
      '\n\tmotionRating: $motionRating'
      '\n\ttrainingRating: $trainingRating'
      ')';
}

@JsonSerializable(includeIfNull: false)
class StatsFoodRating {
  @JsonKey(name: 'consumedComponents')
  List <StatsScheduleComponents> components;
  @JsonKey(name: 'consumedComponentsPerEating')
  List <StatsScheduleComponentsEatings> componentsPerEating;
  @JsonKey(name: 'primaryStats')
  StatsPrimaryStats primaryStats;


  StatsFoodRating();

  // getters

  factory StatsFoodRating.fromJson(Map<String, dynamic> json) =>
      _$StatsFoodRatingFromJson(json);
  Map<String, dynamic> toJson() => _$StatsFoodRatingToJson(this);

  // @override
  // String toString() => 'StatsFoodDailyRating('
  //     '\n\tschedule: $schedule'
  //     '\n\texercise: $exercise'
  //     '\n\tnutrition: $nutrition'
  //     ')';
}


@JsonSerializable(includeIfNull: false)
class StatsScheduleComponentsEatings{
  @JsonKey(name: 'stats')
  List <ScheduleStats> statsEatings;
  @JsonKey(name: 'eatingKind')
  String eatingKind;



  StatsScheduleComponentsEatings();

  // getters




  factory StatsScheduleComponentsEatings.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleComponentsEatingsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleComponentsEatingsToJson(this);

// @override
// String toString() => 'StatsDailyRating('
//     '\n\tschedule: $schedule'
//     '\n\texercise: $exercise'
//     '\n\tnutrition: $nutrition'
//     ')';
}

@JsonSerializable(includeIfNull: false)
class ScheduleStats{
  @JsonKey(name: 'limit')
  double limit;
  @JsonKey(name: 'value')
  double value;
  @JsonKey(name: 'component')
  ComponentStats component;



  ScheduleStats();

  // getters




  factory ScheduleStats.fromJson(Map<String, dynamic> json) =>
      _$ScheduleStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleStatsToJson(this);

@override
String toString() => 'ScheduleStats('
    '\n\tlimit: $limit'
    '\n\tvalue: $value'
    ')';
}

@JsonSerializable(includeIfNull: false)
class StatsPrimaryStats {
  @JsonKey(name: 'energyValue')
  double energyValue;
  @JsonKey(name: 'nutrients')
  double nutrients;
  @JsonKey(name: 'water')
  double water;


  StatsPrimaryStats();

  // getters

  factory StatsPrimaryStats.fromJson(Map<String, dynamic> json) =>
      _$StatsPrimaryStatsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsPrimaryStatsToJson(this);

  @override
  String toString() => 'StatsPrimaryStats('
      '\n\tenergyValue: $energyValue'
      '\n\tnutrients: $nutrients'
      '\n\twater: $water'
      ')';
}

@JsonSerializable(includeIfNull: false)
class ComponentStats {
  @JsonKey(name: 'title')
  String title;



  ComponentStats();

  // getters

  factory ComponentStats.fromJson(Map<String, dynamic> json) =>
      _$ComponentStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ComponentStatsToJson(this);

  @override
  String toString() => 'StatsPrimaryStats('
      '\n\ttitle: $title'
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
class StatsScheduleTrainings{
  @JsonKey(name: 'training')
  StatsTraining training;
  @JsonKey(name: 'inputType')
  String inputType;
  @JsonKey(name: 'inputValue')
  double inputValue;



  StatsScheduleTrainings();

  // getters




  factory StatsScheduleTrainings.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleTrainingsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleTrainingsToJson(this);

  @override
  String toString() => 'StatsScheduleTrainings('
      '\n\tinputValue: $inputValue'
      ')';
}


@JsonSerializable(includeIfNull: false)
class StatsTraining {
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'trainingCategory')
  StatsTrainingCategory trainingCategory;
  @JsonKey(name: 'inputData')
  List <StatsInputData> inputData;



  StatsTraining();

  // getters

  factory StatsTraining.fromJson(Map<String, dynamic> json) =>
      _$StatsTrainingFromJson(json);
  Map<String, dynamic> toJson() => _$StatsTrainingToJson(this);

  @override
  String toString() => 'StatsTraining('
      '\n\ttitle: $title'
      ')';
}


@JsonSerializable(includeIfNull: false)
class StatsInputData{
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'inputType')
  String inputType;
  @JsonKey(name: 'unit')
  String unit;
  @JsonKey(name: 'max')
  int max;
  @JsonKey(name: 'min')
  int min;
  @JsonKey(name: 'step')
  int step;



  StatsInputData();

  // getters




  factory StatsInputData.fromJson(Map<String, dynamic> json) =>
      _$StatsInputDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatsInputDataToJson(this);

@override
String toString() => 'StatsDailyRating('
    '\n\ttitle: $title'
    '\n\tinputType: $inputType'
    ')';
}


@JsonSerializable(includeIfNull: false)
class StatsTrainingCategory {
  @JsonKey(name: 'title')
  String title;

  StatsTrainingCategory();

  // getters

  factory StatsTrainingCategory.fromJson(Map<String, dynamic> json) =>
      _$StatsTrainingCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$StatsTrainingCategoryToJson(this);

  @override
  String toString() => 'StatsTrainingCategory('
      '\n\ttitle: $title'
      ')';
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
  @JsonKey(name: 'plannedAt')
  String plannedAt;



  StatsScheduleItem();

  // getters


  factory StatsScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$StatsScheduleItemFromJson(json);
  Map<String, dynamic> toJson() => _$StatsScheduleItemToJson(this);

@override
String toString() => 'StatsScheduleItem('
    '\n\tkind: $kind'
    '\n\tplannedAt: $plannedAt'
    ')';
}

