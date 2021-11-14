// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsData _$StatsDataFromJson(Map<String, dynamic> json) {
  return StatsData()
    ..date = json['scheduleDate'] as String
    ..asleepTime = json['yesterdayAsleepTime'] as String
    ..daily =
        StatsDailyRating.fromJson(json['dailyRating'] as Map<String, dynamic>)
    ..eatings = (json['scheduleEatings'] as List<dynamic>)
        ?.map((e) => StatsScheduleEatings.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..foodRating =
    StatsFoodRating.fromJson(json['foodRating'] as Map<String, dynamic>)
    ..scheduleTrainings = (json['scheduleTrainings'] as List<dynamic>)
        ?.map((e) => StatsScheduleTrainings.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StatsDataToJson(StatsData instance) => <String, dynamic>{
      'scheduleDate': instance.date,
      'yesterdayAsleepTime': instance.asleepTime,
      'dailyRating': instance.daily,
      'scheduleEatings': instance.eatings,
    };

StatsDailyRating _$StatsDailyRatingFromJson(Map<String, dynamic> json) {
  return StatsDailyRating()
    ..schedule = (json['mode'] as num).toDouble()
    ..exercise = (json['activity'] as num).toDouble()
    ..nutrition = (json['eating'] as num).toDouble();
}

Map<String, dynamic> _$StatsDailyRatingToJson(StatsDailyRating instance) =>
    <String, dynamic>{
      'mode': instance.schedule,
      'activity': instance.exercise,
      'eating': instance.nutrition,
    };

StatsFoodRating _$StatsFoodRatingFromJson(Map<String, dynamic> json) {
  return StatsFoodRating()
    ..components = (json['consumedComponents'] as List<dynamic>)
        ?.map((e) => StatsScheduleComponents.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..componentsPerEating = (json['consumedComponentsPerEating'] as List<dynamic>)
        ?.map((e) => StatsScheduleComponentsEatings.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..primaryStats = StatsPrimaryStats.fromJson(json['primaryStats'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsFoodRatingToJson(StatsFoodRating instance) =>
    <String, dynamic>{
      'components': instance.components,
      'consumedComponentsPerEating': instance.componentsPerEating,
      'primaryStats': instance.primaryStats,
    };

StatsScheduleComponentsEatings _$StatsScheduleComponentsEatingsFromJson(Map<String, dynamic> json) {
  return StatsScheduleComponentsEatings()
    ..statsEatings = (json['stats'] as List<dynamic>)
        ?.map((e) => ScheduleStats.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StatsScheduleComponentsEatingsToJson(StatsScheduleComponentsEatings instance) =>
    <String, dynamic>{
      'stats': instance.statsEatings,

    };


ScheduleStats _$ScheduleStatsFromJson(Map<String, dynamic> json) {
  return ScheduleStats()
    ..limit = (json['limit'] as num).toDouble()
    ..value = (json['value'] as num).toDouble();
}

Map<String, dynamic> _$ScheduleStatsToJson(ScheduleStats instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'value': instance.value,

    };

StatsPrimaryStats _$StatsPrimaryStatsFromJson(Map<String, dynamic> json) {
  return StatsPrimaryStats()
    ..energyValue = (json['energyValue'] as num).toDouble()
    ..nutrients = (json['nutrients'] as num).toDouble()
    ..water = (json['water'] as num).toDouble();
}

Map<String, dynamic> _$StatsPrimaryStatsToJson(StatsPrimaryStats instance) =>
    <String, dynamic>{
      'energyValue': instance.energyValue,
      'nutrients': instance.nutrients,
      'water': instance.water,
    };

StatsScheduleTrainings _$StatsScheduleTrainingsFromJson(Map<String, dynamic> json) {
  return StatsScheduleTrainings()
    ..training =
    StatsTraining.fromJson(json['training'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleTrainingsToJson(StatsScheduleTrainings instance) =>
    <String, dynamic>{
      'training': instance.training,

    };


StatsTraining _$StatsTrainingFromJson(Map<String, dynamic> json) {
  return StatsTraining()
    ..title = json['title'] as String
    ..trainingCategory =
    StatsTrainingCategory.fromJson(json['trainingCategory'] as Map<String, dynamic>)
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

StatsTrainingCategory _$StatsTrainingCategoryFromJson(Map<String, dynamic> json) {
  return StatsTrainingCategory()
    ..title = json['title'] as String;
}

Map<String, dynamic> _$StatsTrainingCategoryToJson(StatsTrainingCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

StatsInputData _$StatsInputDataFromJson(Map<String, dynamic> json) {
  return StatsInputData()
    ..title = json['title'] as String
    ..inputType = json['inputType'] as String
    ..unit = json['unit'] as String
    ..max = json['max'] as int
    ..min = json['min'] as int
    ..step = json['step'] as int
  ;
}

Map<String, dynamic> _$StatsInputDataToJson(StatsInputData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'inputType': instance.inputType,
      'unit': instance.unit,
      'max': instance.max,
      'min': instance.min,
      'step': instance.step,

    };

StatsScheduleEatings _$StatsScheduleEatingsFromJson(Map<String, dynamic> json) {
  return StatsScheduleEatings()
    ..scheduleItem =
    StatsScheduleItem.fromJson(json['scheduleItem'] as Map<String, dynamic>)
    ..scheduleFood =
    StatsScheduleFood.fromJson(json['food'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleEatingsToJson(StatsScheduleEatings instance) =>
    <String, dynamic>{
      'scheduleItem': instance.scheduleItem,

    };


StatsScheduleComponents _$StatsScheduleComponentsFromJson(Map<String, dynamic> json) {
  return StatsScheduleComponents()
    ..value = (json['value'] as num).toDouble()
    ..lowerLimit = (json['lowerLimit'] as num).toDouble()
    ..upperLimit = (json['upperLimit'] as num).toDouble()
    ..foodComponent =
    StatsScheduleFoodComponents.fromJson(json['foodComponent'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleComponentsToJson(StatsScheduleComponents instance) =>
    <String, dynamic>{
      'value': instance.value,
      'lowerLimit': instance.lowerLimit,
      'upperLimit': instance.upperLimit,
      'foodComponent': instance.foodComponent,

    };


StatsScheduleFoodComponents _$StatsScheduleFoodComponentsFromJson(Map<String, dynamic> json) {
  return StatsScheduleFoodComponents()
    ..title = json['title'] as String
    ..unit = json['unit'] as String
    ..section = json['section'] as String;
}

Map<String, dynamic> _$StatsScheduleFoodComponentsToJson(StatsScheduleFoodComponents instance) =>
    <String, dynamic>{

    };

StatsScheduleItem _$StatsScheduleItemFromJson(Map<String, dynamic> json) {
  return StatsScheduleItem()
    ..kind = (json['kind'] as String).toString();
}

Map<String, dynamic> _$StatsScheduleItemToJson(StatsScheduleItem instance) =>
    <String, dynamic>{
      'kind': instance.kind,
    };

StatsScheduleFood _$StatsScheduleFoodFromJson(Map<String, dynamic> json) {
  return StatsScheduleFood()
    ..title = json['title'] as String
    ..portion = (json['portion'] as num).toDouble()
    ..structure = (json['structure'] as List<dynamic>)
      ?.map((e) => StatsScheduleStructure.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$StatsScheduleFoodToJson(StatsScheduleFood instance) =>
    <String, dynamic>{
      'title': instance.title,
      'portion': instance.portion,
      'structure': instance.structure,
    };


StatsScheduleStructure _$StatsScheduleStructureFromJson(Map<String, dynamic> json) {
  return StatsScheduleStructure()
    ..key = json['key'] as String
    ..quantity = (json['quantity'] as num).toDouble()
    ..section = json['section'] as String
    ..title = json['title'] as String
    ..unit = json['unit'] as String;

}

Map<String, dynamic> _$StatsScheduleStructureToJson(StatsScheduleStructure instance) =>
    <String, dynamic>{
      'key': instance.key,
      'quantity': instance.quantity,
      'section': instance.section,
      'title': instance.title,
      'unit': instance.unit,
    };