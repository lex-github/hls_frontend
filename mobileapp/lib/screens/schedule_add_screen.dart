import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/schedule_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/theme/styles.dart';

class ScheduleAddScreen extends GetView<ScheduleAddController> {
  Offset get nightAsleepOffset => controller.nightAsleepOffset;
  Offset get nightWakeupOffset => controller.nightWakeupOffset;

  // Offset get dayAsleepOffset => controller.dayAsleepOffset;
  Offset get dayWakeupOffset => controller.dayWakeupOffset;
  Offset get dayTrainingOffset => controller.dayTrainingOffset;

  DateTime get asleepTime => controller.asleepTime;
  DateTime get wakeupTime => controller.wakeupTime;
  DateTime get trainingTime => controller.trainingTime;

  String format(DateTime time) {
    if (time.minute != 0) return dateToString(date: time, output: 'HH:mm');

    final x = dateToString(date: time, output: 'H');

    if (x == '00') return '24';

    //if (x == '18') return '6';

    if (x.startsWith('0')) return x.substring(1);

    return x;
  }

  // handlers

  _onDrag(BuildContext context, DragUpdateDetails details,
      {bool isNight = true}) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition),
        isNight: isNight);
  }

  _onTap(BuildContext context, TapUpDetails details, {bool isNight = true}) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition),
        isNight: isNight);
  }

  _onSubmit() async {
    if (!controller.isNightInit) {
      controller.isNightInit = true;
      return;
    }

    return showConfirm(title: developmentText);

    controller.isDayInit = true;
  }

  // builders

  Widget buildIndicator(Offset offset, DateTime time, Color color,
          {IconData icon, bool isSmall = false}) =>
      AnimatedPositioned(
          left: offset.dx,
          top: offset.dy,
          //duration: defaultAnimationDuration,
          duration: 20.milliseconds,
          child: Container(
              decoration: BoxDecoration(
                  color: isSmall ? color : Colors.background,
                  border: Border.all(color: color, width: iconBorder),
                  borderRadius: BorderRadius.circular(iconSize / 2)),
              width: isSmall ? iconSmallSize : iconSize,
              height: isSmall ? iconSmallSize : iconSize,
              child: isSmall
                  ? Nothing()
                  : Center(
                      child: time == null
                          ? Icon(
                              icon ??
                                  Icons
                                      .error, // Icons.nightlight_round, Icons.wb_sunny,
                              color: color,
                              size: .75 * iconSize)
                          : TextPrimary(format(time),
                              weight: FontWeight.w900,
                              size:
                                  isSmall ? .75 * Size.fontTiny : Size.fontBig,
                              shadow: Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2,
                                  color: Colors.shadow.withOpacity(1))))));

  Widget _buildTabs() => DefaultTabController(
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
              tabs: [Text(scheduleNightTabTitle), Text(scheduleDayTabTitle)]),
          child: TabBarView(
              //physics: NeverScrollableScrollPhysics(),
              children: [
                Container(color: Colors.scheduleNight),
                Container(color: Colors.scheduleDay)
              ])));

  Widget _buildNight() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextPrimary(
            asleepTime == null
                ? scheduleNightText1
                : wakeupTime == null
                    ? scheduleNightText2
                    : scheduleNightText3,
            weight: FontWeight.w400,
            align: TextAlign.center),
        VerticalBigSpace(),
        Builder(
            builder: (context) => GestureDetector(
                onTapUp: (details) => _onTap(context, details),
                onPanUpdate: (details) => _onDrag(context, details),
                child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Obx(() => CustomPaint(
                          size: M.Size(diameter, diameter),
                          painter: CircleDialPainter(
                              values: controller.nightOuterValues,
                              color: Colors.black,
                              width: iconBorder,
                              numToOffset: controller.shouldDisplayVerticalLine
                                  ? 6
                                  : 0))),
                      CustomPaint(
                          size: M.Size(innerDiameter, innerDiameter),
                          painter: CircleDialPainter(
                              values: controller.nightInnerValues,
                              offset: pi,
                              //- 2 * pi / controller.innerValues.length,
                              fontSize: .8 * Size.fontTiny,
                              color: Colors.black,
                              width: iconBorder)),
                      Obx(() => asleepTime != null &&
                              wakeupTime != null &&
                              (asleepTime.isNightOuter ||
                                  wakeupTime.isNightOuter)
                          ? CustomPaint(
                              size: M.Size(diameter, diameter),
                              painter: SectorPainter(
                                //from: asleepTime.value, to: wakeupTime.value
                                width: iconBorder,
                                color: Colors.scheduleNight,
                                startAngle: (asleepTime.isNightOuter
                                        ? asleepTime.angle
                                        : pi) -
                                    pi / 2,
                                endAngle: (2 * pi -
                                        (asleepTime.isNightInner
                                            ? pi
                                            : asleepTime.angle) +
                                        (wakeupTime.isNightInner
                                            ? pi
                                            : wakeupTime.angle)) %
                                    (2 * pi),
                              ))
                          : asleepTime.isNightInner &&
                                  wakeupTime.isNightInner &&
                                  wakeupTime.isBefore(asleepTime)
                              ? CustomPaint(
                                  size: M.Size(diameter, diameter),
                                  painter: SectorPainter(
                                    width: iconBorder,
                                    color: Colors.scheduleNight,
                                    endAngle: 2 * pi,
                                  ))
                              : Nothing()),
                      Obx(() => asleepTime != null &&
                              wakeupTime != null &&
                              (wakeupTime.isNightInner ||
                                  asleepTime.isNightInner)
                          ? CustomPaint(
                              size: M.Size(innerDiameter, innerDiameter),
                              painter: SectorPainter(
                                width: iconBorder,
                                color: Colors.scheduleNight,
                                startAngle: asleepTime.isNightInner
                                    ? asleepTime.angle - pi / 2
                                    : pi / 2,
                                endAngle: (asleepTime.isNightOuter
                                        ? wakeupTime.angle - pi
                                        : -asleepTime.angle +
                                            (wakeupTime.isNightInner
                                                ? wakeupTime.angle
                                                : pi)) %
                                    (2 * pi),
                              ))
                          : wakeupTime.isNightOuter &&
                                  asleepTime.isNightOuter &&
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
                      Obx(() => asleepTime == null
                          ? Nothing()
                          : buildIndicator(nightAsleepOffset, asleepTime,
                              Colors.scheduleNight,
                              icon: FontAwesomeIcons.moon)),
                      Obx(() => wakeupTime == null
                          ? Nothing()
                          : buildIndicator(
                              nightWakeupOffset, wakeupTime, Colors.scheduleDay,
                              icon: FontAwesomeIcons.sun))
                    ]))),
        VerticalBigSpace()
      ]);

  Widget _buildDay() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextPrimary(scheduleDayText1,
            weight: FontWeight.w400, align: TextAlign.center),
        VerticalBigSpace(),
        Builder(
            builder: (context) => GestureDetector(
                onTapUp: (details) => _onTap(context, details, isNight: false),
                onPanUpdate: (details) =>
                    _onDrag(context, details, isNight: false),
                child: Obx(() {
                  //print('DayTab.build ${controller.dayItems}');

                  return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // outer dial
                        CustomPaint(
                            size: M.Size(diameter, diameter),
                            painter: CircleDialPainter(
                                values: controller.dayOuterValues,
                                color: Colors.black,
                                width: iconBorder)),
                        // inner dial
                        CustomPaint(
                            size: M.Size(innerDiameter, innerDiameter),
                            painter: CircleDialPainter(
                                values: controller.dayInnerValues,
                                fontSize: .8 * Size.fontTiny,
                                color: Colors.black,
                                width: iconBorder)),
                        if (wakeupTime != null)
                          Obx(() => buildIndicator(
                              dayWakeupOffset, wakeupTime, Colors.scheduleDay,
                              icon: FontAwesomeIcons.sun)),
                        if (controller.isTrainingDay)
                          Obx(() => trainingTime == null
                              ? Nothing()
                              : buildIndicator(dayTrainingOffset, trainingTime,
                                  Colors.exercise,
                                  icon: FontAwesomeIcons.dumbbell))
                      ]);
                }))),
        VerticalBigSpace()
      ]);

  @override
  Widget build(_) => GetX(
      init: ScheduleAddController(),
      builder: (_) => controller.isInit
          ? _buildTabs()
          : Screen(
              title: scheduleScreenTitle,
              fab: CircularButton(
                  isDisabled: !controller.isNightInit &&
                          (asleepTime == null || wakeupTime == null) ||
                      controller.isNightInit &&
                          controller.isTrainingDay &&
                          trainingTime == null,
                  icon: FontAwesomeIcons.check,
                  iconSize: Size.iconSmall,
                  onPressed: _onSubmit),
              child: !controller.isNightInit ? _buildNight() : _buildDay()));

  // @override
  // Widget build(_) => GetBuilder(
  //     init: ScheduleController(),
  //     builder: (_) => DefaultTabController(
  //         length: 2,
  //         child: Screen(
  //             height: Size.bar + 2 * Size.verticalMedium + Size.font,
  //             padding: Padding.zero,
  //             shouldShowDrawer: true,
  //             title: scheduleScreenTitle,
  //             trailing: Clickable(
  //                 onPressed: () => showConfirm(title: developmentText),
  //                 child: Image(title: 'icons/question')),
  //             bottom: TabBar(
  //                 indicatorPadding:
  //                     EdgeInsets.symmetric(horizontal: Size.horizontal),
  //                 indicatorColor: Colors.primary,
  //                 labelPadding: Padding.medium,
  //                 labelStyle: TextStyle.primary,
  //                 labelColor: Colors.primaryText,
  //                 unselectedLabelStyle: TextStyle.primary,
  //                 //unselectedLabelColor: Colors.secondaryText,
  //                 tabs: [
  //                   Text(scheduleNightTabTitle),
  //                   Text(scheduleDayTabTitle)
  //                 ]),
  //             child: TabBarView(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 children: [NightTab(), DayTab()]))));
}
