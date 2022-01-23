// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsMode _$StatsModeFromJson(Map<String, dynamic> json) {
  return StatsMode()
    ..sleepDuration = json['sleepDuration'] as int
    ..sleepReport = json['sleepReport'] as List<Object>
    ;
}

Map<String, dynamic> _$StatsModeToJson(StatsMode instance) => <String, dynamic>{
  'sleepDuration': instance.sleepDuration,
  'sleepReport': instance.sleepReport,
};
