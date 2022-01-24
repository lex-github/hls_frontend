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
  final width = Get.width;
  final height = Get.height;

  UserData get profile => AuthService.i?.profile;

  UserDailyData get profileDaily => profile?.daily;

  ScheduleData get schedule => AuthService.i.profile.schedule;
  final String index;
  final int dayId;
  final DateTime date;

  ModeTab({@required this.index, this.date, this.dayId});

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
        init: StatsController(),
        builder: (_) {
          // controller.getMode(index);
          return controller.stats == null
              ? Container(
                  padding: EdgeInsets.all(Size.horizontalBig),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildIndicator(
                          // date: index.toString(),
                          //   asleepTime: index == null ? "00:00" : controller.stats[index].eatings[0].scheduleItem.kind,

                          asleepTime: "00 ч 00 мин",
                          value: 0),
                    ],
                  ),
                )
              : Container(
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
                              : controller.stats.sleepDuration.toString() +
                                  " ч 00 мин",
                          value: index == null
                              ? 0
                              : controller.stats.sleepDuration > 8
                                  ? 1
                                  : controller.calendar[dayId].daily.schedule /
                                      100),
                      Container(
                        width: width,
                        height:
                            height * (controller.stats.sleepReport.length / 12),
                        child: ListView.builder(
                          itemCount: controller.stats.sleepReport.length,
                          itemBuilder: (_, int i) {
                            return TextSecondary(
                                controller.stats.sleepReport[i].toString());
                          },
                        ),
                      ),
                    ],
                  ),
                );
        });
}
