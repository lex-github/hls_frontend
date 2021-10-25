import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/services/_graphql_service.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/services/settings_service.dart';
import 'package:hls/theme/styles.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {

  UserData get profile => AuthService.i?.profile;
  UserDailyData get profileDaily => profile?.daily;

  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 7;

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

  Widget _headerBuilder(_, DateTime day) => TextPrimary(
        DateFormat.yMMMM('ru_RU').format(day).capitalize,
        align: TextAlign.center,
        size: Size.fontBig,
      );

  Widget _dowBuilder(_, DateTime day) => Column(
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
          CalendarCell(diameter: diameter, width: Size.horizontalTiny, value: val)
        ]);
  }


  @override
  Widget build(_) => Container(
    padding: EdgeInsets.only(left: Size.horizontal * 0.5, right: Size.horizontal * 0.5, bottom: Size.horizontal * 0.5),
    child: TableCalendar(
        headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekHeight: Size.verticalSmall + Size.fontSmall,
        rowHeight: diameter + Size.verticalSmall * 2 + Size.fontSmall,
        locale: 'ru',
        firstDay: DateTime.now().subtract(90.days),
        lastDay: DateTime.now(),
        onDaySelected: (selectedDay, focusedDay) {
          Get.toNamed(statsTabRoute,
              arguments:
              DateFormat.yMMMd('ru_RU').format(selectedDay).capitalize);
        },
        focusedDay: DateTime.now(),
        calendarBuilders: CalendarBuilders(
          // singleMarkerBuilder: ,
            headerTitleBuilder: _headerBuilder,
            dowBuilder: _dowBuilder,
            //outsideBuilder: _outsideBuilder,
            //defaultBuilder: _defaultBuilder,
            prioritizedBuilder: _prioritizedBuilder
        )),
  );
}

class CalendarCell extends StatelessWidget {
  final double width;
  final double diameter;
  final double value;

  CalendarCell({@required this.width, @required this.diameter, @required this.value});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) => Stack(alignment: Alignment.center, children: [
        CalendarCellCircle(
            color: Colors.macroStatistical,
            diameter: diameterProper * 0.9,
            width: width * 0.8,
            value: value),
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
