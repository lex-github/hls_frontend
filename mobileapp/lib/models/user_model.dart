import 'package:flutter/material.dart' hide Colors;
import 'package:hls/constants/strings.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/theme/styles.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/models/_generic_model.dart';

part 'user_model.g.dart';

@JsonSerializable(includeIfNull: false)
class UserData extends GenericData {
  @override
  @JsonKey(name: 'photoUrl')
  String imageUrl;
  String email;
  @JsonKey(name: 'phoneNumber')
  String phone;
  @JsonKey(name: 'data')
  UserDetailsData details;
  @JsonKey(name: 'chatBotDialogs')
  List<ChatDialogStatusData> dialogs;
  @JsonKey(name: 'dailyRating')
  UserDailyData daily;
  @JsonKey(name: 'weeklyTrainings')
  List<int> trainings;
  UserProgressData progress;

  UserData();

  // getters

  String get name => details?.name;
  DateTime get birthDate => details?.birthDate;
  int get age => details?.age;
  int get height => details?.height;
  int get weight => details?.weight;

  String get avatarUrl => imageUrl;
  ChatDialogStatusData get activeDialog =>
      dialogs.firstWhere((x) => x.status == ChatDialogStatus.ACTIVE,
          orElse: () => null);
  List<ChatDialogStatusData> get completedDialogs => dialogs
      .where((x) => x.status == ChatDialogStatus.FINISHED)
      .toList(growable: false);
  List<ChatDialogType> get dialogTypesToComplete =>
      ((List<ChatDialogType> completedTypes) => [
            for (final type in ChatDialogType.values)
              if (!completedTypes.contains(type)) type
          ])(completedDialogs.map((x) => x.type).toList(growable: false));

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() => 'UserData('
      '\n\tid: $id'
      '\n\tname: $name'
      '\n\tavatar: $avatarUrl'
      '\n\tdetails: $details'
      ')';
}

@JsonSerializable(includeIfNull: false)
class UserDetailsData {
  String name;
  int age;
  @JsonKey(fromJson: toDate)
  DateTime birthDate;
  @JsonKey(fromJson: GenderType.fromJsonValue, toJson: GenderType.toJsonValue)
  GenderType gender;
  int weight;
  int height;

  UserDetailsData();

  factory UserDetailsData.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailsDataToJson(this);

  @override
  String toString() => 'UserDetailsData('
      '\n\tname: $name'
      '\n\tage: $age'
      '\n\tbirthDate: $birthDate'
      '\n\tgender: $gender'
      '\n\tweight: $weight'
      '\n\theight: $height'
      ')';
}

@JsonSerializable(includeIfNull: false)
class UserDailyData {
  @JsonKey(name: 'mode')
  double schedule;
  @JsonKey(name: 'eating')
  double nutrition;
  @JsonKey(name: 'activity')
  double exercise;

  UserDailyData();

  // getters

  double get total => (schedule + nutrition + exercise) / 3;

  factory UserDailyData.fromJson(Map<String, dynamic> json) =>
      _$UserDailyDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDailyDataToJson(this);

  @override
  String toString() => 'UserDailyData('
      '\n\tschedule: $schedule'
      '\n\tnutrition: $nutrition'
      '\n\texercise: $exercise'
      ')';
}

@JsonSerializable(includeIfNull: false)
class UserProgressData {
  String goal;
  @JsonKey(name: 'microcycle')
  MicroCycleData microCycle;
  @JsonKey(name: 'macrocycle')
  MacroCycleData macroCycle;
  HealthData health;
  @JsonKey(name: 'agesDiagram')
  Map<int, double> healthHistory;

  UserProgressData();

  factory UserProgressData.fromJson(Map<String, dynamic> json) =>
      _$UserProgressDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressDataToJson(this);

  @override
  String toString() => 'UserProgressData('
      '\n\tgoal: $goal'
      ')';
}

@JsonSerializable(includeIfNull: false)
class MicroCycleData {
  String title;
  int number;
  int completedTrainings;
  int totalTrainings;

  MicroCycleData();

  factory MicroCycleData.fromJson(Map<String, dynamic> json) =>
      _$MicroCycleDataFromJson(json);
  Map<String, dynamic> toJson() => _$MicroCycleDataToJson(this);

  @override
  String toString() => 'MicroCycleData('
      '\n\ttitle: $title'
      ')';
}

@JsonSerializable(includeIfNull: false)
class MacroCycleData {
  String title;

  MacroCycleData();

  factory MacroCycleData.fromJson(Map<String, dynamic> json) =>
      _$MacroCycleDataFromJson(json);
  Map<String, dynamic> toJson() => _$MacroCycleDataToJson(this);

  @override
  String toString() => 'MacroCycleData('
      '\n\ttitle: $title'
      ')';
}

@JsonSerializable(includeIfNull: false)
class HealthData {
  @JsonKey(name: 'historyValues')
  List<HealthValueData> values;

  HealthIndexData adaptiveCapacity;
  HealthIndexData functionalityIndex;
  HealthIndexData queteletIndex;
  HealthIndexData robinsonIndex;
  @JsonKey(name: 'rufierProbe')
  HealthIndexData ruffierIndex;
  double hlsApplication;

  HealthData();

  factory HealthData.fromJson(Map<String, dynamic> json) =>
      _$HealthDataFromJson(json);
  Map<String, dynamic> toJson() => _$HealthDataToJson(this);

  @override
  String toString() => 'HealthData('
      //'\n\t: $'
      ')';
}

@JsonSerializable(includeIfNull: false)
class HealthValueData {
  @JsonKey(name: 'createdAt', fromJson: toDate)
  DateTime date;
  @JsonKey(name: 'avgRating')
  double average;
  @JsonKey(name: 'formulasRating')
  double calculated;
  @JsonKey(name: 'hlsApplication')
  double empirical;

  HealthValueData();

  factory HealthValueData.fromJson(Map<String, dynamic> json) =>
      _$HealthValueDataFromJson(json);
  Map<String, dynamic> toJson() => _$HealthValueDataToJson(this);

  @override
  String toString() => 'HealthValueData('
      '\n\taverage: $average'
      ')';
}

@JsonSerializable(includeIfNull: false)
class HealthIndexData {
  double percent;

  HealthIndexData();

  factory HealthIndexData.fromJson(Map<String, dynamic> json) =>
      _$HealthIndexDataFromJson(json);
  Map<String, dynamic> toJson() => _$HealthIndexDataToJson(this);

  @override
  String toString() => '${percent.round()}';
    // 'HealthIndexData('
    //   '\n\tpercent: $percent'
    //   ')';
}

class GenderType extends GenericEnum<String> {
  const GenderType({String value}) : super(value: value);

  static GenderType fromValue(value) => values
      .firstWhere((x) => x.value == value, orElse: () => GenderType.OTHER);

  static GenderType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = GenderType(value: '?');
  static const MALE = GenderType(value: 'M');
  static const FEMALE = GenderType(value: 'F');

  static const values = [MALE, FEMALE];

  @override
  String toString() => '$value';
}

class ActivityType extends GenericEnum<String> {
  final Color color;

  const ActivityType(
      {@required String value, @required this.color, @required String title})
      : super(value: value, title: title);

  static ActivityType fromValue(value) => values
      .firstWhere((x) => x.value == value, orElse: () => ActivityType.OTHER);

  static ActivityType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = ActivityType(value: null, color: null, title: null);
  static const SCHEDULE =
      ActivityType(value: 'MODE', color: Colors.schedule, title: scheduleTitle);
  static const NUTRITION = ActivityType(
      value: 'EATING', color: Colors.nutrition, title: nutritionTitle);
  static const EXERCISE = ActivityType(
      value: 'ACTIVITY', color: Colors.exercise, title: exerciseTitle);

  static const values = [SCHEDULE, NUTRITION, EXERCISE];

  @override
  String toString() => '$value';
}
