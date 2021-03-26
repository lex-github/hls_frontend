import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/common_dialog.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/nutrition_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/theme/styles.dart';

const minutesInDay = 12 * 60;
const minutesInRadian = minutesInDay / (2 * pi);
const minutesInDegree = minutesInDay / 360;
final sixOclock = DateTime(0, 0, 0, 6);

final diameter = Size.screenWidth / 1.4;
final innerDiameter = .6 * diameter;
final iconBorder = Size.border * 2.25;
final iconSize = Size.iconBig;

class ScheduleScreen extends GetView<NutritionController> {
  // handlers

  // builders

  @override
  Widget build(_) => DefaultTabController(
      length: 2,
      child: Screen(
          height: Size.bar + 2 * Size.verticalMedium + Size.font,
          padding: Padding.zero,
          shouldShowDrawer: true,
          title: scheduleScreenTitle,
          trailing: Clickable(
              onPressed: () => showConfirm(title: developmentText),
              child: Image(title: 'icons/question')),
          bottom: TabBar(
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: Size.horizontal),
              indicatorColor: Colors.primary,
              labelPadding: Padding.medium,
              labelStyle: TextStyle.primary,
              labelColor: Colors.primaryText,
              unselectedLabelStyle: TextStyle.primary,
              //unselectedLabelColor: Colors.secondaryText,
              tabs: [Text('Ночь'), Text('День')]),
          child: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            GetBuilder(init: NightController(), builder: (_) => NightTab()),
            DayTab()
          ])));
}

class NightTab extends GetView<NightController> with CommonDialog {
  Offset get asleepOffset => controller.asleepOffset;
  DateTime get asleepTime => controller.asleepTime;
  Offset get wakeupOffset => controller.wakeupOffset;
  DateTime get wakeupTime => controller.wakeupTime;

  String _formatDate(String date) {
    if (date == '00') return '24';

    //if (date == '18') return '6';

    if (date.startsWith('0')) return date.substring(1);

    return date;
  }

  // handlers

  // _onTap(BuildContext context, TapUpDetails details) async {
  //   // global to local coordinates of touch
  //   final RenderBox box = context.findRenderObject();
  //   final offset = box.globalToLocal(details.globalPosition);
  //
  //   // length from center to touch
  //   final center = diameter / 2;
  //   final radius =
  //       sqrt(pow(offset.dx - center, 2) + pow(offset.dy - center, 2));
  //
  //   // degrees of touch
  //   final angle = angleFromOffset(offset);
  //   double degrees = ((.5 * pi - angle) * 180 / pi);
  //   if (degrees < 0) degrees = 360 + degrees;
  //
  //   // time in minutes
  //   final totalMinutes = 12 * 60;
  //   final minutesInDegree = totalMinutes / 360;
  //   final minutes = (minutesInDegree * degrees).round();
  //   Duration duration = Duration(minutes: minutes);
  //
  //   // closeness to circles
  //   final absOuterCloseness = (center - radius).abs();
  //   final absInnerCloseness = (.6 * center - radius).abs();
  //
  //   // pm adjust
  //   if (absInnerCloseness < absOuterCloseness) {
  //     if (degrees < 180) {
  //       duration = Duration(hours: 12, minutes: duration.inMinutes);
  //     }
  //   } else if (degrees > 180)
  //     duration = Duration(hours: 12, minutes: duration.inMinutes);
  //
  //   print('NightTab._onTapDown duration: $duration');
  //
  //   // final result = await showSwitch(
  //   //     title: scheduleSwitchTitle,
  //   //     left: Icon(Icons.nightlight_round),
  //   //     right: Icon(Icons.wb_twighlight));
  // }

  _onDrag(BuildContext context, DragUpdateDetails details) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition));
  }

  _onTap(BuildContext context, TapUpDetails details) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition));
  }

  // builders

  Widget _buildIndicator(Offset offset, DateTime time, Color color,
          [bool isNight = true]) =>
      AnimatedPositioned(
          left: offset.dx,
          top: offset.dy,
          //duration: defaultAnimationDuration,
          duration: 20.milliseconds,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.background,
                  border: Border.all(color: color, width: iconBorder),
                  borderRadius: BorderRadius.circular(iconSize / 2)),
              width: iconSize,
              height: iconSize,
              // child: Center(
              //     child: TextPrimary(dateToString(date: time, output: dateTime),
              //         size: .9 * Size.fontTiny))
              child: Center(
                  child: time == null
                      ? Icon(isNight ? Icons.nightlight_round : Icons.wb_sunny,
                          color: color, size: .75 * iconSize)
                      : TextPrimary(_formatDate(
                          dateToString(date: time, output: 'H'))))));

  @override
  Widget build(_) => SingleChildScrollView(
      padding: Padding.content,
      child: Column(children: [
        TextPrimary(scheduleNightText,
            weight: FontWeight.w400, align: TextAlign.center),
        VerticalBigSpace(),
        Builder(
            builder: (context) => GestureDetector(
                onTapUp: (details) => _onTap(context, details),
                onPanUpdate: (details) => _onDrag(context, details),
                child: Stack(
                    alignment: Alignment.center,
                    overflow: Overflow.visible,
                    children: [
                      CustomPaint(
                          size: M.Size(diameter, diameter),
                          painter: CircleDialPainter(
                              values: controller.outerValues,
                              color: Colors.black)),
                      CustomPaint(
                          size: M.Size(innerDiameter, innerDiameter),
                          painter: CircleDialPainter(
                              values: controller.innerValues,
                              offset: pi,
                              //- 2 * pi / controller.innerValues.length,
                              fontSize: .8 * Size.fontTiny,
                              color: Colors.black)),
                      Obx(() => asleepTime.isOuter || wakeupTime.isOuter
                          ? CustomPaint(
                              size: M.Size(diameter, diameter),
                              painter: SectorPainter(
                                //from: asleepTime.value, to: wakeupTime.value
                                width: iconBorder,
                                color: Colors.scheduleNight,
                                startAngle: (asleepTime.isOuter
                                        ? asleepTime.angle
                                        : pi) -
                                    pi / 2,
                                endAngle: (2 * pi -
                                        (asleepTime.isInner
                                            ? pi
                                            : asleepTime.angle) +
                                        (wakeupTime.isInner
                                            ? pi
                                            : wakeupTime.angle)) %
                                    (2 * pi),
                              ))
                          : asleepTime.isInner &&
                                  wakeupTime.isInner &&
                                  wakeupTime.isBefore(asleepTime)
                              ? CustomPaint(
                                  size: M.Size(diameter, diameter),
                                  painter: SectorPainter(
                                    width: iconBorder,
                                    color: Colors.scheduleNight,
                                    endAngle: 2 * pi,
                                  ))
                              : Nothing()),
                      Obx(() => wakeupTime.isInner || asleepTime.isInner
                          ? CustomPaint(
                              size: M.Size(innerDiameter, innerDiameter),
                              painter: SectorPainter(
                                width: iconBorder,
                                color: Colors.scheduleNight,
                                startAngle: asleepTime.isInner
                                    ? asleepTime.angle - pi / 2
                                    : pi / 2,
                                endAngle: (asleepTime.isOuter
                                        ? wakeupTime.angle - pi
                                        : -asleepTime.angle +
                                            (wakeupTime.isInner
                                                ? wakeupTime.angle
                                                : pi)) %
                                    (2 * pi),
                              ))
                          : wakeupTime.isOuter &&
                                  asleepTime.isOuter &&
                                  //wakeupTime.isBefore(asleepTime) &&
                                  ((asleepTime.isBefore(sixOclock) &&
                                          (wakeupTime.isAfter(sixOclock) ||
                                              wakeupTime
                                                  .isBefore(asleepTime))) ||
                                      wakeupTime.isAfter(sixOclock) &&
                                          (asleepTime.isAfter(wakeupTime)))
                              ? CustomPaint(
                                  size: M.Size(innerDiameter, innerDiameter),
                                  painter: SectorPainter(
                                    width: iconBorder,
                                    color: Colors.scheduleNight,
                                    endAngle: 2 * pi,
                                  ))
                              : Nothing()),
                      Obx(() => controller.shouldDisplayVerticalLine
                          ? Positioned(
                              bottom: .0,
                              child: Container(
                                  color: Colors.scheduleNight,
                                  width: iconBorder,
                                  height: (diameter - innerDiameter) / 2))
                          : Nothing()),
                      Obx(() => _buildIndicator(
                          asleepOffset, asleepTime, Colors.scheduleNight)),
                      Obx(() => _buildIndicator(
                          wakeupOffset, wakeupTime, Colors.scheduleDay, false))
                    ])))
      ]));
}

class DayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.scheduleDay);
  }
}

class NightController extends GetxController {
  final innerValues = [for (int i = 7; i <= 18; i++) i];
  final outerValues = [
    for (int i = 1; i <= 6; i++) i,
    for (int i = 19; i <= 24; i++) i
  ];

  final _asleepOffset = Offset.zero.obs;
  final _asleepTime = Rx<DateTime>(null);
  final _wakeupOffset = Offset(diameter - iconSize - 2 * iconBorder, 0).obs;
  final _wakeupTime = Rx<DateTime>(null);

  Offset get asleepOffset => _asleepOffset.value;
  DateTime get asleepTime => _asleepTime.value;
  Offset get wakeupOffset => _wakeupOffset.value;
  DateTime get wakeupTime => _wakeupTime.value;

  bool get shouldDisplayVerticalLine {
    if (asleepTime == null || wakeupTime == null) return false;

    // print('-----');
    // print('different orbit: ${asleepTime.isInner == wakeupTime.isOuter}');
    // print('woke up after 6: ${wakeupTime.isAfter(sixOclock)}');
    // print('asleep before 6: ${asleepTime.isBefore(sixOclock)}');

    return asleepTime.isInner == wakeupTime.isOuter ||
        wakeupTime.isAfter(sixOclock) && asleepTime.isBefore(sixOclock) ||
        wakeupTime.isAfter(sixOclock) && asleepTime.isAfter(wakeupTime);
  }

  setOffset(Offset offset) {
    // radial coordinate system
    final coordinate = RadialCoordinate.fromOffset(offset);

    // closeness to dials
    final outerCloseness = (diameter / 2 - coordinate.radius).abs();
    final innerCloseness = (innerDiameter / 2 - coordinate.radius).abs();
    final isCloserToInner = innerCloseness < outerCloseness;

    // radius adjust
    final radius = isCloserToInner ? innerDiameter / 2 : diameter / 2;
    final step =
        isCloserToInner ? 360 / innerValues.length : 360 / outerValues.length;

    // constraint
    coordinate.radius = radius - Size.fontTiny;
    coordinate.degrees = (coordinate.degrees / step).round() * step;
    final constrainedOffset = coordinate.offset;

    // pm adjust
    DateTime time = coordinate.time;
    if (isCloserToInner && coordinate.degrees <= 180 ||
        !isCloserToInner && coordinate.degrees > 180)
      time = time.add(Duration(hours: 12));
    time = DateTime(0, 0, 0, time.hour);

    // print('ScheduleScreen._displayAtOffset'
    //   '\n\tdegrees: ${coordinate.degrees}'
    //   '\n\ttime: $time');

    // closeness to asleep/wakeup
    final asleepCloseness = (coordinate.offset - asleepOffset).distance;
    final wakeupCloseness = (coordinate.offset - wakeupOffset).distance;
    final isCloserToAsleep = asleepCloseness < wakeupCloseness;

    final destinationOffset = isCloserToAsleep ? _asleepOffset : _wakeupOffset;
    final destinationTime = isCloserToAsleep ? _asleepTime : _wakeupTime;

    destinationOffset.value = Offset(
        constrainedOffset.dx - (iconSize + iconBorder) / 2,
        constrainedOffset.dy - (iconSize + iconBorder) / 2);
    destinationTime.value = time;
  }
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
    if (degrees < 0) degrees = 360 + degrees;
  }

  double get angle => degrees * pi / 180;
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

extension DateTimeExtension on DateTime {
  double get angle =>
      this == null ? 0 : (hour * 60 + minute) / minutesInRadian % (2 * pi);
  bool get isOuter => this == null ? false : hour > 18 || hour <= 6;
  bool get isInner => this == null ? false : !isOuter;

  bool isAfterOrEqual(DateTime date) =>
      this.isAfter(date) || this.isAtSameMomentAs(date);
}
