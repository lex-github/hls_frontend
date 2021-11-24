import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/models/calendar_model.dart';
import 'package:hls/models/stats_model.dart';
import 'package:hls/theme/styles.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar<Controller extends StatsController> extends GetView<Controller> {
  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 7;


  Widget _headerBuilder(_, DateTime day) =>
      TextPrimary(
        DateFormat
            .yMMMM('ru_RU')
            .format(day)
            .capitalize,
        align: TextAlign.center,
        size: Size.fontBig,
      );

  Widget _dowBuilder(_, DateTime day) =>
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [TextSecondary(DateFormat.E('ru_RU').format(day))]);


  Widget _prioritizedBuilder(_, DateTime day, DateTime focusedDay) => GetBuilder<StatsController>
    (
      init: StatsController(
          fromDate: DateTime.now().subtract(90.days).toString(),
          toDate: DateTime.now().toString(),
      ),
      builder: (_) {
        final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
        final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);


        // controller.getSchedule();

        double schedule = 0;
        double exercise = 0;
        double nutrition = 0;

        if (day.isBefore(firstDay) || day.isAfter(lastDay)) return Nothing();
        if (controller.calendar != null) {
          for (var i = 0; i < controller.calendar.length; i++) {
            if (controller.calendar[i].date == dateToString(date: day, output: dateInternalFormat)) {
              schedule = controller.calendar[i].daily.schedule / 100;
              exercise = controller.calendar[i].daily.exercise / 100;
              nutrition = controller.calendar[i].daily.nutrition /100;
            }
          }
        }else{
          return Loading();
        }


        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerticalSmallSpace(),
              TextPrimaryHint(day.day.toString()),
              VerticalSmallSpace(),
              CalendarCell(
                  diameter: diameter, width: Size.horizontalTiny, schedule: schedule, exercise: exercise, nutrition: nutrition)
            ]);
      }
  );

  @override
  Widget build(_) =>
      Container(
        child: GetBuilder<StatsController>(
            init: StatsController(
                fromDate: DateTime.now().subtract(90.days).toString(),
                toDate: DateTime.now().toString()),
            builder: (_) =>
                TableCalendar(
                    headerStyle: HeaderStyle(
                        titleCentered: true, formatButtonVisible: false),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekHeight: Size.verticalSmall + Size.fontSmall,
                    rowHeight:
                    diameter + Size.verticalSmall * 2 + Size.fontSmall,
                    locale: 'ru',
                    firstDay: DateTime.now().subtract(90.days),
                    lastDay: DateTime.now(),
                    onDaySelected: (selectedDay, focusedDay) {
                      findLoop(selectedDay);
                    },
                    focusedDay: DateTime.now(),
                    calendarBuilders: CalendarBuilders(
                      headerTitleBuilder: _headerBuilder,
                      dowBuilder: _dowBuilder,
                      prioritizedBuilder: _prioritizedBuilder
                    ))),
      );
  void findLoop(DateTime day) {
    for (var i = 0; i < controller.calendar.length; i++) {
      if (controller.calendar[i].date == dateToString(date: day, output: dateInternalFormat)) {
        Get.toNamed(statsTabRoute, arguments: {'index': i, 'date': day});
      }
    }

    Get.toNamed(statsTabRoute, arguments: {'date': day, 'index': null});
  }

}

class CalendarCell extends StatelessWidget {
  final double width;
  final double diameter;
  final double schedule;
  final double exercise;
  final double nutrition;

  CalendarCell(
      {@required this.width, @required this.diameter, @required this.schedule, @required this.exercise, @required this.nutrition});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) =>
      Stack(alignment: Alignment.center, children: [
        CalendarCellCircle(
            color: Colors.macroStatistical,
            diameter: diameterProper * 0.9,
            width: width * 0.8,
            value: schedule),
        CalendarCellCircle(
            color: Colors.exercise,
            diameter: (diameterProper - widthProper) * 0.85,
            width: width * 0.8,
            value: exercise),
        CalendarCellCircle(
            color: Colors.nutrition,
            diameter: (diameterProper - widthProper * 2) * 0.75,
            width: width * 0.8,
            value: nutrition)
      ]);
}

class CalendarCellCircle extends StatelessWidget {
  final Color color;
  final double diameter;
  final double width;
  final double value;

  CalendarCellCircle({@required this.color,
    @required this.diameter,
    @required this.width,
    this.value});

  @override
  Widget build(_) =>
      CustomPaint(
          size: M.Size(diameter, diameter),
          painter: SectorPainter(
              background: true,
              color: color,
              width: width,
              startAngle: -pi / 2,
              endAngle: value * 2 * pi));
}

