import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart' hide Size;
import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/values.dart' hide iconSize;
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/schedule_model.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ScheduleController extends Controller with SingleGetTickerProviderMixin {
  ScheduleController() {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value);
  }

  final nightInnerValues = [for (int i = 7; i <= 18; i++) i];
  final nightOuterValues = [
    for (int i = 1; i <= 6; i++) i,
    for (int i = 19; i <= 24; i++) i
  ];

  final _asleepOffset = Offset.zero.obs;
  final _asleepTime = Rx<DateTime>(null);
  final _wakeupOffset = Offset(diameter - iconSize - 2 * iconBorder, 0).obs;
  final _wakeupTime = Rx<DateTime>(null);

  bool get isInit => asleepTime != null && wakeupTime != null;

  Offset get asleepOffset => _asleepOffset.value;
  DateTime get asleepTime => _asleepTime.value;
  Offset get wakeupOffset => _wakeupOffset.value;
  DateTime get wakeupTime => _wakeupTime.value;

  @override
  onInit() {
    super.onInit();

    final schedule = AuthService.i.profile?.schedule;
    if (schedule != null) {
      _asleepTime.value = schedule.asleepTime;

      _dayItems.assignAll(schedule.items ?? []);
      final wakeup = _dayItems.firstWhere(
          (x) => x.type == ScheduleItemType.WAKEUP,
          orElse: () => null);
      if (wakeup != null) _wakeupTime.value = wakeup.time;
    } else {
      // once(_asleepTime, _updateDayItems);
      // once(_wakeupTime, _updateDayItems);
      // once(_trainingTime, _updateDayItems);
    }

    // print(
    //     'ScheduleController.onInit items: ${AuthService.i.profile?.schedule?.items}');
  }

  bool get shouldDisplayVerticalLine {
    if (!isInit) return false;

    // print('-----');
    // print('different orbit: ${asleepTime.isInner == wakeupTime.isOuter}');
    // print('woke up after 6: ${wakeupTime.isAfter(sixOclock)}');
    // print('asleep before 6: ${asleepTime.isBefore(sixOclock)}');

    return asleepTime.isInner == wakeupTime.isOuter ||
        wakeupTime.isAfter(sixOclock) && asleepTime.isBefore(sixOclock) ||
        wakeupTime.isAfter(sixOclock) && asleepTime.isAfter(wakeupTime) ||
        asleepTime.isBefore(sixOclock) && asleepTime.isAfter(wakeupTime);
  }

  setOffset(Offset offset, {bool isNight = true}) {
    // radial coordinate system
    final coordinate = RadialCoordinate.fromOffset(offset);

    // closeness to dials
    final outerCloseness = (diameter / 2 - coordinate.radius).abs();
    final innerCloseness = (innerDiameter / 2 - coordinate.radius).abs();
    final isCloserToInner = innerCloseness < outerCloseness;

    // radius adjust
    final radius = isCloserToInner ? innerDiameter / 2 : diameter / 2;

    // constraint
    coordinate.radius = radius - Size.fontTiny;
    coordinate.degrees =
        (coordinate.degrees / degreesInHour).round() * degreesInHour;
    final constrainedOffset = coordinate.offset;

    // pm adjust
    DateTime time = coordinate.time;
    if (isNight &&
            (isCloserToInner && coordinate.degrees <= 180 ||
                !isCloserToInner && coordinate.degrees > 180) ||
        !isNight && !isCloserToInner) time = time.add(Duration(hours: 12));
    time = DateTime(0, 0, 0, time.hour);

    // print('ScheduleScreen._displayAtOffset'
    //   '\n\tdegrees: ${coordinate.degrees}'
    //   '\n\ttime: $time');

    // closeness to asleep/wakeup
    if (isNight) {
      final asleepCloseness = (coordinate.offset - asleepOffset).distance;
      final wakeupCloseness = (coordinate.offset - wakeupOffset).distance;

      final isCloserToAsleep = asleepCloseness < wakeupCloseness;

      final destinationOffset =
          isCloserToAsleep ? _asleepOffset : _wakeupOffset;
      final destinationTime = isCloserToAsleep ? _asleepTime : _wakeupTime;

      destinationOffset.value = Offset(
          constrainedOffset.dx - (iconSize + iconBorder) / 2,
          constrainedOffset.dy - (iconSize + iconBorder) / 2);
      destinationTime.value = time;
    } else {
      final wakeupCloseness = (coordinate.offset - wakeupOffset).distance;
      final trainingCloseness =
          (coordinate.offset - dayTrainingOffset).distance;

      final isCloserToWakeup = wakeupCloseness < trainingCloseness;
      if (isCloserToWakeup) {
        _wakeupOffset.value = Offset(
            constrainedOffset.dx - (iconSize + iconBorder) / 2,
            constrainedOffset.dy - (iconSize + iconBorder) / 2);
        _wakeupTime.value = time;
      } else {
        _trainingTime.value = time;
      }
    }
  }

  Offset offsetFromTime(DateTime time, {bool isNight = true}) {
    // radial coordinate system
    final coordinate = RadialCoordinate.fromTime(time);
    final radius = isNight
        ? 0
        : time.isDayInner
            ? innerDiameter / 2
            : diameter / 2;

    //print('ScheduleController.offsetFromTime time: $time hour: ${time.hour}');

    // constraint
    coordinate.radius = radius - Size.fontTiny;
    coordinate.degrees =
        (coordinate.degrees / degreesInHour).round() * degreesInHour;
    final offset = coordinate.offset;

    // factoring in indicator size
    final resultOffset = Offset(offset.dx - (iconSize + iconBorder) / 2,
        offset.dy - (iconSize + iconBorder) / 2);

    return resultOffset;
  }

  // day dial implementation

  final _dayItems = RxList<ScheduleItemData>();
  List<ScheduleItemData> get dayItems => _dayItems.value;

  final _trainingTime = Rx<DateTime>(null);
  DateTime get trainingTime => _trainingTime.value;

  final dayInnerValues = [for (int i = 1; i <= 12; i++) i];
  final dayOuterValues = [for (int i = 13; i <= 24; i++) i];

  Offset get dayAsleepOffset => offsetFromTime(asleepTime, isNight: false);
  Offset get dayWakeupOffset => offsetFromTime(wakeupTime, isNight: false);
  Offset get dayTrainingOffset => offsetFromTime(trainingTime, isNight: false);

  bool get shouldDayBeDisplayed => isInit && !_dayItems.isNullOrEmpty;
  bool get shouldDayInnerBeDisplayed =>
      isInit &&
      (wakeupTime.isDayInner ||
          asleepTime.isDayInner ||
          shouldDayDisplayVerticalLine);
  bool get shouldDayOuterBeDisplayed =>
      isInit &&
      (wakeupTime.isDayOuter ||
          asleepTime.isDayOuter ||
          shouldDayDisplayVerticalLine);
  bool get shouldDayDisplayVerticalLine {
    if (!isInit) return false;

    return asleepTime.isDayInner == wakeupTime.isDayOuter ||
        asleepTime.isAfter(twelveOclock) && asleepTime.isBefore(wakeupTime) ||
        wakeupTime.isBefore(twelveOclock) && asleepTime.isBefore(wakeupTime);
  }

  double get dayOuterStartAngle =>
      -pi / 2 + (wakeupTime.isDayOuter ? wakeupTime.angle : 0);
  double get dayOuterEndAngle {
    final from = dayOuterStartAngle;
    final to = -pi / 2 + (asleepTime.isDayOuter ? asleepTime.angle : 2 * pi);
    final angle = to - from;

    // print('ScheduleController.dayOuterEndAngle'
    //     '\n\tfrom: ${from * degreesInRadian}'
    //     '\n\tto: ${to * degreesInRadian}'
    //     '\n\tangle: ${angle * degreesInRadian}');

    return angle < 0 ? 2 * pi + angle : angle;
  }

  double get dayInnerStartAngle =>
      -pi / 2 + (wakeupTime.isDayInner ? wakeupTime.angle : 0);
  double get dayInnerEndAngle {
    final from = dayInnerStartAngle;
    final to = -pi / 2 + (asleepTime.isDayInner ? asleepTime.angle : 2 * pi);
    final angle = to - from;

    // print('ScheduleController.dayInnerEndAngle'
    //     '\n\tfrom: ${from * degreesInRadian}'
    //     '\n\tto: ${to * degreesInRadian}'
    //     '\n\tangle: ${angle * degreesInRadian}');

    return angle < 0 ? 2 * pi + angle : angle;
  }

  bool get canRequestSchedule {
    // always required
    if (asleepTime == null || wakeupTime == null) return false;

    // required only on day of training
    if (AuthService.i.profile.isTrainingDay && trainingTime == null)
      return false;
    return true;
  }

  Future <bool> updateDayItems() async {
    if (!canRequestSchedule)
      return false;

    final response = await mutation(schedulesCreateMutation, parameters: {
      'asleepTime': dateToString(date: asleepTime, output: dateTime),
      'wakeupTime': dateToString(date: wakeupTime, output: dateTime),
      'trainingTime': dateToString(date: trainingTime, output: dateTime)
    });

    if (response == null) return false;

    final result = response.get(['schedulesCreate', 'schedule']);
    if (result == null) return false;

    final schedule = ScheduleData.fromJson(result);
    AuthService.i.profile.schedule = schedule;

    _dayItems.assignAll(schedule.items);

    return !_dayItems.isNullOrEmpty;
  }

  // accordion

  final minRotationAngle = .0;
  final maxRotationAngle = pi / 2;
  final List<int> _openedItems = [];

  final _animationProgress = .0.obs;
  final _lastToggledItem = 0.obs;

  AnimationController _animationController;

  AnimationController get animationController => _animationController;
  double get animationProgress => _animationProgress.value;
  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;

  bool isOpened(int i) => _openedItems.contains(i);
  double getRotationAngle(int i) => i == _lastToggledItem.value
      ? rotationAngle
      : isOpened(i)
          ? maxRotationAngle
          : minRotationAngle;

  Animation<double> getSizeFactor(int i) => i == _lastToggledItem.value
      ? Tween<double>(begin: .0, end: 1.0).animate(_animationController)
      : AlwaysStoppedAnimation(isOpened(i) ? 1.0 : .0);

  toggle(int i) {
    _lastToggledItem(i);

    if (isOpened(i)) {
      _openedItems.remove(i);
      _animationController.reverse(from: maxRotationAngle);
    } else {
      _openedItems.add(i);
      _animationController.forward(from: minRotationAngle);
    }
  }
}