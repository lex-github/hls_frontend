import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' hide Size;
import 'package:hls/constants/strings.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/theme/styles.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/models/_generic_model.dart';

part 'schedule_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ScheduleData extends GenericData {
  @JsonKey(name: 'yesterdayAsleepTime', fromJson: toTime)
  DateTime asleepTime;
  // @JsonKey(name: 'scheduleDate')
  ScheduleDate scheduleDate;
  List<ScheduleItemData> items;

  ScheduleData();

  factory ScheduleData.fromJson(Map<String, dynamic> json) =>
      json.isNullOrEmpty ? null : _$ScheduleDataFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDataToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ScheduleDate {
  String title;

  ScheduleDate();

  // factory ScheduleDate.fromJson(Map<String, dynamic> json) =>
  //     _$ScheduleDateFromJson(json);
  // Map<String, dynamic> toJson() => _$ScheduleDateToJson(this);

  @override
  String toString() => 'MacroCycleData('
      '\n\ttitle: $title'
      ')';
}

@JsonSerializable(includeIfNull: false)
class ScheduleItemData {
  String id;
  @JsonKey(
      name: 'kind',
      fromJson: ScheduleItemType.fromJsonValue,
      toJson: ScheduleItemType.toJsonValue)
  ScheduleItemType type;
  @JsonKey(name: 'plannedAt', fromJson: toTime)
  DateTime time;

  ScheduleItemData();

  //@override
  String get title => type.title;

  Offset get offset {
    final coordinate = RadialCoordinate.fromTime(time);
    final radius = time.isDayInner ? innerDiameter / 2 : diameter / 2;

    // constraint
    coordinate.radius = radius - (isSmall ? .0 * iconSmallSize : Size.fontTiny);
    // coordinate.degrees =
    //     (coordinate.degrees / degreesInHour).round() * degreesInHour;
    final offset = coordinate.offset;

    // factoring in indicator size
    final size = isSmall ? iconSmallSize : iconSize;
    final resultOffset = Offset(offset.dx - (size + iconBorder) / 2,
        offset.dy - (size + iconBorder) / 2);

    return resultOffset;
  }

  Color get color => type.color ?? type.type.color;
  bool get isSmall =>
      type != ScheduleItemType.WAKEUP && type != ScheduleItemType.ASLEEP;

  factory ScheduleItemData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemDataFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleItemDataToJson(this);

  @override
  String toString() => 'ScheduleItemData('
      '\n\tid: $id '
      '\n\ttype: $type'
      '\n\ttime: $time'
      '\n\toffset: $offset'
      ')';
}


// @JsonSerializable(includeIfNull: false)
// class ScheduleDate {
//   @JsonKey(
//       name: 'kind',
//       fromJson: ScheduleItemType.fromJsonValue,
//       toJson: ScheduleItemType.toJsonValue)
//   ScheduleItemType type;
//   @JsonKey(name: 'plannedAt', fromJson: toTime)
//   DateTime time;
//
//   ScheduleDate();
//
//   //@override
//   String get title => type.title;
//
//   Offset get offset {
//     final coordinate = RadialCoordinate.fromTime(time);
//     final radius = time.isDayInner ? innerDiameter / 2 : diameter / 2;
//
//     // constraint
//     coordinate.radius = radius - (isSmall ? .0 * iconSmallSize : Size.fontTiny);
//     // coordinate.degrees =
//     //     (coordinate.degrees / degreesInHour).round() * degreesInHour;
//     final offset = coordinate.offset;
//
//     // factoring in indicator size
//     final size = isSmall ? iconSmallSize : iconSize;
//     final resultOffset = Offset(offset.dx - (size + iconBorder) / 2,
//         offset.dy - (size + iconBorder) / 2);
//
//     return resultOffset;
//   }
//
//   Color get color => type.color ?? type.type.color;
//   bool get isSmall =>
//       type != ScheduleItemType.WAKEUP && type != ScheduleItemType.ASLEEP;
//
//   factory ScheduleItemData.fromJson(Map<String, dynamic> json) =>
//       _$ScheduleItemDataFromJson(json);
//   Map<String, dynamic> toJson() => _$ScheduleItemDataToJson(this);
//
//   @override
//   String toString() => 'ScheduleItemData('
//       '\n\tid: $id '
//       '\n\ttype: $type'
//       '\n\ttime: $time'
//       '\n\toffset: $offset'
//       ')';
// }

class ScheduleItemType extends GenericEnum<String> {
  final ActivityType type;
  final Color color;

  const ScheduleItemType(
      {@required String value,
      @required this.type,
      @required String title,
      @required this.color})
      : super(value: value, title: title);

  static ScheduleItemType fromValue(value) => values.firstWhere(
      (x) => x.value.toLowerCase() == value.toString().toLowerCase(),
      orElse: () => ScheduleItemType.OTHER);

  static ScheduleItemType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = ScheduleItemType(
      value: '?', type: ActivityType.OTHER, title: null, color: null);
  static const WAKEUP = ScheduleItemType(
      value: 'WAKE_UP',
      type: ActivityType.SCHEDULE,
      title: scheduleDayWakeupLabel,
      color: Colors.scheduleDay);
  static const ASLEEP = ScheduleItemType(
      value: 'SLEEP',
      type: ActivityType.SCHEDULE,
      title: scheduleDayAsleepLabel,
      color: Colors.scheduleNight);
  static const BREAKFAST = ScheduleItemType(
      value: 'BREAKFAST',
      type: ActivityType.NUTRITION,
      title: scheduleDayBreakfastLabel,
      color: Colors.scheduleMainFood);
  static const LUNCH = ScheduleItemType(
      value: 'LUNCH',
      type: ActivityType.NUTRITION,
      title: scheduleDayLunchLabel,
      color: Colors.scheduleMainFood);
  static const DINNER = ScheduleItemType(
      value: 'DINNER',
      type: ActivityType.NUTRITION,
      title: scheduleDayDinnerLabel,
      color: Colors.scheduleMainFood);
  static const SNACK = ScheduleItemType(
      value: 'SNACK',
      type: ActivityType.NUTRITION,
      title: scheduleDaySnackLabel,
      color: Colors.scheduleAdditionalFood);
  static const ADDITIONAL = ScheduleItemType(
      value: 'ADDITIONAL_FOOD',
      type: ActivityType.NUTRITION,
      title: scheduleDayProteinLabel,
      color: Colors.scheduleAdditionalFood);
  static const EXERCISE = ScheduleItemType(
      value: 'TRAINING',
      type: ActivityType.EXERCISE,
      title: scheduleDayExerciseLabel,
      color: null);

  static const values = [
    WAKEUP,
    ASLEEP,
    BREAKFAST,
    LUNCH,
    DINNER,
    SNACK,
    ADDITIONAL,
    EXERCISE
  ];

  @override
  String toString() => '$value';
}
