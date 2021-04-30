import 'dart:math';

import 'package:flutter/painting.dart' hide Size;
import 'package:hls/theme/styles.dart';

const hoursInDay = 12;
const minutesInHour = 60;
const degreesInCircle = 360;

const degreesInHour = degreesInCircle / hoursInDay;
const degreesInRadian = degreesInCircle / (2 * pi);

const minutesInDay = hoursInDay * minutesInHour;
const minutesInRadian = minutesInDay / (2 * pi);
const minutesInDegree = minutesInDay / degreesInCircle;
final sixOclock = DateTime(0, 0, 0, 6);
final twelveOclock = DateTime(0, 0, 0, 12);

final diameter = Size.screenWidth / 1.4;
final innerDiameter = .6 * diameter;
final iconBorder = 4 * Size.border;
final iconSize = 1.1 * Size.iconHuge;
final iconSmallSize = .3 * iconSize;

extension DateTimeExtension on DateTime {
  double get angle => this == null
      ? 0
      : hour == 0 && minute == 0
          ? 2 * pi
          : (hour * 60 + minute) / minutesInRadian % (2 * pi);
  bool get isNightOuter => this == null ? false : hour > 18 || hour <= 6;
  bool get isNightInner => this == null ? false : !isNightOuter;
  bool get isDayOuter => this == null ? false : hour > 12 || hour == 0;
  bool get isDayInner => this == null ? false : !isDayOuter;

  bool isAfterOrEqual(DateTime date) =>
      this.isAfter(date) || this.isAtSameMomentAs(date);
}

class RadialCoordinate {
  double degrees;
  double radius;

  RadialCoordinate.fromOffset(Offset offset) {
    // length from center to touch
    final center = diameter / 2;
    radius = sqrt(pow(offset.dx - center, 2) + pow(offset.dy - center, 2));

    // degrees of touch
    final angle = angleFromOffset(offset);
    degrees = ((.5 * pi - angle) * 180 / pi);
    if (degrees < 0) degrees = degreesInCircle + degrees;
  }

  RadialCoordinate.fromTime(DateTime time) {
    final hour = time?.hour ?? 0;
    final minute = time?.minute ?? 0;
    radius = 0;
    degrees = (hour * minutesInHour + minute) / minutesInDegree;
  }

  double get angle => (degrees % degreesInCircle) * pi / 180;
  Offset get cartesian => Offset(radius * sin(angle), radius * cos(angle));
  Offset get offset => Offset(
      cartesian.dx + diameter / 2, diameter - (cartesian.dy + diameter / 2));
  DateTime get time {
    // time in minutes
    final minutes = (minutesInDegree * degrees).round();
    final time = DateTime(0, 0, 0).add(Duration(minutes: minutes));

    return time;
  }

  static double angleFromOffset(Offset offset, {double width, double height}) {
    width ??= diameter;
    height ??= diameter;

    final y = height - offset.dy - height / 2;
    final x = offset.dx - width / 2;

    //print('ScheduleScreen.angleFromOffset ($x, $y)');

    final angle = atan(y / x);
    if (x > 0 && y < 0) return angle + 2 * pi;
    if (x < 0) return angle + pi;

    return angle;
  }
}
