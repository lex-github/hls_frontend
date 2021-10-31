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
import 'package:hls/models/stats_model.dart';
import 'package:hls/theme/styles.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar<Controller extends StatsController> extends GetView<Controller> {
  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 7;

  // Future<bool> toggle({DateTime fromDate, DateTime toDate}) async {
  //   // lastToggledType.value = type;
  //   final result = await AuthService.i.getSchedule(fromDate: DateTime(2021, 7, 1), toDate: toDate);
  //   print('"RESULT" $result');
  //   // print('"RESPONSE" $response');    // if (result) if (isSelected(type))
  //   //   selected.remove(type);
  //   // else
  //   //   selected.add(type);
  //   return result;
  // }

  // Future toggle({DateTime fromDate, DateTime toDate}) async {
  //   final response = await controller.getSchedule();
  //
  //
  //   print('"RESULT" $response');
  //   // return (response as List)
  //   //     .map((p) => Post.fromJson(p))
  //   //     .toList();
  // }

  // Future<UserData> retrieve() async {
  //   if (SettingsService.i.token.isNullOrEmpty) return null;
  //
  //   final data =
  //   await query(currentUserQuery, fetchPolicy: FetchPolicy.networkOnly);
  //
  //   //print('AuthService.retrieve $data');
  //
  //   if (data.isNullOrEmpty) {
  //     await logout();
  //     return null;
  //   }
  //
  //   profile = UserData.fromJson(data.get('currentUser'));
  //   isAuthenticated = (profile?.id ?? 0) > 0;
  //
  //   if (isAuthenticated) {
  //     PushNotificationsManager().setUserId(profile.id);
  //
  //     FlutterNativeTimezone.getLocalTimezone().then((timezone) =>
  //     profile.timezone != timezone
  //         ? mutation(usersSetTimezoneMutation,
  //         parameters: {'timezone': timezone})
  //         : null);
  //   }
  //
  //   return profile;
  // }

  // builders

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

  Widget _prioritizedBuilder(_, DateTime day, DateTime focusedDay) {
    // print("Calendar._prioritizedBuilder day: $day focused: $focusedDay");
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);
    double val = 0;
    int date = 0;

    if (day.isBefore(firstDay) || day.isAfter(lastDay)) return Nothing();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VerticalSmallSpace(),
          TextPrimaryHint(day.day.toString()),
          VerticalSmallSpace(),
          CalendarCell(
              diameter: diameter, width: Size.horizontalTiny, value: val)
        ]);
  }

  // Widget _buildCategoryItem (StatsScheduleEatings eatings) =>
  // Container(
  //   child: TextSecondary(eatings.scheduleItem.kind),
  // );

  // Widget _buildCategoryListItem(StatsData stats) =>
  //     GetBuilder<StatsController>(
  //       init: StatsController(
  //           fromDate: DateTime.now().subtract(90.days).toString(),
  //           toDate: DateTime.now().toString()), builder: (_) =>
  //         ListView.builder(
  //             padding: EdgeInsets.fromLTRB(
  //                 Size.horizontal, Size.verticalMedium,
  //                 Size.horizontal, Size.vertical),
  //             itemCount: controller.stats.length * 2 - 1,
  //             itemBuilder: (_, i) {
  //               //if (i == 0) return _buildHeader();
  //               if (i.isOdd) return VerticalMediumSpace();
  //
  //               final index = i ~/ 2;
  //
  //               return _buildCategoryItem(stats.eatings[index]);
  //             }),
  //     );

  @override
  Widget build(_) =>
      Container(
        // height: 300,
        // width: 200,
          child:
          // GetBuilder<StatsController>(
          //   init: StatsController(
          //       fromDate: DateTime.now().subtract(90.days).toString(),
          //       toDate: DateTime.now().toString()), builder: (_) =>
          //     ListView.builder(
          //         padding: EdgeInsets.fromLTRB(
          //             Size.horizontal, Size.verticalMedium,
          //             Size.horizontal, Size.vertical),
          //         itemCount: controller.stats.length * 2 - 1,
          //         itemBuilder: (_, i) {
          //           //if (i == 0) return _buildHeader();
          //           if (i.isOdd) return VerticalMediumSpace();
          //
          //           final index = i ~/ 2;
          //
          //           return _buildCategoryListItem(controller.stats[index]);
          //         }),

            GetBuilder<StatsController>(
                init: StatsController(
                    fromDate: DateTime.now().subtract(90.days).toString(),
                    toDate: DateTime.now().toString()),
                builder: (_) => TableCalendar(
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
                      findLoop(controller.stats, selectedDay);
                      // toggle(fromDate: selectedDay, toDate: selectedDay);
                    },
                    focusedDay: DateTime.now(),
                    calendarBuilders: CalendarBuilders(
                        // singleMarkerBuilder: ,
                        headerTitleBuilder: _headerBuilder,
                        // dowBuilder: (_, day) {
                        //   if (day.weekday == DateTime.friday) {
                        //     final text = DateFormat.E().format(day);
                        //     return Center(
                        //       child: Text(
                        //         text,
                        //         // style: TextStyle(color: Colors.red),
                        //       ),
                        //     );
                        //   }
                        // },

                        dowBuilder: _dowBuilder,
                        //outsideBuilder: _outsideBuilder,
                        //defaultBuilder: _defaultBuilder,
                        prioritizedBuilder: _prioritizedBuilder
                        //     (_, currentDay, focusedDay) {
                        //   final firstDay =
                        //       DateTime(focusedDay.year, focusedDay.month, 1);
                        //   final lastDay =
                        //       DateTime(focusedDay.year, focusedDay.month + 1, 1);
                        //   double val = 0;
                        //   var count;
                        //
                        //   for(count; controller.stats.length > count; count++ ){
                        //     if(controller.stats[count].date == )
                        //   }
                        //   if (currentDay.isBefore(firstDay) ||
                        //       currentDay.isAfter(lastDay)) return Nothing();
                        //   // if (currentDay.weekday == DateTime.friday) {
                        //   //   final text = DateFormat.E().format(currentDay);
                        //   //   return Center(
                        //   //     child: Text(
                        //   //       text,
                        //   //       // style: TextStyle(color: Colors.red),
                        //   //     ),
                        //   //   );
                        //   // }
                        //
                        //   // return () {
                        //   //   final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
                        //   // final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);
                        //   // double val = 0;
                        //   // int date = 0;
                        //   //
                        //   // if (day.isBefore(firstDay) || day.isAfter(lastDay)) return Nothing();
                        //   //
                        //   // return Column(
                        //   //     mainAxisAlignment: MainAxisAlignment.center,
                        //   //     crossAxisAlignment: CrossAxisAlignment.center,
                        //   //     children: [
                        //   //       VerticalSmallSpace(),
                        //   //       TextPrimaryHint(day.day.toString()),
                        //   //       VerticalSmallSpace(),
                        //   //       CalendarCell(
                        //   //           diameter: diameter, width: Size.horizontalTiny, value: val)
                        //   //     ])};
                        //
                        //   return Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         VerticalSmallSpace(),
                        //         TextPrimaryHint(currentDay.day.toString()),
                        //         VerticalSmallSpace(),
                        //         CalendarCell(
                        //             diameter: diameter,
                        //             width: Size.horizontalTiny,
                        //             value: val)
                        //       ]);
                        //   // return Center(
                        //   //   child: Text(
                        //   //     text,
                        //   //     // style: TextStyle(color: Colors.red),
                        //   //   ),
                        //   // );
                        // },
                        // prioritizedBuilder: _prioritizedBuilder
                        ))),
          );
          }

          class CalendarCell extends StatelessWidget {
      final double width;
      final double diameter;
      final double value;

      CalendarCell(
      {@required this.width, @required this.diameter, @required this.value});

      double get diameterProper => diameter - width;

      double get widthProper => width * 2.5;

      @override
      Widget build(_) => Stack(alignment: Alignment.center, children: [
      CalendarCellCircle(
      color: Colors.macroStatistical,
      diameter: diameterProper * 0.9,
      width: width * 0.8,
      value: Random().nextDouble()),
      CalendarCellCircle(
      color: Colors.exercise,
      diameter: (diameterProper - widthProper) * 0.85,
      width: width * 0.8,
      value: Random().nextDouble()),
      CalendarCellCircle(
      color: Colors.nutrition,
      diameter: (diameterProper - widthProper * 2) * 0.75,
      width: width * 0.8,
      value: Random().nextDouble())
      ]);
      }

          class CalendarCellCircle extends StatelessWidget {
      final Color color;
      final double diameter;
      final double width;
      final double value;

      CalendarCellCircle(
      {@required this.color,
      @required this.diameter,
      @required this.width,
      this.value});

      @override
      Widget build(_) => CustomPaint(
      size: M.Size(diameter, diameter),
      painter: SectorPainter(
      background: true,
      color: color,
      width: width,
      startAngle: -pi / 2,
      endAngle: value * 2 * pi));
      }

          void findLoop(List<StatsData> stats, DateTime day) {
  for (var i = 0; i < stats.length; i++) {
  if (stats[i].date == dateToString(date: day, output: dateInternalFormat)) {
  Get.toNamed(statsTabRoute, arguments: {'index': i, 'date': day});
  }
  }

  Get.toNamed(statsTabRoute, arguments: {'date': day, 'index': null});
  }
