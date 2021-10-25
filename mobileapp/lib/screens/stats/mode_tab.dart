import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:hls/components/generic.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';
import 'package:intl/intl.dart';

class ModeTab extends StatelessWidget {
  final DateTime _date = DateTime.now();
  UserData get profile => AuthService.i?.profile;
  UserDailyData get profileDaily => profile?.daily;
  final schedule = AuthService.i.profile.schedule;


  Widget _buildIndicator({String date, double value}) => Container(
        padding: EdgeInsets.all(Size.horizontal),
        decoration:
            BoxDecoration(color: Colors.background, shape: BoxShape.circle),
        child: TitleCircularProgress(
            color: Colors.primary,
            value: value,
            size: Size.vertical * 10,
            border: Size.borderRadius * 3,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextPrimary(
                date,
                size: Size.fontPercent,
              ),
              TextPrimary(
                schedule.asleepTime.toString(),
                size: Size.fontSmall,
              )
            ])),
      );

  @override
  Widget build(_) => Container(
        padding: EdgeInsets.all(Size.horizontalBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIndicator(
                date: DateFormat.Hm('ru_RU').format(_date),
                value: profileDaily.schedule.clamp(0, 100) / 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSecondary("Необходимо пересмотреть свой график сна"),
                SizedBox(
                  height: Size.vertical,
                ),
                TextSecondary(
                    "7-9 часов - диапазон нормы сна для человека. Сон в соответствующей зоне циркадных часов является самым оптимальным, поскольку не сбивает ритм гормональных часов организма и не создаёт гормонального конфликта между зонами активности и пассивности"),
              ],
            ),
          ],
        ),
      );
}
