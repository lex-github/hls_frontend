// import 'package:hls/helpers/null_awareness.dart';
// import 'package:hls/models/_generic_model.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// part 'stats_trainings_model.g.dart';
//
//
// @JsonSerializable(includeIfNull: false)
// class StatsTrainings extends GenericData {
//
//   @JsonKey(name: 'activityRating')
//   StatsActivityRating activityRating;
//   @JsonKey(name: 'stepsQuantity')
//   int stepsQuantity;
//   @JsonKey(name: 'scheduleTrainings')
//   List <StatsScheduleTrainings> scheduleTrainings;
//
//   StatsTrainings();
//
//   // getters
//   // @override
//   // String get imageUrl => image.url;
//   // bool get canExpand => children.isNullOrEmpty && foods.length > 1;
//
//   factory StatsTrainings.fromJson(Map<String, dynamic> json) =>
//       json.isNullOrEmpty ? null : _$StatsTrainingsFromJson(json);
//   Map<String, dynamic> toJson() => _$StatsTrainingsToJson(this);
//
//
//
//   @override
//   String toString() => 'asleepTime('
//   // '\n\tasleepTime: $asleepTime'
//       '\n\tstepsQuantity: $stepsQuantity'
//       ')';
// }
//
// @JsonSerializable(includeIfNull: false)
// class StatsActivityRating {
//   @JsonKey(name: 'activeLeisureRating')
//   double activeLeisureRating;
//   @JsonKey(name: 'motionRating')
//   double motionRating;
//   @JsonKey(name: 'trainingRating')
//   double trainingRating;
//
//
//   StatsActivityRating();
//
//   // getters
//
//   factory StatsActivityRating.fromJson(Map<String, dynamic> json) =>
//       _$StatsActivityRatingFromJson(json);
//   Map<String, dynamic> toJson() => _$StatsActivityRatingToJson(this);
//
//   @override
//   String toString() => 'StatsActivityRating('
//       '\n\tactiveLeisureRating: $activeLeisureRating'
//       '\n\tmotionRating: $motionRating'
//       '\n\ttrainingRating: $trainingRating'
//       ')';
// }
//
//
//
// @JsonSerializable(includeIfNull: false)
// class StatsScheduleTrainings{
//   @JsonKey(name: 'training')
//   StatsTraining training;
//   // @JsonKey(name: 'inputType')
//   // String inputType;
//   @JsonKey(name: 'inputValue')
//   double inputValue;
//
//
//
//   StatsScheduleTrainings();
//
//   // getters
//
//
//
//
//   factory StatsScheduleTrainings.fromJson(Map<String, dynamic> json) =>
//       _$StatsScheduleTrainingsFromJson(json);
//   Map<String, dynamic> toJson() => _$StatsScheduleTrainingsToJson(this);
//
//   @override
//   String toString() => 'StatsScheduleTrainings('
//       '\n\tinputValue: $inputValue'
//       ')';
// }
//
//
// @JsonSerializable(includeIfNull: false)
// class StatsTraining {
//   @JsonKey(name: 'title')
//   String title;
//   @JsonKey(name: 'trainingCategory')
//   StatsTrainingCategory trainingCategory;
//   @JsonKey(name: 'inputData')
//   List <StatsInputData> inputData;
//
//
//
//   StatsTraining();
//
//   // getters
//
//   factory StatsTraining.fromJson(Map<String, dynamic> json) =>
//       _$StatsTrainingFromJson(json);
//   Map<String, dynamic> toJson() => _$StatsTrainingToJson(this);
//
//   @override
//   String toString() => 'StatsTraining('
//       '\n\ttitle: $title'
//       ')';
// }
//
//
// @JsonSerializable(includeIfNull: false)
// class StatsInputData{
//   @JsonKey(name: 'title')
//   String title;
//   @JsonKey(name: 'unit')
//   String unit;
//
//
//   StatsInputData();
//
//   // getters
//
//
//
//
//   factory StatsInputData.fromJson(Map<String, dynamic> json) =>
//       _$StatsInputDataFromJson(json);
//   Map<String, dynamic> toJson() => _$StatsInputDataToJson(this);
//
//   @override
//   String toString() => 'StatsDailyRating('
//       '\n\ttitle: $title'
//       ')';
// }
//
//
// @JsonSerializable(includeIfNull: false)
// class StatsTrainingCategory {
//   @JsonKey(name: 'title')
//   String title;
//
//   StatsTrainingCategory();
//
//   // getters
//
//   factory StatsTrainingCategory.fromJson(Map<String, dynamic> json) =>
//       _$StatsTrainingCategoryFromJson(json);
//   Map<String, dynamic> toJson() => _$StatsTrainingCategoryToJson(this);
//
//   @override
//   String toString() => 'StatsTrainingCategory('
//       '\n\ttitle: $title'
//       ')';
// }
//
