import 'dart:math';

import 'package:flutter/material.dart' as M;
import 'package:flutter/material.dart' hide Colors, Padding, Icon;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/theme/styles.dart';

class ActiveTab extends StatelessWidget {
  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 2;

  final List items = ['title'];

  Widget spacer() => SizedBox(
        width: Size.horizontal * 0.3,
      );

  Widget _buildButton(
          {String title, String count, IconData icon, bool isButton}) =>
      Button(
          padding: Padding.zero,
          borderColor: Colors.disabled,
          onPressed: isButton ? () => Get.toNamed(exerciseResultRoute) : null,
          child: Column(children: [
            VerticalSmallSpace(),
            Container(
                height: Size.iconBig,
                padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container(height: Size.iconBig),
                      Row(
                        children: [
                          Icon(icon),
                          HorizontalSmallSpace(),
                          TextPrimaryHint(title),
                        ],
                      ),
                      isButton
                          ? Row(
                              children: [
                                TextSecondary(count),
                                Icon(Icons.keyboard_arrow_right,
                                    color: Colors.darkText),
                              ],
                            )
                          : TextSecondary(count),
                      // Expanded(child: HorizontalSpace()),
                    ])),
            VerticalSmallSpace()
          ]));

  Widget _buildStatsTitle({int percent, String title, Color indicatorColor}) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Size.horizontal * 0.6,
                height: Size.border * 2,
                color: indicatorColor,
              ),
              spacer(),
              TextPrimary(percent.toString() + "%"),
            ],
          ),
          spacer(),
          TextSecondary(title),
        ],
      );

  Widget _buildStatsContainer() => Column(
        children: [
          StatsCell(diameter: diameter, width: Size.horizontalTiny),
          VerticalSpace(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Моцион",
                    indicatorColor: Colors.exercise,
                  ),
                  VerticalMediumSpace(),
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Тренировка",
                    indicatorColor: Colors.schedule,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Доп. \nактивность",
                    indicatorColor: Colors.primary,
                  ),
                  // VerticalMediumSpace(),
                  // _buildStatsTitle(
                  //   percent: Randome().nextInt(100).toString(),
                  //   title: "Калории",
                  //   indicatorColor: Colors.nutrition,
                  // ),
                ],
              ),
            ],
          ),
        ],
      );

  @override
  Widget build(_) => Container(
        padding: EdgeInsets.all(Size.horizontalBig),
        color: Colors.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStatsContainer(),
              VerticalSpace(),
              _buildButton(
                  title: "Моцион",
                  count: "3 445 шагов",
                  isButton: false,
                  icon: Icons.info_outline_rounded),
              VerticalSpace(),
              _buildButton(
                  title: "С гантелями",
                  count: "0,2 ч",
                  isButton: true,
                  icon: Icons.bookmark),
              VerticalSpace(),
              _buildButton(
                  title: "Зарядка",
                  count: "0,2 ч",
                  isButton: false,
                  icon: Icons.assignment_ind_outlined),
            ],
          ),
        ),
      );
}

class StatsCell extends StatelessWidget {
  final double width;
  final double diameter;

  StatsCell({@required this.width, @required this.diameter});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) => Stack(alignment: Alignment.center, children: [
        StatsCellCircle(
            color: Colors.exercise,
            diameter: diameterProper,
            width: width,
            value: Random().nextDouble()),
        StatsCellCircle(
            color: Colors.schedule,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: Random().nextDouble()),
        StatsCellCircle(
            color: Colors.primary,
            diameter: diameterProper - widthProper * 8,
            width: width,
            value: Random().nextDouble())
      ]);
}

class StatsCellCircle extends StatelessWidget {
  final Color color;
  final double diameter;
  final double width;
  final double value;

  StatsCellCircle(
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
