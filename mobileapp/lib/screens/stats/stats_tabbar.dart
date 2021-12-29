import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/screens/stats/active_tab.dart';
import 'package:hls/screens/stats/diet_tab.dart';
import 'package:hls/screens/stats/mode_tab.dart';
import 'package:hls/theme/styles.dart';
import 'package:intl/intl.dart';

class StatsTabBar<Controller extends StatsController>
    extends GetView<Controller> {
  String index;
  int dayId;
  final DateTime date;
  final bool isDay;

  StatsTabBar()
      : index = (Get.arguments as Map).get('index'),
        date = (Get.arguments as Map).get('date'),
        dayId = (Get.arguments as Map).get('dayId'),
        isDay = (Get.arguments as Map).get('isDay');

  Widget _buildTabs(String i, int id) {
    if (i != "null") {
      index = i;
      dayId = id;
    }


    return GetBuilder<StatsController>(
      init:             StatsController(id : "331"),

      builder: (_) =>
      controller.stats == null
          ? Center(child: Loading())
          :
        DefaultTabController(
              length: 3,
              child: Screen(
                  height: Size.bar + 2 * Size.verticalMedium + Size.font,
                  padding: Padding.zero,
                  shouldShowDrawer: true,
                  title: DateFormat.yMMMd('ru_RU').format(date).capitalize,
                  bottom: TabBar(
                      indicatorPadding:
                          EdgeInsets.symmetric(horizontal: Size.horizontal),
                      indicatorColor: Colors.primary,
                      labelPadding: Padding.medium,
                      labelStyle: TextStyle.primary,
                      labelColor: Colors.primaryText,
                      unselectedLabelStyle: TextStyle.primary,
                      //unselectedLabelColor: Colors.secondaryText,
                      tabs: [
                        Text(modeTitle),
                        Text(nutritionTitle),
                        Text(exerciseTitle)
                      ]),
                  child: TabBarView(
                      //physics: NeverScrollableScrollPhysics(),
                      children: [
                        ModeTab(index: index, dayId: dayId, date: date),
                        DietTab(index: index, date: date),
                        ActiveTab(index: index, date: date)
                      ]))),
    );
  }

  @override
  Widget build(_) => GetBuilder<StatsController>(
    init:
            StatsController(id : "331"),
        builder: (_) {
          {

            if (isDay && isDay != null) {
              if (controller.calendar != null) {
                for (var i = 0; i < controller.calendar.length; i++) {
                  if (controller.calendar[i].date ==
                      dateToString(
                          date: DateTime.now(), output: dateInternalFormat)) {
                    controller.getSchedule(controller.calendar[i].scheduleId);

                    _buildTabs(controller.calendar[i].scheduleId, i);
                  }
                }
              } else {
                LoadingPage();
              }
            }
            controller.getSchedule(index);

            return _buildTabs("null",0);
          }
        },
      );
}

// Controller to change color indicator in tabBar

// class IndicatorController extends GetxController {
//   final colors = [Colors.primary, Colors.macroHLS, Colors.macroStatistical];
//   Color indicatorColor;
//   TabController _controller;
//   TickerProvider provider;
//
//   @override
//   void onInit() { // called immediately after the widget is allocated memory
//     _controller = TabController(length: 3, vsync: provider)
//       ..addListener(() {
//         indicatorColor = colors[_controller.index];
//       });
//     indicatorColor = colors[0];
//     super.onInit();
//   }  // builders
// }
