import 'dart:math';

import 'package:flutter/material.dart' as M;
import 'package:flutter/material.dart' hide Colors, Padding, Icon;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/theme/styles.dart';

class ActiveTab<Controller extends StatsController>
    extends GetView<Controller> {
  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 2;
  final String index;
  final DateTime date;

  ActiveTab({@required this.index, this.date});

  final List items = ['title'];
  final width = Get.width;
  final height = Get.height;

  Widget spacer() => SizedBox(
        width: Size.horizontal * 0.3,
      );

  Widget _buildButton(int i) {
    bool isButton = false;

    if (controller.stats.scheduleTrainings[i].training.trainingCategory
            .title ==
        "Тренировки со снарядами") {
      isButton = true;
    }


    return Button(
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
                        // Icon(icon),
                        HorizontalSmallSpace(),
                        TextPrimaryHint(controller
                            .stats
                            .scheduleTrainings[i]
                            .training
                            .title),
                      ],
                    ),
                    isButton
                        ? Row(
                            children: [
                              TextSecondary(controller
                                  .stats
                                  .scheduleTrainings[i]
                                  .training
                                  .inputData[0]
                                  .unit
                                  .toString()),
                              Icon(Icons.keyboard_arrow_right,
                                  color: Colors.darkText),
                            ],
                          )
                        : Row(
                            children: [
                              controller.stats.scheduleTrainings[i]
                                          .training.inputData.length >
                                      2
                                  ? TextSecondary(controller
                                      .stats
                                      .scheduleTrainings[i].inputValue
                                      .toString())
                                  : TextSecondary(controller
                                      .stats
                                      .scheduleTrainings[i].inputValue
                                      .toString()),
                              HorizontalSmallSpace(),
                              controller.stats.scheduleTrainings[i]
                                          .training.inputData.length >
                                      2
                                  ? TextSecondary(controller
                                      .stats
                                      .scheduleTrainings[i]
                                      .training
                                      .inputData[2]
                                      .unit
                                      .toString())
                                  : TextSecondary(controller
                                      .stats
                                      .scheduleTrainings[i]
                                      .training
                                      .inputData[0]
                                      .unit
                                      .toString()),
                            ],
                          ),
                    // Expanded(child: HorizontalSpace()),
                  ])),
          VerticalSmallSpace()
        ]));
  }

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

  Widget _buildStatsContainer() => GetBuilder<StatsController>(
        builder: (_) {
          // int c = 0;
          // var training = List<int>.filled(
          //     controller.stats[index].scheduleTrainings.length, 0);

          double mocion = 0;
          double training = 0;
          double additional = 0;
          int count = 0;

          if (index != null && controller.stats.activityRating != null) {
            mocion = controller.stats.activityRating.motionRating;
            training = controller.stats.activityRating.trainingRating;
            additional =
                controller.stats.activityRating.activeLeisureRating;
          }

          return Column(
            children: [
              StatsCell(
                  diameter: diameter,
                  width: Size.horizontalTiny,
                  mocion: mocion,
                  training: training,
                  additional: additional),
              VerticalSpace(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsTitle(
                        percent: mocion.toInt(),
                        title: "Моцион",
                        indicatorColor: Colors.exercise,
                      ),
                      VerticalMediumSpace(),
                      _buildStatsTitle(
                        percent: training.toInt(),
                        title: "Тренировка",
                        indicatorColor: Colors.schedule,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsTitle(
                        percent: additional.toInt(),
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
        },
      );


  Widget _stepsContainer () {
    return Column(
      children: [
        Button(
        padding: Padding.zero,
        borderColor: Colors.disabled,
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
                        // Icon(icon),
                        HorizontalSmallSpace(),
                        TextPrimaryHint("Моцион"),
                      ],
                    ),
                    Row(
                      children: [
                        TextSecondary(controller
                            .stats.stepsQuantity.toString()),
                        HorizontalSmallSpace(),
                        TextSecondary("щаг(ов)")
                      ],
                    ),
                    // Expanded(child: HorizontalSpace()),
                  ])),
          VerticalSmallSpace()
        ])),
        SizedBox(
          height: Size.horizontal * 0.5,
        ),
      ],
    );
  }

  @override
  Widget build(_) =>
controller.stats.scheduleTrainings.isEmpty
          ? Column(
              children: [
                VerticalSpace(),
                _buildStatsContainer(),
                Container(
                  padding: EdgeInsets.all(Size.horizontalBig),
                  child: (controller.stats.stepsQuantity != null && controller.stats.stepsQuantity != 0) ? _stepsContainer() : SizedBox(),
                ),


              ],
            )
          :
      GetBuilder<StatsController>(builder: (_) {
              int c = 0;
              var training = List<int>.filled(
                  controller.stats.scheduleTrainings.length, 0);

              if (controller.stats.scheduleTrainings.length != null) {
                for (int j = 0;
                    j < controller.stats.scheduleTrainings.length;
                    j++) {
                  if (controller.stats.scheduleTrainings[j].training
                      .trainingCategory.title.isNotEmpty) {
                    training[c] = j;
                    c++;
                  }
                }
              }

              return Container(
                padding: EdgeInsets.all(Size.horizontalBig),
                color: Colors.background,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildStatsContainer(),
                      VerticalSpace(),
                      (controller.stats.stepsQuantity != null && controller.stats.stepsQuantity != 0) ? _stepsContainer() : SizedBox(),
                      Container(
                        width: width,
                        height: height * (c / 2),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: c,
                            itemBuilder: (_, index) {
                              final i = training[index];
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Size.horizontal * 0.5),
                                child: controller.stats.scheduleTrainings[i].training.trainingCategory
                                    .title ==
                                    "Моцион" ? SizedBox() : _buildButton(i),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            });
}

class StatsCell extends StatelessWidget {
  final double width;
  final double diameter;
  final double mocion;
  final double training;
  final double additional;

  StatsCell(
      {@required this.width,
      @required this.diameter,
      @required this.mocion,
      @required this.training,
      @required this.additional});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) => Stack(alignment: Alignment.center, children: [
        StatsCellCircle(
            color: Colors.exercise,
            diameter: diameterProper,
            width: width,
            value: mocion / 100),
        StatsCellCircle(
            color: Colors.schedule,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: training / 100),
        StatsCellCircle(
            color: Colors.primary,
            diameter: diameterProper - widthProper * 8,
            width: width,
            value: additional / 100)
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
