// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseData _$ExerciseDataFromJson(Map<String, dynamic> json) {
  return ExerciseData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..image = ImageData.fromJson(json['icon'] as Map<String, dynamic>)
    ..input = (json['inputData'] as List<dynamic>)
        ?.map((e) => ExerciseInputData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pulse = (json['pulseZones'] as List<dynamic>)
        ?.map((e) => ExercisePulseData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = ExerciseType.fromJsonValue(json['kind'])
    ..videoUrl = json['videoUrl'] as String
    ..imageUrl = json['imageUrl'] as String;
}

Map<String, dynamic> _$ExerciseDataToJson(ExerciseData instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'description': instance.description,
    'icon': instance.image,
    'inputData': instance.input,
    'pulseZones': instance.pulse,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kind', ExerciseType.toJsonValue(instance.type));
  val['videoUrl'] = instance.videoUrl;
  val['imageUrl'] = instance.imageUrl;
  return val;
}

ExerciseInputData _$ExerciseInputDataFromJson(Map<String, dynamic> json) {
  return ExerciseInputData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..unit = json['unit'] as String
    ..type = json['inputType'] as String
    ..min = json['min'] as int
    ..max = json['max'] as int
    ..step = json['step'] as int;
}

Map<String, dynamic> _$ExerciseInputDataToJson(ExerciseInputData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'unit': instance.unit,
      'inputType': instance.type,
      'min': instance.min,
      'max': instance.max,
      'step': instance.step,
    };

ExercisePulseData _$ExercisePulseDataFromJson(Map<String, dynamic> json) {
  return ExercisePulseData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['imageUrl'] as String
    ..color = toColor(json['color'])
    ..description = json['description'] as String
    ..heartRate = json['heartRate'] as String
    ..isRecommended = toBool(json['isRecommended']);
}

Map<String, dynamic> _$ExercisePulseDataToJson(ExercisePulseData instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'imageUrl': instance.imageUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('color', colorToString(instance.color));
  val['description'] = instance.description;
  val['heartRate'] = instance.heartRate;
  val['isRecommended'] = instance.isRecommended;
  return val;
}
