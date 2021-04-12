// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUrl = json['photoUrl'] as String
    ..email = json['email'] as String
    ..phone = json['phoneNumber'] as String
    ..details = UserDetailsData.fromJson(json['data'] as Map<String, dynamic>)
    ..dialogs = (json['chatBotDialogs'] as List<dynamic>)
        ?.map((e) => ChatDialogStatusData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..daily =
        UserDailyData.fromJson(json['dailyRating'] as Map<String, dynamic>)
    ..trainings =
        (json['weeklyTrainings'] as List<dynamic>)?.map((e) => e as int)?.toList()
    ..progress =
        UserProgressData.fromJson(json['progress'] as Map<String, dynamic>)
    ..schedule =
        ScheduleData.fromJson(json['todaySchedule'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'photoUrl': instance.imageUrl,
      'email': instance.email,
      'phoneNumber': instance.phone,
      'data': instance.details,
      'chatBotDialogs': instance.dialogs,
      'dailyRating': instance.daily,
      'weeklyTrainings': instance.trainings,
      'progress': instance.progress,
      'todaySchedule': instance.schedule,
    };

UserDetailsData _$UserDetailsDataFromJson(Map<String, dynamic> json) {
  return UserDetailsData()
    ..name = json['name'] as String
    ..age = json['age'] as int
    ..birthDate = toDate(json['birthDate'])
    ..gender = GenderType.fromJsonValue(json['gender'])
    ..weight = json['weight'] as int
    ..height = json['height'] as int;
}

Map<String, dynamic> _$UserDetailsDataToJson(UserDetailsData instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'age': instance.age,
    'birthDate': instance.birthDate.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('gender', GenderType.toJsonValue(instance.gender));
  val['weight'] = instance.weight;
  val['height'] = instance.height;
  return val;
}

UserDailyData _$UserDailyDataFromJson(Map<String, dynamic> json) {
  return UserDailyData()
    ..schedule = (json['mode'] as num).toDouble()
    ..nutrition = (json['eating'] as num).toDouble()
    ..exercise = (json['activity'] as num).toDouble();
}

Map<String, dynamic> _$UserDailyDataToJson(UserDailyData instance) =>
    <String, dynamic>{
      'mode': instance.schedule,
      'eating': instance.nutrition,
      'activity': instance.exercise,
    };

UserProgressData _$UserProgressDataFromJson(Map<String, dynamic> json) {
  return UserProgressData()
    ..goal = json['goal'] as String
    ..microCycle =
        MicroCycleData.fromJson(json['microcycle'] as Map<String, dynamic>)
    ..macroCycle =
        MacroCycleData.fromJson(json['macrocycle'] as Map<String, dynamic>)
    ..health = HealthData.fromJson(json['health'] as Map<String, dynamic>)
    ..healthHistory = (json['agesDiagram'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
    );
}

Map<String, dynamic> _$UserProgressDataToJson(UserProgressData instance) =>
    <String, dynamic>{
      'goal': instance.goal,
      'microcycle': instance.microCycle,
      'macrocycle': instance.macroCycle,
      'health': instance.health,
      'agesDiagram':
          instance.healthHistory?.map((k, e) => MapEntry(k.toString(), e)),
    };

MicroCycleData _$MicroCycleDataFromJson(Map<String, dynamic> json) {
  return MicroCycleData()
    ..title = json['title'] as String
    ..number = json['number'] as int
    ..completedTrainings = json['completedTrainings'] as int
    ..totalTrainings = json['totalTrainings'] as int;
}

Map<String, dynamic> _$MicroCycleDataToJson(MicroCycleData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'number': instance.number,
      'completedTrainings': instance.completedTrainings,
      'totalTrainings': instance.totalTrainings,
    };

MacroCycleData _$MacroCycleDataFromJson(Map<String, dynamic> json) {
  return MacroCycleData()..title = json['title'] as String;
}

Map<String, dynamic> _$MacroCycleDataToJson(MacroCycleData instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

HealthData _$HealthDataFromJson(Map<String, dynamic> json) {
  return HealthData()
    ..values = (json['historyValues'] as List<dynamic>)
        ?.map((e) => HealthValueData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..adaptiveCapacity = HealthIndexData.fromJson(
        json['adaptiveCapacity'] as Map<String, dynamic>)
    ..functionalityIndex = HealthIndexData.fromJson(
        json['functionalityIndex'] as Map<String, dynamic>)
    ..queteletIndex =
        HealthIndexData.fromJson(json['queteletIndex'] as Map<String, dynamic>)
    ..robinsonIndex =
        HealthIndexData.fromJson(json['robinsonIndex'] as Map<String, dynamic>)
    ..ruffierIndex =
        HealthIndexData.fromJson(json['rufierProbe'] as Map<String, dynamic>)
    ..hlsApplication = (json['hlsApplication'] as num).toDouble()
    ..debugInfo = json['debugInfo'] as Map<String, dynamic>;
}

Map<String, dynamic> _$HealthDataToJson(HealthData instance) =>
    <String, dynamic>{
      'historyValues': instance.values,
      'adaptiveCapacity': instance.adaptiveCapacity,
      'functionalityIndex': instance.functionalityIndex,
      'queteletIndex': instance.queteletIndex,
      'robinsonIndex': instance.robinsonIndex,
      'rufierProbe': instance.ruffierIndex,
      'hlsApplication': instance.hlsApplication,
      'debugInfo': instance.debugInfo,
    };

HealthValueData _$HealthValueDataFromJson(Map<String, dynamic> json) {
  return HealthValueData()
    ..date = toDate(json['createdAt'])
    ..average = (json['avgRating'] as num)?.toDouble()
    ..calculated = (json['formulasRating'] as num)?.toDouble()
    ..empirical = (json['hlsApplication'] as num)?.toDouble();
}

Map<String, dynamic> _$HealthValueDataToJson(HealthValueData instance) =>
    <String, dynamic>{
      'createdAt': instance.date.toIso8601String(),
      'avgRating': instance.average,
      'formulasRating': instance.calculated,
      'hlsApplication': instance.empirical,
    };

HealthIndexData _$HealthIndexDataFromJson(Map<String, dynamic> json) {
  return HealthIndexData()..percent = (json['percent'] as num).toDouble();
}

Map<String, dynamic> _$HealthIndexDataToJson(HealthIndexData instance) =>
    <String, dynamic>{
      'percent': instance.percent,
    };
