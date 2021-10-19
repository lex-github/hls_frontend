import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/screens/stats/active_tab.dart';
import 'package:hls/screens/stats/diet_tab.dart';
import 'package:hls/screens/stats/mode_tab.dart';
import 'package:hls/theme/styles.dart';

class StatsTabBar extends StatelessWidget {
//Warning get all data!!
  final _date = Get.arguments;

  Widget _buildTabs() => DefaultTabController(
      length: 3,
      child: Screen(
          height: Size.bar + 2 * Size.verticalMedium + Size.font,
          padding: Padding.zero,
          shouldShowDrawer: true,
          title: _date,
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
              children: [ModeTab(), DietTab(), ActiveTab()])));

  @override
  Widget build(_) => _buildTabs();
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
