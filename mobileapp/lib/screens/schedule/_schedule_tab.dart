import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/schedule_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/screens/schedule/helpers.dart';
import 'package:hls/theme/styles.dart';

abstract class ScheduleTab extends GetView<ScheduleAddController> {
  Offset get nightAsleepOffset => controller.nightAsleepOffset;
  Offset get dayAsleepOffset => controller.dayAsleepOffset;
  DateTime get asleepTime => controller.asleepTime;

  Offset get nightWakeupOffset => controller.nightWakeupOffset;
  Offset get dayWakeupOffset => controller.dayWakeupOffset;
  DateTime get wakeupTime => controller.wakeupTime;

  Offset get dayTrainingOffset => controller.dayTrainingOffset;
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

  onDrag(BuildContext context, DragUpdateDetails details) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition));
  }

  onTap(BuildContext context, TapUpDetails details) {
    // global to local coordinates
    final RenderBox box = context.findRenderObject();
    controller.setOffset(box.globalToLocal(details.globalPosition));
  }

  // builders

  Widget buildLegend(Color color, String text) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: Size.horizontalMedium,
            height: Size.border * 2,
            color: color),
        HorizontalTinySpace(),
        TextSecondary(text, size: Size.fontTiny)
      ]);

  Widget buildAccordion(String title, {String text, Widget child}) => Button(
      padding: Padding.zero,
      borderColor: Colors.disabled,
      onPressed: () => controller.toggle(1),
      child: Column(children: [
        VerticalSmallSpace(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
            child: Row(children: [
              Container(height: Size.iconBig),
              TextPrimaryHint(title),
              Expanded(child: HorizontalSpace()),
              Obx(() => Transform.rotate(
                  angle: controller.getRotationAngle(1),
                  child: Icon(FontAwesomeIcons.chevronRight,
                      color: Colors.disabled, size: Size.iconSmall)))
            ])),
        Obx(() => SizeTransition(
            sizeFactor: controller.getSizeFactor(1),
            child: Container(
                padding: EdgeInsets.only(top: Size.vertical),
                child: text.isNullOrEmpty
                    ? child ?? Nothing()
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: Size.horizontal),
                        child: TextSecondary(text))))),
        VerticalSmallSpace()
      ]));

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
                              size: isSmall
                                  ? .75 * Size.fontTiny
                                  : Size.fontSmall,
                              shadow: Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2,
                                  color: Colors.shadow.withOpacity(1))))));

  @override
  Widget build(_);
}
