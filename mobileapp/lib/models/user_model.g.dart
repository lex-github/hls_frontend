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
    ..daily = json['dailyRating'] == null
        ? null
        : UserDailyData.fromJson(json['dailyRating'] as Map<String, dynamic>)
    ..dialogs = (json['chatBotDialogs'] as List)
        ?.map((e) => e == null
            ? null
            : ChatDialogStatusData.fromJson(e as Map<String, dynamic>))
        ?.toList();
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
  writeNotNull('dailyRating', instance.daily);
  writeNotNull('chatBotDialogs', instance.dialogs);
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
