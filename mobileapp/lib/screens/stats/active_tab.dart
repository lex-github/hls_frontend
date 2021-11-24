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
  final int index;
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

    if (controller.stats[index].scheduleTrainings[i].training.trainingCategory
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
                            .stats[index]
                            .scheduleTrainings[i]
                            .training
                            .trainingCategory
                            .title),
                      ],
                    ),
                    isButton
                        ? Row(
                            children: [
                              TextSecondary(controller
                                  .stats[index]
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
                              controller.stats[index].scheduleTrainings[i]
                                          .training.inputData.length >
                                      2
                                  ? TextSecondary(controller
                                      .stats[index]
                                      .scheduleTrainings[i]
                                      .training
                                      .inputData[2]
                                      .step
                                      .toString())
                                  : TextSecondary(controller
                                      .stats[index]
                                      .scheduleTrainings[i]
                                      .training
                                      .inputData[0]
                                      .step
                                      .toString()),
                              HorizontalSmallSpace(),
                              controller.stats[index].scheduleTrainings[i]
                                          .training.inputData.length >
                                      2
                                  ? TextSecondary(controller
                                      .stats[index]
                                      .scheduleTrainings[i]
                                      .training
                                      .inputData[2]
                                      .unit
                                      .toString())
                                  : TextSecondary(controller
                                      .stats[index]
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



          if (controller.stats[index].scheduleTrainings.length != null) {
            for (int j = 0;
                j < controller.stats[index].scheduleTrainings.length;
                j++) {
              if (controller.stats[index].scheduleTrainings[j].training
                  .trainingCategory.title.isNotEmpty) {
                if (controller.stats[index].scheduleTrainings[j].training
                    .trainingCategory.title.isNotEmpty && controller.stats[index].scheduleTrainings[j].training
                        .trainingCategory.title ==
                    "Моцион") {
                  count++;
                  for(int i = 0; i < controller.stats[index].scheduleTrainings[j].training.inputData.length; i++){
                    mocion = mocion + (controller.stats[index].scheduleTrainings[j].training.inputData[i].step/controller.stats[index].scheduleTrainings[j].training.inputData[i].max)*100;
                  }
                }
                if (controller.stats[index].scheduleTrainings[j].training
                    .trainingCategory.title.isNotEmpty && controller.stats[index].scheduleTrainings[j].training
                        .trainingCategory.title ==
                    "Тренировки со снарядами") {
                  count++;
                  for(int i = 0; i < controller.stats[index].scheduleTrainings[j].training.inputData.length; i++){
                    training = training + (controller.stats[index].scheduleTrainings[j].training.inputData[i].step/controller.stats[index].scheduleTrainings[j].training.inputData[i].max)*100;
                  }
                }
                //
                // if(controller.stats[index].scheduleTrainings[j].training
                //     .trainingCategory.title.isNotEmpty && controller.stats[index].scheduleTrainings[j].training
                //     .trainingCategory.title != "Моцион" && controller.stats[index].scheduleTrainings[j].training
                //     .trainingCategory.title != "Тренировки со снарядами"){
                //s


                if (controller.stats[index].scheduleTrainings[j].training
                    .trainingCategory.title.isNotEmpty && controller.stats[index].scheduleTrainings[j].training
                    .trainingCategory.title !=
                    "Тренировки со снарядами" && controller.stats[index].scheduleTrainings[j].training
                    .trainingCategory.title !=
                    "Моцион") {
                  for(int i = 0; i < controller.stats[index].scheduleTrainings[j].training.inputData.length; i++){

                    additional = additional + (controller.stats[index].scheduleTrainings[j].training.inputData[i].step/controller.stats[index].scheduleTrainings[j].training.inputData[0].max)*100;





                  }
                }


                // }

                print(additional.toString());



                // training[c] = j;
                // c++;
              }
            }
          }
          return Column(
            children: [
              StatsCell(diameter: diameter, width: Size.horizontalTiny, mocion: mocion, training: training, additional: additional),
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

  @override
  Widget build(_) =>       index == null || controller.stats[index].scheduleTrainings.isEmpty ? Nothing() :
  GetBuilder<StatsController>(builder: (_) {
        int c = 0;
        var training = List<int>.filled(
            controller.stats[index].scheduleTrainings.length, 0);

        if (controller.stats[index].scheduleTrainings.length != null) {
          for (int j = 0;
              j < controller.stats[index].scheduleTrainings.length;
              j++) {
            if (controller.stats[index].scheduleTrainings[j].training
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

                Container(
                  width: width,
                  height: height * (c / 2),
                  child: ListView.builder(
                      itemCount: c,
                      itemBuilder: (_, index) {
                        final i = training[index];

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: Size.horizontal * 0.5),
                          child: _buildButton(i),
                        );
                      }),
                ),

                // VerticalSpace(),
                // _buildButton(
                //     title: "С гантелями",
                //     count: "0,2 ч",
                //     isButton: true,
                //     icon: Icons.bookmark),
                // VerticalSpace(),
                // _buildButton(
                //     title: "Зарядка",
                //     count: "0,2 ч",
                //     isButton: false,
                //     icon: Icons.assignment_ind_outlined),
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

  StatsCell({@required this.width, @required this.diameter, @required this.mocion, @required this.training, @required this.additional});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) => Stack(alignment: Alignment.center, children: [
        StatsCellCircle(
            color: Colors.exercise,
            diameter: diameterProper,
            width: width,
            value: mocion/100),
        StatsCellCircle(
            color: Colors.schedule,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: training/100),
        StatsCellCircle(
            color: Colors.primary,
            diameter: diameterProper - widthProper * 8,
            width: width,
            value: additional/100)
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
