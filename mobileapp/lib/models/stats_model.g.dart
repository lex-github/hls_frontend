// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsData _$StatsDataFromJson(Map<String, dynamic> json) {
  return StatsData()
    // ..date = json['scheduleDate'] as String
    // ..asleepTime = json['yesterdayAsleepTime'] as String
    ..stepsQuantity = json['stepsQuantity'] as int
    ..sleepDuration = json['sleepDuration'] as int
    ..sleepReport = json['sleepReport'] as List<Object>
    ..activityRating =
    StatsActivityRating.fromJson(json['activityRating'] as Map<String, dynamic>)
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
      // 'scheduleDate': instance.date,
      // 'yesterdayAsleepTime': instance.asleepTime,
      'sleepDuration': instance.sleepDuration,
      'stepsQuantity': instance.stepsQuantity,
      'sleepReport': instance.sleepReport,
      // 'dailyRating': instance.daily,
      'scheduleEatings': instance.eatings,
    };

StatsActivityRating _$StatsActivityRatingFromJson(Map<String, dynamic> json) {
  return StatsActivityRating()
    ..activeLeisureRating = (json['activeLeisureRating'] as num).toDouble()
    ..motionRating = (json['motionRating'] as num).toDouble()
    ..trainingRating = (json['trainingRating'] as num).toDouble();
}

Map<String, dynamic> _$StatsActivityRatingToJson(StatsActivityRating instance) =>
    <String, dynamic>{
      'activeLeisureRating': instance.activeLeisureRating,
      'motionRating': instance.motionRating,
      'trainingRating': instance.trainingRating,
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
        ?.toList()
    ..scheduleItem = ScheduleItem.fromJson(json['scheduleItem'] as Map<String, dynamic>);


}

Map<String, dynamic> _$StatsScheduleComponentsEatingsToJson(StatsScheduleComponentsEatings instance) =>
    <String, dynamic>{
      'stats': instance.statsEatings,
      'scheduleItem': instance.scheduleItem,
    };


ScheduleStats _$ScheduleStatsFromJson(Map<String, dynamic> json) {
  return ScheduleStats()
    ..limit = (json['limit'] as num).toDouble()
    ..value = (json['value'] as num).toDouble()
    ..component = ComponentStats.fromJson(json['component'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ScheduleStatsToJson(ScheduleStats instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'value': instance.value,
      'component': instance.component,

    };

ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) {
  return ScheduleItem()
    ..plannedAt = (json['plannedAt'] as String)
    ..kind = (json['kind'] as String);
}

Map<String, dynamic> _$ScheduleItemToJson(ScheduleItem instance) =>
    <String, dynamic>{
      'plannedAt': instance.plannedAt,
      'kind': instance.kind,

    };

StatsPrimaryStats _$StatsPrimaryStatsFromJson(Map<String, dynamic> json) {
  return StatsPrimaryStats()
    ..energyValue = (json['energyValue'] as num).toDouble()
    ..nutrients = (json['nutrients'] as num).toDouble()
    ..water = (json['water'] as num).toDouble();
}

Map<String, dynamic> _$ComponentStatsToJson(ComponentStats instance) =>
    <String, dynamic>{
      'title': instance.title,

    };

ComponentStats _$ComponentStatsFromJson(Map<String, dynamic> json) {
  return ComponentStats()
    ..title = (json['title'] as String);
}

Map<String, dynamic> _$StatsPrimaryStatsToJson(StatsPrimaryStats instance) =>
    <String, dynamic>{
      'energyValue': instance.energyValue,
      'nutrients': instance.nutrients,
      'water': instance.water,
    };

StatsScheduleTrainings _$StatsScheduleTrainingsFromJson(Map<String, dynamic> json) {
  return StatsScheduleTrainings()
    // ..inputType = json['inputType'] as String
    ..inputValue = json['inputValue'] as double
    ..training =
    StatsTraining.fromJson(json['training'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleTrainingsToJson(StatsScheduleTrainings instance) =>
    <String, dynamic>{
      // 'inputType': instance.inputType,
      'inputValue': instance.inputValue,
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
    // ..inputType = json['inputType'] as String
    ..unit = json['unit'] as String
    // ..max = json['max'] as int
    // ..min = json['min'] as int
    // ..step = json['step'] as int
  ;
}

Map<String, dynamic> _$StatsInputDataToJson(StatsInputData instance) =>
    <String, dynamic>{
      'title': instance.title,
      // 'inputType': instance.inputType,
      'unit': instance.unit,
      // 'max': instance.max,
      // 'min': instance.min,
      // 'step': instance.step,

    };

StatsScheduleEatings _$StatsScheduleEatingsFromJson(Map<String, dynamic> json) {
  return StatsScheduleEatings()
    ..scheduleItem =
    StatsScheduleItem.fromJson(json['scheduleItem'] as Map<String, dynamic>)
    ..portion = (json['portion'] as num).toDouble()
    ..id = json['id'] as String
    ..scheduleFood =
    StatsScheduleFood.fromJson(json['food'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleEatingsToJson(StatsScheduleEatings instance) =>
    <String, dynamic>{
      'scheduleItem': instance.scheduleItem,
      'portion': instance.portion,
      'id': instance.id,
    };


StatsScheduleComponents _$StatsScheduleComponentsFromJson(Map<String, dynamic> json) {
  return StatsScheduleComponents()
    ..value = (json['value'] as num).toDouble()
    ..lowerLimit = (json['lowerLimit'] as num).toDouble()
    ..upperLimit = (json['upperLimit'] as num).toDouble()
    ..rating = (json['rating'] as num).toDouble()
    ..foodComponent =
    StatsScheduleFoodComponents.fromJson(json['foodComponent'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StatsScheduleComponentsToJson(StatsScheduleComponents instance) =>
    <String, dynamic>{
      'value': instance.value,
      'lowerLimit': instance.lowerLimit,
      'upperLimit': instance.upperLimit,
      'rating': instance.rating,
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
    ..kind = (json['kind'] as String).toString()
    ..plannedAt = (json['plannedAt'] as String).toString();
}

Map<String, dynamic> _$StatsScheduleItemToJson(StatsScheduleItem instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'plannedAt': instance.plannedAt,
    };

StatsScheduleFood _$StatsScheduleFoodFromJson(Map<String, dynamic> json) {
  return StatsScheduleFood()
    ..title = json['title'] as String
    // ..portion = (json['portion'] as num).toDouble()
    // ..structure = (json['structure'] as List<dynamic>)
    //   ?.map((e) => StatsScheduleStructure.fromJson(e as Map<String, dynamic>))
    //   ?.toList()
  ;
}

Map<String, dynamic> _$StatsScheduleFoodToJson(StatsScheduleFood instance) =>
    <String, dynamic>{
      'title': instance.title,
      // 'portion': instance.portion,
      // 'structure': instance.structure,
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