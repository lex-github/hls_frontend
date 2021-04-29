import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/theme/styles.dart';

class ScheduleAddScreen extends GetView<ScheduleAddController> {
  // handlers

  // builders
  @override
  Widget build(_) => controller.isInit
      ? DefaultTabController(
          length: 2,
          child: Screen(
              height: Size.bar + 2 * Size.verticalMedium + Size.font,
              padding: Padding.zero,
              shouldShowDrawer: true,
              title: scheduleScreenTitle,
              trailing: Clickable(
                  onPressed: () => showConfirm(title: developmentText),
                  child: Image(title: 'icons/question')),
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
                    Text(scheduleNightTabTitle),
                    Text(scheduleDayTabTitle)
                  ]),
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(color: Colors.scheduleNight),
                    Container(color: Colors.scheduleDay)
                  ])))
      : Nothing();

  // @override
  // Widget build(_) => GetBuilder(
  //     init: ScheduleController(),
  //     builder: (_) => DefaultTabController(
  //         length: 2,
  //         child: Screen(
  //             height: Size.bar + 2 * Size.verticalMedium + Size.font,
  //             padding: Padding.zero,
  //             shouldShowDrawer: true,
  //             title: scheduleScreenTitle,
  //             trailing: Clickable(
  //                 onPressed: () => showConfirm(title: developmentText),
  //                 child: Image(title: 'icons/question')),
  //             bottom: TabBar(
  //                 indicatorPadding:
  //                     EdgeInsets.symmetric(horizontal: Size.horizontal),
  //                 indicatorColor: Colors.primary,
  //                 labelPadding: Padding.medium,
  //                 labelStyle: TextStyle.primary,
  //                 labelColor: Colors.primaryText,
  //                 unselectedLabelStyle: TextStyle.primary,
  //                 //unselectedLabelColor: Colors.secondaryText,
  //                 tabs: [
  //                   Text(scheduleNightTabTitle),
  //                   Text(scheduleDayTabTitle)
  //                 ]),
  //             child: TabBarView(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 children: [NightTab(), DayTab()]))));
}

class ScheduleAddController extends Controller
    with SingleGetTickerProviderMixin {
  bool get isInit => true;
}
