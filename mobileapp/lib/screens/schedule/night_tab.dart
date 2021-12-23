import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/models/schedule_model.dart';
import 'package:hls/screens/schedule/_schedule_tab.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/theme/styles.dart';

class NightTab extends ScheduleTab {

  // builders

  ScrollController scrollController = ScrollController(initialScrollOffset: Get.height);

  @override
  Widget build(_) => Screen(
        title: scheduleScreenTitle,
  child: SingleChildScrollView(

    controller: scrollController,
            // padding: Padding.content,
            child: Column(children: [
          Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                    size: M.Size(diameter, diameter),
                    painter: CircleDialPainter(
                        values: controller.nightOuterValues,
                        color: Colors.black,
                        width: iconBorder)),
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
                        (asleepTime.isNightOuter || wakeupTime.isNightOuter)
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
                        (wakeupTime.isNightInner || asleepTime.isNightInner)
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
                                        wakeupTime.isBefore(asleepTime))) ||
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
                Obx(() => controller.shouldNightDisplayVerticalLine
                    ? Positioned(
                        bottom: .0,
                        child: Container(
                            color: Colors.scheduleNight,
                            width: iconBorder,
                            height: (diameter - innerDiameter) / 2))
                    : Nothing()),
                Obx(() => buildIndicator(
                    nightAsleepOffset, asleepTime, Colors.scheduleNight,
                    icon: FontAwesomeIcons.sun)),
                Obx(() => buildIndicator(
                    nightWakeupOffset, wakeupTime, Colors.scheduleDay,
                    icon: FontAwesomeIcons.moon))
              ]),
          VerticalSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            buildLegend(Colors.scheduleNight, scheduleAsleepLabel),
            HorizontalSpace(),
            buildLegend(Colors.scheduleDay, scheduleAwakeLabel)
          ]),
          VerticalBigSpace(),
          buildAccordion(scheduleDayTriviaTitle1,
              child: Column(children: [
                for (final item in controller.dayItems) ...[
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: Size.horizontal),
                      child: ScheduleItem(data: item)),
                  if (item != controller.dayItems.last) VerticalSmallSpace()
                ]
              ])),
          // VerticalBigSpace(),
          // buildAccordion(scheduleNightTriviaTitle1,
          //     text: scheduleNightTriviaText2),
          // VerticalMediumSpace(),
          // buildAccordion(scheduleNightTriviaTitle2,
          //     text: scheduleNightTriviaText2),
        ])),
      );
}

class ScheduleItem extends StatelessWidget {
  final ScheduleItemData data;

  ScheduleItem({this.data});

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(borderRadius: borderRadiusCircular, boxShadow: [
        BoxShadow(
            color: Colors.shadow.withOpacity(1),
            blurRadius: 2 * panelShadowBlurRadius,
            //spreadRadius: panelShadowSpreadRadius,
            offset: -panelShadowOffset)
      ]),
      child: ClipRRect(
          borderRadius: borderRadiusCircular,
          child: IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Container(
                    color: data.type.type.color, width: Size.horizontalTiny),
                Expanded(
                    child: Container(
                        color: Colors.background,
                        padding: Padding.content,
                        child: Row(children: [
                          Expanded(
                              child: TextPrimaryHint(data.title ?? noDataText)),
                          HorizontalSpace(),
                          TextPrimaryHint(
                              dateToString(date: data.time, output: dateTime))
                        ])))
              ]))));
}
