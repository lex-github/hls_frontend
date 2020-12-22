// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData()
    ..id = toInt(json['id'])
    ..title = json['title'] as String
    ..imageUri = json['imageUri'] as String
    ..name = json['name'] as String
    ..email = json['email'] as String
    ..phone = json['phoneNumber'] as String
    ..details = json['data'] == null
        ? null
        : UserDetailsData.fromJson(json['data'] as Map<String, dynamic>)
    ..chatDialogsCompleted =
        DialogType.fromJsonList(json['finishedDialogs'] as List);
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
  writeNotNull('imageUri', instance.imageUri);
  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('phoneNumber', instance.phone);
  writeNotNull('data', instance.details);
  writeNotNull(
      'finishedDialogs', DialogType.toJsonList(instance.chatDialogsCompleted));
  return val;
}

UserDetailsData _$UserDetailsDataFromJson(Map<String, dynamic> json) {
  return UserDetailsData()
    ..age = json['age'] as int
    ..gender = GenderType.fromJsonValue(json['gender'])
    ..weight = json['weight'] as int;
}

Map<String, dynamic> _$UserDetailsDataToJson(UserDetailsData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('age', instance.age);
  writeNotNull('gender', GenderType.toJsonValue(instance.gender));
  writeNotNull('weight', instance.weight);
  return val;
}
