import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' hide Size;
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
  List<ScheduleItemData> items;

  ScheduleData();

  factory ScheduleData.fromJson(Map<String, dynamic> json) => json.isNullOrEmpty ? null :
      _$ScheduleDataFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDataToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ScheduleItemData extends GenericData {
  @JsonKey(
      name: 'kind',
      fromJson: ScheduleItemType.fromJsonValue,
      toJson: ScheduleItemType.toJsonValue)
  ScheduleItemType type;
  @JsonKey(name: 'plannedAt', fromJson: toTime)
  DateTime time;

  ScheduleItemData();

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

  Color get color => type.type.color;
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

class ScheduleItemType extends GenericEnum<String> {
  final ActivityType type;

  const ScheduleItemType({@required String value, @required this.type})
      : super(value: value);

  static ScheduleItemType fromValue(value) => values.firstWhere(
      (x) => x.value.toLowerCase() == value.toString().toLowerCase(),
      orElse: () => ScheduleItemType.OTHER);

  static ScheduleItemType fromJsonValue(value) => fromValue(value);
  static int toJsonValue(item) => item?.value;

  static const OTHER = ScheduleItemType(value: '?', type: ActivityType.OTHER);
  static const WAKEUP =
      ScheduleItemType(value: 'WAKE_UP', type: ActivityType.SCHEDULE);
  static const ASLEEP =
      ScheduleItemType(value: 'SLEEP', type: ActivityType.SCHEDULE);
  static const BREAKFAST =
      ScheduleItemType(value: 'BREAKFAST', type: ActivityType.NUTRITION);
  static const LUNCH =
      ScheduleItemType(value: 'LUNCH', type: ActivityType.NUTRITION);
  static const DINNER =
      ScheduleItemType(value: 'DINNER', type: ActivityType.NUTRITION);
  static const SNACK =
      ScheduleItemType(value: 'SNACK', type: ActivityType.NUTRITION);
  static const ADDITIONAL =
      ScheduleItemType(value: 'ADDITIONAL_FOOD', type: ActivityType.NUTRITION);
  static const EXERCISE =
      ScheduleItemType(value: 'TRAINING', type: ActivityType.EXERCISE);

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
