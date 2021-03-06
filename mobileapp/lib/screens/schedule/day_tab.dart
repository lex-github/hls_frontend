// import 'dart:ui';
//
// import 'package:flutter/material.dart'
//     hide Colors, Image, Padding, Size, TextStyle;
// import 'package:flutter/material.dart' as M;
// import 'package:hls/components/generic.dart';
// import 'package:hls/components/painters.dart';
// import 'package:hls/constants/formats.dart';
// import 'package:hls/constants/strings.dart';
// import 'package:hls/constants/values.dart';
// import 'package:hls/helpers/convert.dart';
// import 'package:hls/helpers/null_awareness.dart';
// import 'package:hls/models/schedule_model.dart';
// import 'package:hls/screens/schedule/_schedule_tab.dart';
// import 'package:hls/screens/schedule/helpers.dart';
// import 'package:hls/theme/styles.dart';
//
// class DayTab extends ScheduleTab {
//   // handlers
//
//   @override
//   onDrag(BuildContext context, DragUpdateDetails details) {
//     // global to local coordinates
//     final RenderBox box = context.findRenderObject();
//     controller.setOffset(box.globalToLocal(details.globalPosition),
//         isNight: false);
//   }
//
//   @override
//   onTap(BuildContext context, TapUpDetails details) {
//     // global to local coordinates
//     final RenderBox box = context.findRenderObject();
//     controller.setOffset(box.globalToLocal(details.globalPosition),
//         isNight: false);
//   }
//
//   // _updateDayItemsHandler() async {
//   //   if (!await controller.updateDayItems())
//   //     showConfirm(title: controller.message ?? errorGenericText);
//   // }
//
//   // builders
//
//   @override
//   Widget build(_) => SingleChildScrollView(
//       padding: Padding.content,
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
//           // outer dial
//           CustomPaint(
//               size: M.Size(diameter, diameter),
//               painter: CircleDialPainter(
//                   values: controller.dayOuterValues,
//                   color: Colors.black,
//                   width: iconBorder,
//                   numToOffset: 24)),
//           // inner dial
//           CustomPaint(
//               size: M.Size(innerDiameter, innerDiameter),
//               painter: CircleDialPainter(
//                   values: controller.dayInnerValues,
//                   fontSize: .8 * Size.fontTiny,
//                   color: Colors.black,
//                   width: iconBorder)),
//           // outer line
//           if (controller.shouldDayOuterBeDisplayed)
//             CustomPaint(
//                 size: M.Size(diameter, diameter),
//                 painter: SectorPainter(
//                     width: iconBorder,
//                     color: Colors.scheduleDay,
//                     startAngle: controller.dayOuterStartAngle,
//                     endAngle: controller.dayOuterEndAngle)),
//           // inner line
//           if (controller.shouldDayInnerBeDisplayed)
//             CustomPaint(
//                 size: M.Size(innerDiameter, innerDiameter),
//                 painter: SectorPainter(
//                     width: iconBorder,
//                     color: Colors.scheduleDay,
//                     startAngle: controller.dayInnerStartAngle,
//                     endAngle: controller.dayInnerEndAngle)),
//           // connection line
//           controller.shouldDayDisplayVerticalLine
//               ? Positioned(
//                   top: .0,
//                   child: Container(
//                       color: Colors.scheduleDay,
//                       width: iconBorder,
//                       height: (diameter - innerDiameter) / 2))
//               : Nothing(),
//           // points
//           if (!controller.dayItems.isNullOrEmpty)
//             for (final item in controller.dayItems)
//               buildIndicator(item.offset, item.time, item.color,
//                   isSmall: item.isSmall)
//         ]),
//         VerticalSpace(),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             buildLegend(Colors.scheduleDay, scheduleAwakeLabel),
//             VerticalSpace(),
//             buildLegend(Colors.scheduleMainFood, scheduleMainFoodLabel),
//           ]),
//           HorizontalSpace(),
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             buildLegend(Colors.scheduleAdditionalFood, scheduleAdditionalFoodLabel),
//             VerticalSpace(),
//             buildLegend(Colors.exercise, scheduleExerciseLabel),
//           ])
//         ]),
//         VerticalBigSpace(),
//         buildAccordion(scheduleDayTriviaTitle1,
//             child: Column(children: [
//               for (final item in controller.dayItems) ...[
//                 Container(
//                     padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
//                     child: ScheduleItem(data: item)),
//                 if (item != controller.dayItems.last) VerticalSmallSpace()
//               ]
//             ]
//             ))
//       ]));
// }
//
// class ScheduleItem extends StatelessWidget {
//   final ScheduleItemData data;
//   ScheduleItem({this.data});
//
//   @override
//   Widget build(BuildContext context) => Container(
//       decoration: BoxDecoration(borderRadius: borderRadiusCircular, boxShadow: [
//         BoxShadow(
//             color: Colors.shadow.withOpacity(1),
//             blurRadius: 2 * panelShadowBlurRadius,
//             //spreadRadius: panelShadowSpreadRadius,
//             offset: -panelShadowOffset)
//       ]),
//       child: ClipRRect(
//           borderRadius: borderRadiusCircular,
//           child: IntrinsicHeight(
//               child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                 Container(
//                     color: data.type.type.color, width: Size.horizontalTiny),
//                 Expanded(
//                     child: Container(
//                         color: Colors.background,
//                         padding: Padding.content,
//                         child: Row(children: [
//                           Expanded(
//                               child: TextPrimaryHint(data.title ?? noDataText)),
//                           HorizontalSpace(),
//                           TextPrimaryHint(
//                               dateToString(date: data.time, output: dateTime))
//                         ])))
//               ]))));
// }
