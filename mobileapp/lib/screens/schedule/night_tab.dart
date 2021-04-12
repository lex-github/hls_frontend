import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/screens/schedule/_schedule_tab.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/theme/styles.dart';

class NightTab extends ScheduleTab {
  // builders

  @override
  Widget build(_) => SingleChildScrollView(
      padding: Padding.content,
      child: Column(children: [
        TextPrimary(scheduleNightText,
            weight: FontWeight.w400, align: TextAlign.center),
        VerticalBigSpace(),
        Builder(
            builder: (context) => GestureDetector(
                onTapUp: (details) => onTap(context, details),
                onPanUpdate: (details) => onDrag(context, details),
                child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(
                          size: M.Size(diameter, diameter),
                          painter: CircleDialPainter(
                              values: controller.nightOuterValues,
                              color: Colors.black)),
                      CustomPaint(
                          size: M.Size(innerDiameter, innerDiameter),
                          painter: CircleDialPainter(
                              values: controller.nightInnerValues,
                              offset: pi,
                              //- 2 * pi / controller.innerValues.length,
                              fontSize: .8 * Size.fontTiny,
                              color: Colors.black)),
                      Obx(() => asleepTime != null &&
                              wakeupTime != null &&
                              (asleepTime.isOuter || wakeupTime.isOuter)
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
                      Obx(() => asleepTime != null &&
                              wakeupTime != null &&
                              (wakeupTime.isInner || asleepTime.isInner)
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
                      Obx(() => buildIndicator(
                          asleepOffset, asleepTime, Colors.scheduleNight,
                          icon: Icons.nightlight_round)),
                      Obx(() => buildIndicator(
                          wakeupOffset, wakeupTime, Colors.scheduleDay,
                          icon: Icons.wb_sunny))
                    ]))),
        VerticalSpace(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildLegend(Colors.scheduleNight, scheduleAsleepLabel),
          HorizontalSpace(),
          buildLegend(Colors.scheduleDay, scheduleAwakeLabel)
        ]),
        VerticalBigSpace(),
        buildAccordion(scheduleNightTriviaTitle1, scheduleNightTriviaText2),
        VerticalMediumSpace(),
        buildAccordion(scheduleNightTriviaTitle2, scheduleNightTriviaText2),
      ]));
}
