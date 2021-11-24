// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarData _$CalendarDataFromJson(Map<String, dynamic> json) {
  return CalendarData()
    ..date = json['scheduleDate'] as String
    ..daily =
    DailyRating.fromJson(json['dailyRating'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CalendarDataToJson(CalendarData instance) => <String, dynamic>{
  'scheduleDate': instance.date,
  'dailyRating': instance.daily,
};

DailyRating _$DailyRatingFromJson(Map<String, dynamic> json) {
  return DailyRating()
    ..schedule = (json['mode'] as num).toDouble()
    ..exercise = (json['activity'] as num).toDouble()
    ..nutrition = (json['eating'] as num).toDouble();
}

Map<String, dynamic> _$DailyRatingToJson(DailyRating instance) =>
    <String, dynamic>{
      'mode': instance.schedule,
      'activity': instance.exercise,
      'eating': instance.nutrition,
    };
