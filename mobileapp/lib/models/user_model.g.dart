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
    ..details = json['data'] == null
        ? null
        : UserDetailsData.fromJson(json['data'] as Map<String, dynamic>)
    ..dialogs = (json['chatBotDialogs'] as List)
        ?.map((e) => e == null
            ? null
            : ChatDialogStatusData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..daily = json['dailyRating'] == null
        ? null
        : UserDailyData.fromJson(json['dailyRating'] as Map<String, dynamic>)
    ..trainings =
        (json['weeklyTrainings'] as List)?.map((e) => e as int)?.toList()
    ..progress = json['progress'] == null
        ? null
        : UserProgressData.fromJson(json['progress'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserDataToJson(UserData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('photoUrl', instance.imageUrl);
  writeNotNull('email', instance.email);
  writeNotNull('phoneNumber', instance.phone);
  writeNotNull('data', instance.details);
  writeNotNull('chatBotDialogs', instance.dialogs);
  writeNotNull('dailyRating', instance.daily);
  writeNotNull('weeklyTrainings', instance.trainings);
  writeNotNull('progress', instance.progress);
  return val;
}

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
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('age', instance.age);
  writeNotNull('birthDate', instance.birthDate?.toIso8601String());
  writeNotNull('gender', GenderType.toJsonValue(instance.gender));
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  return val;
}

UserDailyData _$UserDailyDataFromJson(Map<String, dynamic> json) {
  return UserDailyData()
    ..schedule = (json['mode'] as num)?.toDouble()
    ..nutrition = (json['eating'] as num)?.toDouble()
    ..exercise = (json['activity'] as num)?.toDouble();
}

Map<String, dynamic> _$UserDailyDataToJson(UserDailyData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mode', instance.schedule);
  writeNotNull('eating', instance.nutrition);
  writeNotNull('activity', instance.exercise);
  return val;
}

UserProgressData _$UserProgressDataFromJson(Map<String, dynamic> json) {
  return UserProgressData()
    ..goal = json['goal'] as String
    ..microCycle = json['microcycle'] == null
        ? null
        : MicroCycleData.fromJson(json['microcycle'] as Map<String, dynamic>)
    ..macroCycle = json['macrocycle'] == null
        ? null
        : MacroCycleData.fromJson(json['macrocycle'] as Map<String, dynamic>)
    ..health = json['health'] == null
        ? null
        : HealthData.fromJson(json['health'] as Map<String, dynamic>)
    ..healthHistory = (json['agesDiagram'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), (e as num)?.toDouble()),
    );
}

Map<String, dynamic> _$UserProgressDataToJson(UserProgressData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('goal', instance.goal);
  writeNotNull('microcycle', instance.microCycle);
  writeNotNull('macrocycle', instance.macroCycle);
  writeNotNull('health', instance.health);
  writeNotNull('agesDiagram',
      instance.healthHistory?.map((k, e) => MapEntry(k.toString(), e)));
  return val;
}

MicroCycleData _$MicroCycleDataFromJson(Map<String, dynamic> json) {
  return MicroCycleData()
    ..title = json['title'] as String
    ..number = json['number'] as int
    ..completedTrainings = json['completedTrainings'] as int
    ..totalTrainings = json['totalTrainings'] as int;
}

Map<String, dynamic> _$MicroCycleDataToJson(MicroCycleData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('number', instance.number);
  writeNotNull('completedTrainings', instance.completedTrainings);
  writeNotNull('totalTrainings', instance.totalTrainings);
  return val;
}

MacroCycleData _$MacroCycleDataFromJson(Map<String, dynamic> json) {
  return MacroCycleData()..title = json['title'] as String;
}

Map<String, dynamic> _$MacroCycleDataToJson(MacroCycleData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  return val;
}

HealthData _$HealthDataFromJson(Map<String, dynamic> json) {
  return HealthData()
    ..values = (json['historyValues'] as List)
        ?.map((e) => e == null
            ? null
            : HealthValueData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..adaptiveCapacity = json['adaptiveCapacity'] == null
        ? null
        : HealthIndexData.fromJson(
            json['adaptiveCapacity'] as Map<String, dynamic>)
    ..functionalityIndex = json['functionalityIndex'] == null
        ? null
        : HealthIndexData.fromJson(
            json['functionalityIndex'] as Map<String, dynamic>)
    ..queteletIndex = json['queteletIndex'] == null
        ? null
        : HealthIndexData.fromJson(
            json['queteletIndex'] as Map<String, dynamic>)
    ..robinsonIndex = json['robinsonIndex'] == null
        ? null
        : HealthIndexData.fromJson(
            json['robinsonIndex'] as Map<String, dynamic>)
    ..ruffierIndex = json['rufierProbe'] == null
        ? null
        : HealthIndexData.fromJson(json['rufierProbe'] as Map<String, dynamic>)
    ..hlsApplication = (json['hlsApplication'] as num)?.toDouble();
}

Map<String, dynamic> _$HealthDataToJson(HealthData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('historyValues', instance.values);
  writeNotNull('adaptiveCapacity', instance.adaptiveCapacity);
  writeNotNull('functionalityIndex', instance.functionalityIndex);
  writeNotNull('queteletIndex', instance.queteletIndex);
  writeNotNull('robinsonIndex', instance.robinsonIndex);
  writeNotNull('rufierProbe', instance.ruffierIndex);
  writeNotNull('hlsApplication', instance.hlsApplication);
  return val;
}

HealthValueData _$HealthValueDataFromJson(Map<String, dynamic> json) {
  return HealthValueData()
    ..date = toDate(json['createdAt'])
    ..average = (json['avgRating'] as num)?.toDouble()
    ..calculated = (json['formulasRating'] as num)?.toDouble()
    ..empirical = (json['hlsApplication'] as num)?.toDouble();
}

Map<String, dynamic> _$HealthValueDataToJson(HealthValueData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.date?.toIso8601String());
  writeNotNull('avgRating', instance.average);
  writeNotNull('formulasRating', instance.calculated);
  writeNotNull('hlsApplication', instance.empirical);
  return val;
}

HealthIndexData _$HealthIndexDataFromJson(Map<String, dynamic> json) {
  return HealthIndexData()..percent = (json['percent'] as num)?.toDouble();
}

Map<String, dynamic> _$HealthIndexDataToJson(HealthIndexData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('percent', instance.percent);
  return val;
}
