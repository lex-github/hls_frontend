// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_trainings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsTrainings _$StatsTrainingsFromJson(Map<String, dynamic> json) {
  return StatsTrainings()
    ..stepsQuantity = json['stepsQuantity'] as int
    ..activityRating = StatsActivityRating.fromJson(
        json['activityRating'] as Map<String, dynamic>)
    ..scheduleTrainings = (json['scheduleTrainings'] as List<dynamic>)
        ?.map((e) => StatsScheduleTrainings.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StatsTrainingsToJson(StatsTrainings instance) =>
    <String, dynamic>{
      'stepsQuantity': instance.stepsQuantity,
    };

StatsActivityRating _$StatsActivityRatingFromJson(Map<String, dynamic> json) {
  return StatsActivityRating()
    ..activeLeisureRating = (json['activeLeisureRating'] as num).toDouble()
    ..motionRating = (json['motionRating'] as num).toDouble()
    ..trainingRating = (json['trainingRating'] as num).toDouble();
}

Map<String, dynamic> _$StatsActivityRatingToJson(
        StatsActivityRating instance) =>
    <String, dynamic>{
      'activeLeisureRating': instance.activeLeisureRating,
      'motionRating': instance.motionRating,
      'trainingRating': instance.trainingRating,
    };


StatsScheduleTrainings _$StatsScheduleTrainingsFromJson(
    Map<String, dynamic> json) {
  return StatsScheduleTrainings()
    // ..inputType = json['inputType'] as String
    ..inputValue = json['inputValue'] as double
    ..training =
        StatsTraining.fromJson(json['training'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleTrainingsToJson(
        StatsScheduleTrainings instance) =>
    <String, dynamic>{
      // 'inputType': instance.inputType,
      'inputValue': instance.inputValue,
      'training': instance.training,
    };

StatsTraining _$StatsTrainingFromJson(Map<String, dynamic> json) {
  return StatsTraining()
    ..title = json['title'] as String
    ..trainingCategory = StatsTrainingCategory.fromJson(
        json['trainingCategory'] as Map<String, dynamic>)
    ..inputData = (json['inputData'] as List<dynamic>)
        ?.map((e) => StatsInputData.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StatsTrainingToJson(StatsTraining instance) =>
    <String, dynamic>{
      'title': instance.title,
      'trainingCategory': instance.trainingCategory,
      'inputData': instance.inputData,
    };

StatsTrainingCategory _$StatsTrainingCategoryFromJson(
    Map<String, dynamic> json) {
  return StatsTrainingCategory()..title = json['title'] as String;
}

Map<String, dynamic> _$StatsTrainingCategoryToJson(
        StatsTrainingCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

StatsInputData _$StatsInputDataFromJson(Map<String, dynamic> json) {
  return StatsInputData()
        ..title = json['title'] as String
        ..unit = json['unit'] as String
      ;
}

Map<String, dynamic> _$StatsInputDataToJson(StatsInputData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'unit': instance.unit,
    };
