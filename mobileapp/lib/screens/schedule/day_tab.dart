import 'dart:ui';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/schedule_model.dart';
import 'package:hls/screens/schedule/_schedule_tab.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/theme/styles.dart';

class DayTab extends ScheduleTab {
  // handlers

  @override
  onDrag(BuildContext context, DragUpdateDetails details) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition),
        isNight: false);
  }

  @override
  onTap(BuildContext context, TapUpDetails details) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition),
        isNight: false);
  }

  _updateDayItemsHandler() async {
    if (!await controller.updateDayItems())
      showConfirm(title: controller.message ?? errorGenericText);
  }

  // builders

  @override
  Widget build(_) => SingleChildScrollView(
      padding: Padding.content,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //if (!controller.shouldDayBeDisplayed)
        TextPrimary(scheduleDayText,
            weight: FontWeight.w400, align: TextAlign.center),
        VerticalBigSpace(),
        Builder(
            builder: (context) => GestureDetector(
                onTapUp: (details) =>
                    controller.isInit && !controller.shouldDayBeDisplayed
                        ? onTap(context, details)
                        : null,
                onPanUpdate: (details) =>
                    controller.isInit && !controller.shouldDayBeDisplayed
                        ? onDrag(context, details)
                        : null,
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
                                color: Colors.black)),
                        // inner dial
                        CustomPaint(
                            size: M.Size(innerDiameter, innerDiameter),
                            painter: CircleDialPainter(
                                values: controller.dayInnerValues,
                                fontSize: .8 * Size.fontTiny,
                                color: Colors.black)),
                        // outer line
                        if (controller.shouldDayBeDisplayed) ...[
                          Obx(() => controller.shouldDayOuterBeDisplayed
                              ? CustomPaint(
                                  size: M.Size(diameter, diameter),
                                  painter: SectorPainter(
                                      width: iconBorder,
                                      color: Colors.scheduleDay,
                                      startAngle: controller.dayOuterStartAngle,
                                      endAngle: controller.dayOuterEndAngle))
                              : Nothing()),
                          // inner line
                          Obx(() => controller.shouldDayInnerBeDisplayed
                              ? CustomPaint(
                                  size: M.Size(innerDiameter, innerDiameter),
                                  painter: SectorPainter(
                                      width: iconBorder,
                                      color: Colors.scheduleDay,
                                      startAngle: controller.dayInnerStartAngle,
                                      endAngle: controller.dayInnerEndAngle))
                              : Nothing()),
                          // connection line
                          Obx(() => controller.shouldDayDisplayVerticalLine
                              ? Positioned(
                                  top: .0,
                                  child: Container(
                                      color: Colors.scheduleDay,
                                      width: iconBorder,
                                      height: (diameter - innerDiameter) / 2))
                              : Nothing()),
                          // points
                          if (!controller.dayItems.isNullOrEmpty)
                            for (final item in controller.dayItems)
                              buildIndicator(item.offset, item.time, item.color,
                                  isSmall: item.isSmall)
                        ],
                        // Obx(() => buildIndicator(
                        //     dayAsleepOffset, asleepTime, Colors.scheduleNight)),
                        if (!controller.shouldDayBeDisplayed) ...[
                          if (wakeupTime != null)
                            Obx(() => buildIndicator(
                                dayWakeupOffset, wakeupTime, Colors.scheduleDay,
                                icon: Icons.wb_sunny)),
                          if (controller.isTrainingDay)
                            Obx(() => buildIndicator(dayTrainingOffset,
                                trainingTime, Colors.exercise,
                                icon: Icons.fitness_center_rounded)),
                          Obx(() => controller.canRequestSchedule
                              ? CircularButton(
                                  icon: Icons.check,
                                  isLoading: controller.isAwaiting,
                                  onPressed: _updateDayItemsHandler)
                              : Nothing())
                        ],
                        if (!controller.isInit)
                          BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: submenuBlurStrength,
                                  sigmaY: submenuBlurStrength *
                                      submenuBlurVerticalCoefficient),
                              child: Container(
                                  width: diameter,
                                  child: TextPrimary(
                                      'Выберите время отбоя и подъема на предыдущей диаграмме',
                                      align: TextAlign.center)))
                      ]);
                }))),
        VerticalSpace(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildLegend(Colors.scheduleDay, scheduleAwakeLabel),
          VerticalTinySpace(),
          buildLegend(Colors.scheduleMainFood, scheduleMainFoodLabel),
          VerticalTinySpace(),
          buildLegend(
              Colors.scheduleAdditionalFood, scheduleAdditionalFoodLabel),
          VerticalTinySpace(),
          buildLegend(Colors.scheduleProteinFood, scheduleProteinFoodLabel),
          VerticalTinySpace(),
          buildLegend(Colors.exercise, scheduleExerciseLabel),
          VerticalTinySpace(),
          buildLegend(Colors.scheduleNight, scheduleAsleepLabel),
        ]),
        VerticalBigSpace(),
        buildAccordion(scheduleDayTriviaTitle1,
            child: Column(children: [
              for (final item in controller.dayItems) ...[
                Container(padding: EdgeInsets.symmetric(horizontal: Size.horizontal), child: ScheduleItem(data: item)),
                if (item != controller.dayItems.last) VerticalSmallSpace()
              ]
            ]))
      ]));
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
