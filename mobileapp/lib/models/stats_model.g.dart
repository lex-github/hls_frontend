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
    ..components = (json['consumedFoodComponents'] as List<dynamic>)
        ?.map((e) => StatsScheduleComponents.fromJson(e as Map<String, dynamic>))
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