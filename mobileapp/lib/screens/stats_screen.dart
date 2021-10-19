import 'package:flutter/material.dart'
    hide Card, Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:hls/components/calendar.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:get/get.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/theme/styles.dart';

class StatsScreen extends StatelessWidget {
  // builders

  Widget _buildCalendarTiles({String title, Color color}) => Row(
        children: [
          Container(
            height: 3,
            width: 10,
            color: color,
          ),
          SizedBox(
            width: 8,
          ),
          TextSecondary(title),
        ],
      );

  Widget _buildCalendar() => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: statsScreenTitle,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // _buildCalendarItems(),
            Container(
              padding: EdgeInsets.symmetric(vertical: Size.vertical * 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCalendarTiles(
                    title: dreamTitle, color: Colors.macroStatistical),
                _buildCalendarTiles(
                    title: exerciseTitle, color: Colors.macroHLS),
                _buildCalendarTiles(
                    title: nutritionTitle, color: Colors.nutrition),
              ],
            ),
            Calendar(),
            VerticalSpace(),
          ],
        ),
      ));

  @override
  Widget build(_) => _buildCalendar();
}
