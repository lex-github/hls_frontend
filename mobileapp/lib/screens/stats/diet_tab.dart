import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' as M;
import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/theme/styles.dart';

class DietTab<Controller extends StatsController> extends GetView<Controller> {
  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 2;

  // final StatsController controller = Get.put(StatsController(
  //     fromDate: DateTime.now().subtract(90.days).toString(),
  //     toDate: DateTime.now().toString()));
  final width = Get.width;
  final height = Get.height;
  final int index;
  final DateTime date;
  int totalFats = 0;
  int totalCarbohydrates = 0;
  int totalProteins = 0;
  int totalEnergy = 0;

  DietTab({@required this.index, this.date});

  // final List eatings = controller.stats[3].eatings;

  Widget buildAccordion(String title, {String text, Widget child}) =>
      GetBuilder<StatsController>(
        init:
            StatsController(fromDate: date.toString(), toDate: date.toString()),
        builder: (_) {
          // print("kind: " + controller.stats[index].eatings[3].scheduleItem.kind.toString());
          // print("title: " + controller.stats[index].eatings[3].scheduleFood.title.toString());
          // print("portion: " + controller.stats[index].eatings[3].scheduleFood.portion.toString());
          // print("title: " + controller.stats[index].eatings[3].scheduleFood.structure[0].title.toString());
          // print("key: " + controller.stats[index].eatings[3].scheduleFood.structure[0].key.toString());
          // print("unit: " + controller.stats[index].eatings[3].scheduleFood.structure[0].unit.toString());
          // print("quantity: " + controller.stats[index].eatings[3].scheduleFood.structure[0].quantity.toString());
          // print("section: " + controller.stats[index].eatings[3].scheduleFood.structure[0].section.toString());

          return Button(
              padding: Padding.zero,
              borderColor: Colors.disabled,
              // onPressed: () => controller.getSchedule(),

              onPressed: () => controller.toggle("Ужин"),
              child: Column(children: [
                VerticalSmallSpace(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                    child: Row(children: [
                      Container(height: Size.iconBig),
                      TextPrimaryHint(title),
                      Expanded(child: HorizontalSpace()),
                      Obx(() => Transform.rotate(
                          angle: controller.getRotationAngle("Ужин"),
                          child: Icon(FontAwesomeIcons.chevronRight,
                              color: Colors.disabled, size: Size.iconSmall)))
                    ])),
                Obx(() => SizeTransition(
                    sizeFactor: controller.getSizeFactor("Ужин"),
                    child: Container(
                        padding: EdgeInsets.only(top: Size.vertical),
                        child: text.isNullOrEmpty
                            ? child ?? Nothing()
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Size.horizontal),
                                child: TextSecondary(text))))),
                VerticalSmallSpace()
              ]));
        },
      );

  Widget spacer() => SizedBox(
        width: Size.horizontal * 0.3,
      );

  Widget _buildStatsTitle({int percent, String title, Color indicatorColor}) =>
      Row(
        children: [
          Container(
            width: Size.horizontal * 0.6,
            height: Size.border * 2,
            color: indicatorColor,
          ),
          spacer(),
          TextPrimary(percent.toString() + "%"),
          spacer(),
          TextSecondary(title),
        ],
      );

  Widget _buildStatsContainer() {
    int carbohydrates = 0;
    int fats = 0;
    int proteins = 0;
    int energy = 0;
    if (controller.stats[index].eatings.length != null) {
      for (int j = 0; j < controller.stats[index].eatings.length; j++) {
        controller.stats[index].eatings[j].scheduleFood.title.toString();

        for (int d = 0;
            d <
                controller
                    .stats[index].eatings[j].scheduleFood.structure.length;
            d++) {
          if (controller
                  .stats[index].eatings[j].scheduleFood.structure[d].section ==
              "Углеводы") {
            carbohydrates = controller
                    .stats[index].eatings[j].scheduleFood.structure[d].quantity
                    .toInt() +
                carbohydrates;
          }
          if (controller
                  .stats[index].eatings[j].scheduleFood.structure[d].section ==
              "Жиры") {
            fats = controller
                    .stats[index].eatings[j].scheduleFood.structure[d].quantity
                    .toInt() +
                fats;
          }
          if (controller
                  .stats[index].eatings[j].scheduleFood.structure[d].section ==
              "Белки") {
            proteins = controller
                    .stats[index].eatings[j].scheduleFood.structure[d].quantity
                    .toInt() +
                proteins;
          }
          if (controller
                  .stats[index].eatings[j].scheduleFood.structure[d].section ==
              "Калорийность") {
            energy = controller
                    .stats[index].eatings[j].scheduleFood.structure[d].quantity
                    .toInt() +
                energy;
          }
        }
      }
    }
    totalFats = fats + totalFats;
    totalCarbohydrates = carbohydrates + totalCarbohydrates;
    totalEnergy = energy + totalEnergy;
    totalProteins = proteins + totalProteins;
    print("-------PPPP------: " + totalEnergy.toString());

    return Column(
      children: [
        StatsCell(
            diameter: diameter,
            width: Size.horizontalTiny,
            fatsValue: totalFats / 400,
            carbohydratesValue: totalCarbohydrates / 600,
            proteinsAndEnergyValue:
                (totalProteins / 800) + (totalEnergy / 600)),
        VerticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsTitle(
                  percent: ((totalEnergy / 600) * 100).toInt().isLowerThan(100)
                      ? ((totalEnergy / 600) * 100).toInt()
                      : 100,
                  title: "Калории",
                  indicatorColor: Colors.exercise,
                ),
                VerticalMediumSpace(),
                _buildStatsTitle(
                  percent:
                      ((totalProteins / 800) * 100).toInt().isLowerThan(100)
                          ? ((totalProteins / 800) * 100).toInt()
                          : 100,
                  title: "Белки",
                  indicatorColor: Colors.exercise,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsTitle(
                  percent: ((totalFats / 400) * 100).toInt().isLowerThan(100)
                      ? ((totalFats / 400) * 100).toInt()
                      : 100,
                  title: "Жиры",
                  indicatorColor: Colors.scheduleMainFood,
                ),
                VerticalMediumSpace(),
                _buildStatsTitle(
                  percent: ((totalCarbohydrates / 600) * 100)
                          .toInt()
                          .isLowerThan(100)
                      ? ((totalCarbohydrates / 600) * 100).toInt()
                      : 100,
                  title: "Углеводы",
                  indicatorColor: Colors.nutrition,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicator(
          {String section,
          Color color}) {

String title = "";
String unit = "";
double value = 0;
double upperLimit = 0;
double lowerLimit = 0;
int c = 0;

    final structure =
    List<int>.filled(controller.stats[index].components.length, 0);

    if (controller.stats[index].components.length != null) {
      for (int j = 0;
      j < controller.stats[index].components.length;
      j++) {



        if (section ==
            controller.stats[index].components[j].foodComponent.section
                .toString()) {
          // print('title$j:  ' + controller.stats[index].components[j].foodComponent.title);
          // print('unit$j:  ' + controller.stats[index].components[j].foodComponent.unit);
          // print('section$j:  ' + controller.stats[index].components[j].foodComponent.section);
          // print('value$j:  ' + controller.stats[index].components[j].value.toString());
          // print('upperLimit$j:  ' + controller.stats[index].components[j].upperLimit.toString());
          // print('lowerLimit$j:  ' + controller.stats[index].components[j].lowerLimit.toString());

          title = controller.stats[index].components[j].foodComponent.title;
          unit = controller.stats[index].components[j].foodComponent.unit;
          value = controller.stats[index].components[j].value;
          upperLimit = controller.stats[index].components[j].upperLimit;
          lowerLimit = controller.stats[index].components[j].lowerLimit;
          structure[c] = j;
          c++;
        }
      }
    }


// print('title:  ' + title);
// print('unit:  ' + unit);
// print('value:  ' + value.toString());
// print('upperLimit:  ' + upperLimit.toString());
// print('lowerLimit:  ' + lowerLimit.toString());2

int r = 0;
    return Container(
          width: width,
          height: height * (c / 18),
          child: ListView.builder(
            itemCount: c,
            itemBuilder: (_, index) {

              final i = structure[index];
              r++;


              // print('unit:  ' + controller.stats[index].components[structure[index]].foodComponent.unit);
              // print('section:  ' + controller.stats[index].components[structure[index]].foodComponent.section);
              // print('value:  ' + controller.stats[index].components[51].value.toString());
              // print('upperLimit:  ' + controller.stats[index].components[structure[index]].upperLimit.toString());
              // print('lowerLimit:  ' + controller.stats[index].components[structure[index]].lowerLimit.toString());
              //

              return _buildIndicator1(color, i);
            },
          ));}


          Widget _buildIndicator1 (Color color, int i){

            String title = controller.stats[index].components[i].foodComponent.title;
            String unit = controller.stats[index].components[i].foodComponent.unit;
            double value = controller.stats[index].components[i].value;
            double upperLimit = controller.stats[index].components[i].upperLimit;
            double lowerLimit = controller.stats[index].components[i].lowerLimit;

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: Size.horizontal,right: Size.horizontal, ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextSecondary(title),
                TextSecondary(value.toString() + " " + unit)
              ],
            ),
          ),
          VerticalSmallSpace(),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: Size.border * 2,
                width: width - Size.horizontal * 4,
                color: Colors.darkText,
              ),
              Container(
                height: Size.border * 2,
                width: ((width - Size.horizontal * 4) * (value/upperLimit > 1 ? 1 : value/upperLimit)).isNaN ? 0 : ((width - Size.horizontal * 4) * (value/upperLimit > 1 ? 1 : value/upperLimit)),
                color: color,
              ),
              Container(
                height: (Size.border * 7).isNaN ? 0 : Size.border * 7,
                width: (Size.border * 2).isNaN ? 0 : Size.border * 2,
                color: Colors.white,
                margin: EdgeInsets.only(
                    left: (width - Size.horizontal * 4) * (lowerLimit/upperLimit > 1 ? 1 : lowerLimit/upperLimit)).isNonNegative ? EdgeInsets.only(
                    left: (width - Size.horizontal * 4) * (lowerLimit/upperLimit > 1 ? 1 : lowerLimit/upperLimit)) : EdgeInsets.only(
                    left: 1),
              ),
               Container(
                height: (Size.border * 7).isNaN ? 0 : Size.border * 7,
                width: (Size.border * 2).isNaN ? 0 : Size.border * 2,
                color: Colors.white,
                margin: EdgeInsets.only(
                    left: (width - Size.horizontal * 4) * upperLimit/upperLimit).isNonNegative ? EdgeInsets.only(
                    left: (width - Size.horizontal * 4) * upperLimit/upperLimit) : EdgeInsets.only(
                    left: 1),
              ),
            ],
          ),
          VerticalSmallSpace(),
        ],
      ),
    );
          }

  Widget _buildCircleIndicator(
          {String title, int currentCount, int maxCount, Color color}) =>
      TitleCircularProgress(
          color: color,
          value: currentCount / maxCount,
          size: Size.vertical * 3,
          border: Size.border,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextPrimary(
                      '$currentCount/$maxCount',
                      size: Size.fontSmall * 0.9,
                    )
                  ],
                ),
                TextSecondary(
                  title,
                  size: Size.fontSmall * 0.7,
                )
              ]));

  Widget _buildFoodItem(List<int> foods, int i) => Container(
        padding: EdgeInsets.symmetric(
            horizontal: Size.horizontal, vertical: Size.vertical * 0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextPrimary(
              controller.stats[index].eatings[i].scheduleFood.title,
              size: Size.fontSmall,
            ),
            SizedBox(
              width: 100,
            ),
            TextSecondary(controller
                    .stats[index].eatings[i].scheduleFood.portion
                    .toString() +
                " гр")
          ],
        ),
      );

  Widget _buildFoodContainer({
    String kind,
  }) {
    int carbohydrates = 0;
    int fats = 0;
    int proteins = 0;
    int energy = 0;
    int c = 0;
    var foods = List<int>.filled(controller.stats[index].eatings.length, 0);

    if (controller.stats[index].eatings.length != null) {
      for (int j = 0; j < controller.stats[index].eatings.length; j++) {
        if (kind ==
            controller.stats[index].eatings[j].scheduleItem.kind.toString()) {
          controller.stats[index].eatings[j].scheduleFood.title.toString();

          for (int d = 0;
              d <
                  controller
                      .stats[index].eatings[j].scheduleFood.structure.length;
              d++) {
            if (controller.stats[index].eatings[j].scheduleFood.structure[d]
                    .section ==
                "Углеводы") {
              carbohydrates = controller.stats[index].eatings[j].scheduleFood
                      .structure[d].quantity
                      .toInt() +
                  carbohydrates;
            }
            if (controller.stats[index].eatings[j].scheduleFood.structure[d]
                    .section ==
                "Жиры") {
              fats = controller.stats[index].eatings[j].scheduleFood
                      .structure[d].quantity
                      .toInt() +
                  fats;
            }
            if (controller.stats[index].eatings[j].scheduleFood.structure[d]
                    .section ==
                "Белки") {
              proteins = controller.stats[index].eatings[j].scheduleFood
                      .structure[d].quantity
                      .toInt() +
                  proteins;
            }
            if (controller.stats[index].eatings[j].scheduleFood.structure[d]
                    .section ==
                "Калорийность") {
              energy = controller.stats[index].eatings[j].scheduleFood
                      .structure[d].quantity
                      .toInt() +
                  energy;
            }
          }

          // print(c);
          foods[c] = j;

          c++;

          // index = j;

          // foods = [{"title" : controller.stats[3].eatings[j].scheduleFood.title.toString()}];
          // foods = [{"portion" : controller.stats[3].eatings[j].scheduleFood.title.toString()}];
          // foods = [{"portion" : controller.stats[3].eatings[j].scheduleFood.portion.toString()}];
          // title = controller.stats[3].eatings[j].scheduleFood.title.toString();
          // portion = controller.stats[3].eatings[j].scheduleFood.portion.toString();
          // for (int i = 0; i < controller.stats[3].eatings[j].scheduleFood.structure.length; i++) {
          //   print("\n");
          //   print("title: " + controller.stats[3].eatings[j].scheduleFood.structure[i].title.toString());
          //   print("key: " + controller.stats[3].eatings[j].scheduleFood.structure[i].key.toString());
          //   print("unit: " + controller.stats[3].eatings[j].scheduleFood.structure[i].unit.toString());
          //   print("quantity: " +
          //       controller.stats[3].eatings[j].scheduleFood.structure[i].quantity.toString());
          //   print("section: " +
          //       controller.stats[3].eatings[j].scheduleFood.structure[i].section.toString());
          //   print("\n");
          // }
        }
      }
    }

    // print("tit1 " + controller.stats[3].eatings[foods[0]].scheduleFood.title.toString());
    // print("tit1 " + controller.stats[3].eatings[index].scheduleFood.title.toString());
    // print("por " + c.toString());
    //
    // totalFats = fats + totalFats;
    // totalCarbohydrates = carbohydrates + totalCarbohydrates;
    // totalEnergy = energy + totalEnergy;
    // totalProteins = proteins + totalProteins;

    return controller.stats[index].eatings.length == null || c < 1
        ? Nothing()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircleIndicator(
                    color: Colors.primary,
                    title: "углеводы",
                    currentCount: carbohydrates,
                    maxCount: 150,
                  ),
                  _buildCircleIndicator(
                    color: Colors.schedule,
                    title: "калории",
                    currentCount: energy,
                    maxCount: 150,
                  ),
                  _buildCircleIndicator(
                    color: Colors.scheduleMainFood,
                    title: "жиры",
                    currentCount: fats,
                    maxCount: 100,
                  ),
                  _buildCircleIndicator(
                    color: Colors.exercise,
                    title: "белки",
                    currentCount: proteins,
                    maxCount: 200,
                  ),
                ],
              ),
              VerticalSmallSpace(),
              Container(
                width: width,
                height: height * (c / 22),
                child: c == 1
                    ? _buildFoodItem(foods, 0)
                    : ListView.builder(
                        itemCount: c,
                        itemBuilder: (_, i) {
                          // c--;
                          final index = foods[i];

                          // index = j;

                          print(index);
                          return _buildFoodItem(foods, index);
                        },
                      ),
              ),
            ],
          );
  }

  @override
  Widget build(_) =>
      index == null || controller.stats[index].eatings.isNullEmptyFalseOrZero
          ? Nothing()
          : GetBuilder<StatsController>(
              builder: (_) {
                return Container(
                  color: Colors.background,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Size.horizontal),
                    child: Column(
                      children: [
                        _buildStatsContainer(),
                        VerticalBigSpace(),
                        buildAccordion("Завтрак",
                            child: _buildFoodContainer(
                              kind: "BREAKFAST",
                            )),
                        VerticalBigSpace(),
                        buildAccordion("Обед",
                            child: _buildFoodContainer(
                              kind: "LUNCH",
                            )),
                        VerticalBigSpace(),
                        buildAccordion("Ужин",
                            child: _buildFoodContainer(
                              kind: "DINNER",
                            )),
                        VerticalBigSpace(),
                        buildAccordion("Доп. приём 1 и/или  Доп. приём 2",
                            child: _buildFoodContainer(
                              kind: "SNACK",
                            )),
                        VerticalSpace(),
                        buildAccordion("Калорийность",
                            child: _buildIndicator(
                              color: Colors.primary,
                              section: "Калорийность",
                            )),
                        VerticalSpace(),
                        buildAccordion("Белки",
                            child: _buildIndicator(
                              color: Colors.exercise,
                              section: "Белки",
                            )),
                        VerticalSpace(),
                        buildAccordion("Жиры",
                            child: _buildIndicator(
                              color: Colors.exercise,
                              section: "Жиры",
                            )),
                        VerticalSpace(),
                        buildAccordion("Пищевые волокна",
                            child: _buildIndicator(
                              color: Colors.schedule,
                              section: "Пищевые волокна",
                            )),
                        VerticalSpace(),
                        buildAccordion("Углеводы",
                            child: _buildIndicator(
                              color: Colors.heartRate,
                              section: "Углеводы",
                            )),
                        VerticalSpace(),
                        buildAccordion("Витамины",
                            child: _buildIndicator(
                              color: Colors.success,
                              section: "Витамины",
                            )),
                        VerticalSpace(),
                        buildAccordion("Микроэлементы",
                            child: _buildIndicator(
                              color: Colors.primary,
                              section: "Микроэлементы",
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
}

class StatsCell extends StatelessWidget {
  final double width;
  final double diameter;
  final double fatsValue;
  final double carbohydratesValue;
  final double proteinsAndEnergyValue;

  StatsCell(
      {@required this.width,
      @required this.diameter,
      @required this.fatsValue,
      @required this.carbohydratesValue,
      @required this.proteinsAndEnergyValue});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) => Stack(alignment: Alignment.center, children: [
        StatsCellCircle(
            color: Colors.exercise,
            diameter: diameterProper,
            width: width,
            value: proteinsAndEnergyValue),
        StatsCellCircle(
            color: Colors.scheduleMainFood,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: fatsValue),
        StatsCellCircle(
            color: Colors.nutrition,
            diameter: diameterProper - widthProper * 8,
            width: width,
            value: carbohydratesValue)
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
