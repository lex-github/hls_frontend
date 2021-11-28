import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/models/schedule_model.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ModeTab<Controller extends StatsController> extends GetView<Controller> {
  final DateTime _date = DateTime.now();

  UserData get profile => AuthService.i?.profile;

  UserDailyData get profileDaily => profile?.daily;

  ScheduleData get schedule => AuthService.i.profile.schedule;
  final int index;
  final DateTime date;

  ModeTab({@required this.index, this.date});

  // final schedule = AuthService.i.profile.schedule;

  // Future<bool> onSubmitRequest() async => AuthService.i.getSchedule(fromDate: DateTime(2021, 7, 1), toDate: DateTime(2021, 9, 1));

  Widget _buildIndicator({String asleepTime, double value}) => Container(
        padding: EdgeInsets.all(Size.horizontal),
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: TitleCircularProgress(
            color: Colors.primary,
            value: value,
            size: Size.vertical * 10,
            border: Size.borderRadius * 3,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextPrimary(
                asleepTime,
                size: Size.horizontal * 1.3,
              ),
              // TextPrimary(
              //   schedule.asleepTime.toString(),
              //   size: Size.fontSmall,
              // )
            ])),
      );

  @override
  Widget build(_) => GetBuilder<StatsController>(
        init: StatsController(
            fromDate: DateTime.now().toString(),
            toDate: DateTime.now().toString()),
        builder: (_) => Container(
          padding: EdgeInsets.all(Size.horizontalBig),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIndicator(
                  // date: index.toString(),
                  //   asleepTime: index == null ? "00:00" : controller.stats[index].eatings[0].scheduleItem.kind,

                  asleepTime: index == null
                      ? "00 ч 00 мин"
                      : controller.stats[index].sleepDuration.toString() +
                          " ч 00 мин",
                  value: index == null
                      ? 0
                      : controller.stats[index].sleepDuration > 8 ? 1 : controller.calendar[index].daily.schedule / 100),
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
        ),
      );
}
