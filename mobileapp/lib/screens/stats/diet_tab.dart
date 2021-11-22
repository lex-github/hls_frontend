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
  final width = Get.width;
  final height = Get.height;
  final int index;
  final DateTime date;

  DietTab({@required this.index, this.date});


  Widget buildAccordion(String title, {String text, Widget child}) =>
      GetBuilder<StatsController>(
        init:
            StatsController(fromDate: date.toString(), toDate: date.toString()),
        builder: (_) {
          return Button(
              padding: Padding.zero,
              borderColor: Colors.disabled,
              onPressed: () => controller.toggle(title),
              child: Column(children: [
                VerticalSmallSpace(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                    child: Row(children: [
                      Container(height: Size.iconBig),
                      TextPrimaryHint(title),
                      Expanded(child: HorizontalSpace()),
                      Obx(() => Transform.rotate(
                          angle: controller.getRotationAngle(title),
                          child: Icon(FontAwesomeIcons.chevronRight,
                              color: Colors.disabled, size: Size.iconSmall)))
                    ])),
                Obx(() => SizeTransition(
                    sizeFactor: controller.getSizeFactor(title),
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
    // int carbohydrates = 0;
    double water = controller.stats[index].foodRating.primaryStats.water;
    // int proteins = 0;
    double energy = controller.stats[index].foodRating.primaryStats.energyValue;
    // int upCarbohydrates = 0;
    double nutrients = controller.stats[index].foodRating.primaryStats.nutrients;
    // int upProteins = 0;


    // print('title:  ' + proteins.toString());
    return Column(
      children: [
        StatsCell(
            diameter: diameter,
            width: Size.horizontalTiny,
            waterValue: water,
            nutrientsValue: nutrients,
            energyValue:
               energy),
        VerticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsTitle(
                  percent: nutrients.toInt(),
                  title: "Нутриенты",
                  indicatorColor: Colors.exercise,
                ),
                VerticalMediumSpace(),
                _buildStatsTitle(
                  percent:
                  energy.toInt(),
                  title: "Калории",
                  indicatorColor: Colors.heartRate,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsTitle(
                  percent: water.toInt(),
                  title: "Вода",
                  indicatorColor: Colors.primary,
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

int c = 0;

    final structure =
    List<int>.filled(controller.stats[index].foodRating.components.length, 0);

    if (controller.stats[index].foodRating.components.length != null) {
      for (int j = 0;
      j < controller.stats[index].foodRating.components.length;
      j++) {



        if (section ==
            controller.stats[index].foodRating.components[j].foodComponent.section
                .toString()) {
          // print('title$j:  ' + controller.stats[index].components[j].foodComponent.title);
          // print('unit$j:  ' + controller.stats[index].components[j].foodComponent.unit);
          // print('section$j:  ' + controller.stats[index].components[j].foodComponent.section);
          // print('value$j:  ' + controller.stats[index].components[j].value.toString());
          // print('upperLimit$j:  ' + controller.stats[index].components[j].upperLimit.toString());
          // print('lowerLimit$j:  ' + controller.stats[index].components[j].lowerLimit.toString());

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

    return Container(
          width: width,
          height: height * (c / 15),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: c,
            itemBuilder: (_, index) {

              final i = structure[index];


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

            String title = controller.stats[index].foodRating.components[i].foodComponent.title;
            String unit = controller.stats[index].foodRating.components[i].foodComponent.unit;
            double value = controller.stats[index].foodRating.components[i].value;
            double upperLimit = controller.stats[index].foodRating.components[i].upperLimit;
            double lowerLimit = controller.stats[index].foodRating.components[i].lowerLimit;

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
                  size: Size.fontSmall * 0.6,
                  align: TextAlign.center,
                )
              ]));

  Widget _buildFoodItem(int i) => Container(
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

  Widget _buildCirclesContainer (int fats, int upFats, int carbohydrates, int upCarbohydrates, int proteins, int upProteins, int energy, int upEnergy, int c, List <int > foods, int x) {


    double proteins = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[0].value;
    double proteinsLimit = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[0].limit;
    double fats = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[1].value;
    double fatsLimit = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[1].limit;
    double carbohydrates = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[2].value;
    double carbohydratesLimit = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[2].limit;
    double carbohydratesComplex = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[3].value;
    double carbohydratesComplexLimit = controller.stats[index].foodRating.componentsPerEating[x].statsEatings[3].limit;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircleIndicator(
              color: Colors.primary,
              title: "Белки",
              currentCount: proteins.toInt(),
              maxCount: proteinsLimit.toInt(),
            ),
            _buildCircleIndicator(
              color: Colors.schedule,
              title: "Общие жиры",
              currentCount: fats.toInt(),
              maxCount: fatsLimit.toInt(),
            ),
            _buildCircleIndicator(
              color: Colors.scheduleMainFood,
              title: "Простые углеводы",
              currentCount: carbohydrates.toInt(),
              maxCount: carbohydratesLimit.toInt(),
            ),
            _buildCircleIndicator(
              color: Colors.exercise,
              title: "Сложные углеводы",
              currentCount: carbohydratesComplex.toInt(),
              maxCount: carbohydratesComplexLimit.toInt(),
            ),
          ],
        ),
        VerticalSmallSpace(),
        Container(
          width: width,
          height: height * (c / 22),
          child: c == 1
              ? _buildFoodItem(0)
              : ListView.builder(
            itemCount: c,
            itemBuilder: (_, i) {
              // c--;
              final index = foods[i];

              // index = j;

              print(index);
              return _buildFoodItem(index);
            },
          ),
        ),
      ],
    );
  }



  Widget _waterContainer ( {String section,
    Color color}) {

    double waterValue = controller.stats[index].foodRating.components[1].value;
    double waterLower = controller.stats[index].foodRating.components[1].lowerLimit;
    double waterUpper = controller.stats[index].foodRating.components[1].upperLimit;
    double waterMedium = ((waterUpper + waterLower) / 2) /1000;

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
        child: Column(
          children: [
            TitleCircularProgress(
                color: color,
                value: waterValue / (waterMedium * 1000),
                size: Size.vertical * 6,
                border: Size.border,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextPrimary(
                            (waterValue/1000).toString() + " л",
                            size: Size.font * 1.5,
                          )
                        ],
                      ),
                      TextSecondary(
                        (((waterValue/(waterMedium * 1000)) * 100).toInt()).toString() + "% от нормы",
                        size: Size.fontSmall,
                        align: TextAlign.center,
                      )
                    ])),
            VerticalSpace(),
            TextSecondary("Ваша норма воды — $waterMedium литров. Из них на долю простой питьевой воды должно приходиться не менее 1,5 литров, а остальной объем нормы жидĸости — на чай/ĸофе/соĸ/супы/воду в составе овощей и фруĸтов"),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodContainer({
    int x,
    String kind,
  }) {
    int carbohydrates = 0;
    int fats = 0;
    int proteins = 0;
    int energy = 0;
    int upCarbohydrates = 0;
    int upFats = 0;
    int upProteins = 0;
    int upEnergy = 0;
    int c = 0;
    int z = 0;
    var foods = List<int>.filled(controller.stats[index].eatings.length, 0);
    if (controller.stats[index].eatings.length != null) {
      for (int j = 0; j < controller.stats[index].eatings.length; j++) {
        if (kind ==
            controller.stats[index].eatings[j].scheduleItem.kind.toString()) {
          foods[c] = j;

          c++;

        }
      }
    }



    final structure =
    List<int>.filled(controller.stats[index].foodRating.components.length, 0);

    if (controller.stats[index].foodRating.components.length != null) {
      for (int j = 0;
      j < controller.stats[index].foodRating.components.length;
      j++) {



        if ("Калории" ==
            controller.stats[index].foodRating.components[j].foodComponent.title
                .toString()) {

          upEnergy = controller.stats[index].foodRating.components[j].upperLimit.toInt();
          energy = controller.stats[index].foodRating.components[j].value.toInt();

          structure[z] = j;
          z++;
        }
        if ("Белки" ==
            controller.stats[index].foodRating.components[j].foodComponent.title
                .toString()) {

          upProteins = controller.stats[index].foodRating.components[j].upperLimit.toInt();
          proteins = controller.stats[index].foodRating.components[j].value.toInt();

          structure[z] = j;
          z++;
        }
        if ("Жиры" ==
            controller.stats[index].foodRating.components[j].foodComponent.title
                .toString()) {

          upFats = controller.stats[index].foodRating.components[j].upperLimit.toInt();
          fats = controller.stats[index].foodRating.components[j].value.toInt();

          structure[z] = j;
          z++;
        }
        if ("Углеводы" ==
            controller.stats[index].foodRating.components[j].foodComponent.title
                .toString()) {

          upCarbohydrates = controller.stats[index].foodRating.components[j].upperLimit.toInt();
          carbohydrates = controller.stats[index].foodRating.components[j].value.toInt();

          structure[z] = j;
          z++;
        }
      }
    }
    return controller.stats[index].eatings.length == null || c < 1
        ? Nothing()
        : _buildCirclesContainer(fats, upFats, carbohydrates, upCarbohydrates, proteins, upProteins, energy, upEnergy, c, foods, x);
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
                              x: 0,
                              kind: "BREAKFAST",
                            ),
                        ),
                        VerticalBigSpace(),
                        buildAccordion("Перекус",
                            child: _buildFoodContainer(
                              x: 1,
                              kind: "SNACK",
                            )),
                        VerticalBigSpace(),
                        buildAccordion("Обед",
                            child: _buildFoodContainer(
                              x: 2,
                              kind: "LUNCH",
                            )),
                        VerticalBigSpace(),
                        buildAccordion("Перекус",
                            child: _buildFoodContainer(
                              x: 3,
                              kind: "SNACK",
                            )),
                        VerticalBigSpace(),
                        buildAccordion("Ужин",
                            child: _buildFoodContainer(
                              x: 4,
                              kind: "DINNER",
                            )),
                        VerticalSpace(),
                        buildAccordion("Калорийность",
                            child: _buildIndicator(
                              color: Colors.primary,
                              section: "Калорийность",
                            )),
                        VerticalSpace(),
                        buildAccordion("Вода",
                            child: _waterContainer(
                              color: Colors.primary,
                              section: "Вода ",
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
  final double waterValue;
  final double nutrientsValue;
  final double energyValue;

  StatsCell(
      {@required this.width,
      @required this.diameter,
      @required this.waterValue,
      @required this.nutrientsValue,
      @required this.energyValue});

  double get diameterProper => diameter - width;

  double get widthProper => width * 2.5;

  @override
  Widget build(_) => Stack(alignment: Alignment.center, children: [
        StatsCellCircle(
            color: Colors.exercise,
            diameter: diameterProper,
            width: width,
            value: nutrientsValue/100),
        StatsCellCircle(
            color: Colors.heartRate,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: energyValue/100),
        StatsCellCircle(
            color: Colors.primary,
            diameter: diameterProper - widthProper * 8,
            width: width,
            value: waterValue/100)
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
