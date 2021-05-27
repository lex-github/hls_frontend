// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleData _$ScheduleDataFromJson(Map<String, dynamic> json) {
  return ScheduleData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..asleepTime = toTime(json['yesterdayAsleepTime'])
    ..items = (json['items'] as List<dynamic>)
        ?.map((e) => ScheduleItemData.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ScheduleDataToJson(ScheduleData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'yesterdayAsleepTime': instance.asleepTime.toIso8601String(),
      'items': instance.items,
    };

ScheduleItemData _$ScheduleItemDataFromJson(Map<String, dynamic> json) {
  return ScheduleItemData()
    ..id = json['id'] as String
    ..type = ScheduleItemType.fromJsonValue(json['kind'])
    ..time = toTime(json['plannedAt']);
}

Map<String, dynamic> _$ScheduleItemDataToJson(ScheduleItemData instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kind', ScheduleItemType.toJsonValue(instance.type));
  val['plannedAt'] = instance.time.toIso8601String();
  return val;
}
