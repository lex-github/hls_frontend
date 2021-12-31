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
  final String index;
  final DateTime date;
  var rng = new Random();
  String breakfast = r'[^\p{07:00}\p{08:00}\p{09:00}\s]+';


  DietTab({@required this.index, this.date});

  Widget buildAccordion(String title, {String id, Widget child}) =>
      GetBuilder<StatsController>(
        init: StatsController(),
        builder: (_) {
          return Button(
              padding: Padding.zero,
              borderColor: Colors.disabled,
              onPressed: () => controller.toggle(id),
              child: Column(children: [
                VerticalSmallSpace(),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                    child: Row(children: [
                      Container(height: Size.iconBig),
                      TextPrimaryHint(title),
                      Expanded(child: HorizontalSpace()),
                      Obx(() => Transform.rotate(
                          angle: controller.getRotationAngle(id),
                          child: Icon(FontAwesomeIcons.chevronRight,
                              color: Colors.disabled, size: Size.iconSmall)))
                    ])),
                Obx(() => SizeTransition(
                    sizeFactor: controller.getSizeFactor(id),
                    child: Container(
                        padding: EdgeInsets.only(top: Size.vertical),
                        child: child))),
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
    double water = 0;
    // int proteins = 0;
    double energy = 0;
    // int upCarbohydrates = 0;
    double nutrients = 0;
    if (index != null) {
      // int carbohydrates = 0;
      water = controller.stats.foodRating.primaryStats.water;
      // int proteins = 0;
      energy = controller.stats.foodRating.primaryStats.energyValue;
      // int upCarbohydrates = 0;
      nutrients = controller.stats.foodRating.primaryStats.nutrients;
    }
    // int upProteins = 0;

    // print('title:  ' + proteins.toString());
    return Column(
      children: [
        StatsCell(
            diameter: diameter,
            width: Size.horizontalTiny,
            waterValue: water,
            nutrientsValue: nutrients,
            energyValue: energy),
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
                  percent: energy.toInt(),
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

//   Widget _buildIndicator({String section, Color color}) {
//     int c = 0;
//
//     final structure =
//         List<int>.filled(controller.stats.foodRating.components.length, 0);
//
//     if (controller.stats.foodRating.components.length != null) {
//       for (int j = 0; j < controller.stats.foodRating.components.length; j++) {
//         if (section ==
//             controller.stats.foodRating.components[j].foodComponent.section
//                 .toString()) {
//           // print('title$j:  ' + controller.stats[index].components[j].foodComponent.title);
//           // print('unit$j:  ' + controller.stats[index].components[j].foodComponent.unit);
//           // print('section$j:  ' + controller.stats[index].components[j].foodComponent.section);
//           // print('value$j:  ' + controller.stats[index].components[j].value.toString());
//           // print('upperLimit$j:  ' + controller.stats[index].components[j].upperLimit.toString());
//           // print('lowerLimit$j:  ' + controller.stats[index].components[j].lowerLimit.toString());
//
//           structure[c] = j;
//           c++;
//         }
//       }
//     }
//
// // print('title:  ' + title);
// // print('unit:  ' + unit);
// // print('value:  ' + value.toString());
// // print('upperLimit:  ' + upperLimit.toString());
// // print('lowerLimit:  ' + lowerLimit.toString());2
//
//     return Container(
//         width: width,
//         height: height * (c / 15),
//         child: ListView.builder(
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: c,
//           itemBuilder: (_, index) {
//             final i = structure[index];
//
//             // print('unit:  ' + controller.stats[index].components[structure[index]].foodComponent.unit);
//             // print('section:  ' + controller.stats[index].components[structure[index]].foodComponent.section);
//             // print('value:  ' + controller.stats[index].components[51].value.toString());
//             // print('upperLimit:  ' + controller.stats[index].components[structure[index]].upperLimit.toString());
//             // print('lowerLimit:  ' + controller.stats[index].components[structure[index]].lowerLimit.toString());
//             //
//
//             return _buildIndicator1(color, i);
//           },
//         ));
//   }

  Widget _buildIndicator({String title, String unit, double value, double upperLimit, double lowerLimit, Color color}) {
    // String title =
    //     controller.stats.foodRating.components[i].foodComponent.title;
    // String unit = controller.stats.foodRating.components[i].foodComponent.unit;
    // double value = controller.stats.foodRating.components[i].value;
    // double upperLimit = controller.stats.foodRating.components[i].upperLimit;
    // double lowerLimit = controller.stats.foodRating.components[i].lowerLimit;

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Size.horizontal,
              right: Size.horizontal,
            ),
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
                width: ((width - Size.horizontal * 4) *
                            (value / upperLimit > 1 ? 1 : value / upperLimit))
                        .isNaN
                    ? 0
                    : ((width - Size.horizontal * 4) *
                        (value / upperLimit > 1 ? 1 : value / upperLimit)),
                color: color,
              ),
              Container(
                height: (Size.border * 7).isNaN ? 0 : Size.border * 7,
                width: (Size.border * 2).isNaN ? 0 : Size.border * 2,
                color: Colors.white,
                margin: EdgeInsets.only(
                            left: (width - Size.horizontal * 4) *
                                (lowerLimit / upperLimit > 1
                                    ? 1
                                    : lowerLimit / upperLimit))
                        .isNonNegative
                    ? EdgeInsets.only(
                        left: (width - Size.horizontal * 4) *
                            (lowerLimit / upperLimit > 1
                                ? 1
                                : lowerLimit / upperLimit))
                    : EdgeInsets.only(left: 1),
              ),
              Container(
                height: (Size.border * 7).isNaN ? 0 : Size.border * 7,
                width: (Size.border * 2).isNaN ? 0 : Size.border * 2,
                color: Colors.white,
                margin: EdgeInsets.only(
                            left: (width - Size.horizontal * 4) *
                                upperLimit /
                                upperLimit)
                        .isNonNegative
                    ? EdgeInsets.only(
                        left: (width - Size.horizontal * 4) *
                            upperLimit /
                            upperLimit)
                    : EdgeInsets.only(left: 1),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextPrimary(
                controller.stats.eatings[i].scheduleFood.title,
                size: Size.fontSmall,
              ),
            ),
            TextSecondary(
                controller.stats.eatings[i].scheduleFood.portion.toString() +
                    " гр")
          ],
        ),
      );

  Widget _buildCirclesContainer(int c, List<int> foods, int x) {
    double proteins = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[0].value;
    double proteinsLimit = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[0].limit;
    double fats = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[1].value;
    double fatsLimit = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[1].limit;
    double carbohydrates = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[2].value;
    double carbohydratesLimit = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[2].limit;
    double carbohydratesComplex = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[3].value;
    double carbohydratesComplexLimit = controller
        .stats.foodRating.componentsPerEating[x].statsEatings[3].limit;

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
          height: height * (c / 18),
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

  Widget _waterContainer({double waterValue,double waterLower,double waterUpper,double waterMedium, Color color}) {
    // double waterValue = controller.stats.foodRating.components[1].value;
    // double waterLower = controller.stats.foodRating.components[1].lowerLimit;
    // double waterUpper = controller.stats.foodRating.components[1].upperLimit;
    // double waterMedium = ((waterUpper + waterLower) / 2) / 1000;

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
                            (waterValue / 1000).ceilToDouble().toString() +
                                " л",
                            size: Size.font * 1.5,
                          )
                        ],
                      ),
                      TextSecondary(
                        (((waterValue / (waterMedium * 1000)) * 100).toInt())
                                .toString() +
                            "% от нормы",
                        size: Size.fontSmall,
                        align: TextAlign.center,
                      )
                    ])),
            VerticalSpace(),
            TextSecondary(
                "Ваша норма воды — $waterMedium литров. Из них на долю простой питьевой воды должно приходиться не менее 1,5 литров, а остальной объем нормы жидĸости — на чай/ĸофе/соĸ/супы/воду в составе овощей и фруĸтов"),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodContainer({
    int x,
    String plannedAt,
  }) {
    int c = 0;
    var foods = List<int>.filled(controller.stats.eatings.length, 0);
    if (controller.stats.eatings.length != null) {
      for (int j = 0; j < controller.stats.eatings.length; j++) {
        if (plannedAt ==
            controller.stats.eatings[j].scheduleItem.plannedAt.toString()) {
          foods[c] = j;
          print("l;ogkiyvb " + controller.stats.eatings[j].scheduleFood.title);

          c++;
        }
      }
    }

    return controller.stats.eatings.length == null || c < 1
        ? Nothing()
        : _buildCirclesContainer(c, foods, x);
  }

  @override
  Widget build(_) => index == null ||
          controller.stats.eatings.isNullEmptyFalseOrZero
      ? Column(
          children: [VerticalBigSpace(), _buildStatsContainer()],
        )
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // for (final item in controller
                        //     .stats.foodRating.componentsPerEating) ...[
                        //
                        //   VerticalSmallSpace(),
                        // ],

                        buildAccordion(
                          "Завтрак",
                          id: "Завтрак" + rng.nextInt(10000).toString(),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: Size.horizontal, right: Size.horizontal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (final component in controller.stats
                                        .foodRating.componentsPerEating) ...[
                                      for (final components
                                      in component.statsEatings) ...[
                                        // if (component.scheduleItem.kind == "breakfast")
                                          if((component.scheduleItem.plannedAt == "07:00" || component.scheduleItem.plannedAt == "08:00" || component.scheduleItem.plannedAt == "09:00" || component.scheduleItem.plannedAt == "10:00") && component.scheduleItem.kind.toLowerCase() == "breakfast")
                                          Stack(
                                            alignment:
                                            AlignmentDirectional.center,
                                            children: [
                                              CustomPaint(
                                                  size: M.Size(diameter * 0.4,
                                                      diameter * 0.4),
                                                  painter: SectorPainter(
                                                      background: true,
                                                      color: components
                                                          .component
                                                          .title ==
                                                          "Общие жиры"
                                                          ? Colors.schedule
                                                          : components.component
                                                          .title ==
                                                          "Простые углеводы"
                                                          ? Colors.fats
                                                          : components.component
                                                          .title ==
                                                          "Сложные углеводы"
                                                          ? Colors
                                                          .exercise
                                                          : Colors
                                                          .water,
                                                      width: 2,
                                                      startAngle: -pi / 2,
                                                      endAngle: components
                                                          .value ==
                                                          0
                                                          ? 0
                                                          : ((components.value /
                                                          (components.value >
                                                              components
                                                                  .limit
                                                              ? components
                                                              .value
                                                              : components
                                                              .limit)) *
                                                          2 *
                                                          pi))),
                                              Column(
                                                children: [
                                                  TextPrimary(
                                                    components.value
                                                        .toInt()
                                                        .toString() +
                                                        '/' +
                                                        components.limit
                                                            .toInt()
                                                            .toString(),
                                                    size: Size.fontSmall * 0.8,
                                                  ),
                                                  TextSecondary(
                                                    components.component
                                                        .title ==
                                                        "Общие жиры"
                                                        ? "Общие \nжиры"
                                                        : components.component
                                                        .title ==
                                                        "Простые углеводы"
                                                        ? "Простые \nуглеводы"
                                                        : components.component
                                                        .title ==
                                                        "Сложные углеводы"
                                                        ? "Сложные \nуглеводы"
                                                        : components
                                                        .component
                                                        .title,
                                                    size: Size.fontSmall * 0.6,
                                                    align: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ],
                                  ],
                                ),
                                VerticalSmallSpace(),
                                for (final eating
                                in controller.stats.eatings) ...[
                                  if ((eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "07:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "08:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "09:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "10:00") && eating.scheduleItem.kind.toLowerCase() == "breakfast")
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextPrimary(
                                            eating.scheduleFood.title,
                                            size: Size.fontSmall,
                                          ),
                                        ),
                                        TextSecondary(eating
                                            .scheduleFood.portion
                                            .toString() +
                                            " гр")
                                      ],
                                    ),
                                  VerticalTinySpace(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Перекус",
                          id: "Перекус" + rng.nextInt(10000).toString(),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: Size.horizontal, right: Size.horizontal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (final component in controller.stats
                                        .foodRating.componentsPerEating) ...[
                                      for (final components
                                      in component.statsEatings) ...[
                                        // if (component.scheduleItem.kind == "snack")
                                        if((component.scheduleItem.plannedAt == "10:00" || component.scheduleItem.plannedAt == "11:00" || component.scheduleItem.plannedAt == "12:00" || component.scheduleItem.plannedAt == "13:00") && component.scheduleItem.kind.toLowerCase() == "snack")

                                            Stack(
                                            alignment:
                                            AlignmentDirectional.center,
                                            children: [
                                              CustomPaint(
                                                  size: M.Size(diameter * 0.4,
                                                      diameter * 0.4),
                                                  painter: SectorPainter(
                                                      background: true,
                                                      color: components
                                                          .component
                                                          .title ==
                                                          "Общие жиры"
                                                          ? Colors.schedule
                                                          : components.component
                                                          .title ==
                                                          "Простые углеводы"
                                                          ? Colors.fats
                                                          : components.component
                                                          .title ==
                                                          "Сложные углеводы"
                                                          ? Colors
                                                          .exercise
                                                          : Colors
                                                          .water,
                                                      width: 2,
                                                      startAngle: -pi / 2,
                                                      endAngle: components
                                                          .value ==
                                                          0
                                                          ? 0
                                                          : ((components.value /
                                                          (components.value >
                                                              components
                                                                  .limit
                                                              ? components
                                                              .value
                                                              : components
                                                              .limit)) *
                                                          2 *
                                                          pi))),
                                              Column(
                                                children: [
                                                  TextPrimary(
                                                    components.value
                                                        .toInt()
                                                        .toString() +
                                                        '/' +
                                                        components.limit
                                                            .toInt()
                                                            .toString(),
                                                    size: Size.fontSmall * 0.8,
                                                  ),
                                                  TextSecondary(
                                                    components.component
                                                        .title ==
                                                        "Общие жиры"
                                                        ? "Общие \nжиры"
                                                        : components.component
                                                        .title ==
                                                        "Простые углеводы"
                                                        ? "Простые \nуглеводы"
                                                        : components.component
                                                        .title ==
                                                        "Сложные углеводы"
                                                        ? "Сложные \nуглеводы"
                                                        : components
                                                        .component
                                                        .title,
                                                    size: Size.fontSmall * 0.6,
                                                    align: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ],
                                  ],
                                ),
                                VerticalSmallSpace(),
                                for (final eating
                                in controller.stats.eatings) ...[
                                  if ((eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "10:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "11:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "12:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "13:00") && eating.scheduleItem.kind.toLowerCase() == "snack")
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextPrimary(
                                            eating.scheduleFood.title,
                                            size: Size.fontSmall,
                                          ),
                                        ),
                                        TextSecondary(eating
                                            .scheduleFood.portion
                                            .toString() +
                                            " гр")
                                      ],
                                    ),
                                  VerticalTinySpace(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Обед",
                          id: "Обед" + rng.nextInt(10000).toString(),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: Size.horizontal, right: Size.horizontal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (final component in controller.stats
                                        .foodRating.componentsPerEating) ...[
                                      for (final components
                                      in component.statsEatings) ...[
                                        // if (component.scheduleItem.kind == "lunch")
                                        if((component.scheduleItem.plannedAt == "13:00" || component.scheduleItem.plannedAt == "14:00" || component.scheduleItem.plannedAt == "15:00" || component.scheduleItem.plannedAt == "16:00") && component.scheduleItem.kind.toLowerCase() == "lunch")

                                            Stack(
                                            alignment:
                                            AlignmentDirectional.center,
                                            children: [
                                              CustomPaint(
                                                  size: M.Size(diameter * 0.4,
                                                      diameter * 0.4),
                                                  painter: SectorPainter(
                                                      background: true,
                                                      color: components
                                                          .component
                                                          .title ==
                                                          "Общие жиры"
                                                          ? Colors.schedule
                                                          : components.component
                                                          .title ==
                                                          "Простые углеводы"
                                                          ? Colors.fats
                                                          : components.component
                                                          .title ==
                                                          "Сложные углеводы"
                                                          ? Colors
                                                          .exercise
                                                          : Colors
                                                          .water,
                                                      width: 2,
                                                      startAngle: -pi / 2,
                                                      endAngle: components
                                                          .value ==
                                                          0
                                                          ? 0
                                                          : ((components.value /
                                                          (components.value >
                                                              components
                                                                  .limit
                                                              ? components
                                                              .value
                                                              : components
                                                              .limit)) *
                                                          2 *
                                                          pi))),
                                              Column(
                                                children: [
                                                  TextPrimary(
                                                    components.value
                                                        .toInt()
                                                        .toString() +
                                                        '/' +
                                                        components.limit
                                                            .toInt()
                                                            .toString(),
                                                    size: Size.fontSmall * 0.8,
                                                  ),
                                                  TextSecondary(
                                                    components.component
                                                        .title ==
                                                        "Общие жиры"
                                                        ? "Общие \nжиры"
                                                        : components.component
                                                        .title ==
                                                        "Простые углеводы"
                                                        ? "Простые \nуглеводы"
                                                        : components.component
                                                        .title ==
                                                        "Сложные углеводы"
                                                        ? "Сложные \nуглеводы"
                                                        : components
                                                        .component
                                                        .title,
                                                    size: Size.fontSmall * 0.6,
                                                    align: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ],
                                  ],
                                ),
                                VerticalSmallSpace(),
                                for (final eating
                                in controller.stats.eatings) ...[
                                  if ((eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "13:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "14:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "15:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "16:00") && eating.scheduleItem.kind.toLowerCase() == "lunch")
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextPrimary(
                                            eating.scheduleFood.title,
                                            size: Size.fontSmall,
                                          ),
                                        ),
                                        TextSecondary(eating
                                            .scheduleFood.portion
                                            .toString() +
                                            " гр")
                                      ],
                                    ),
                                  VerticalTinySpace(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Перекус",
                          id: "Перекус" + rng.nextInt(10000).toString(),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: Size.horizontal, right: Size.horizontal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (final component in controller.stats
                                        .foodRating.componentsPerEating) ...[
                                      for (final components
                                      in component.statsEatings) ...[
                                        // if (component.scheduleItem.kind == "snack")
                                        if((component.scheduleItem.plannedAt == "15:00" || component.scheduleItem.plannedAt == "16:00" || component.scheduleItem.plannedAt == "17:00" || component.scheduleItem.plannedAt == "18:00") && component.scheduleItem.kind.toLowerCase() == "snack")

                                            Stack(
                                            alignment:
                                            AlignmentDirectional.center,
                                            children: [
                                              CustomPaint(
                                                  size: M.Size(diameter * 0.4,
                                                      diameter * 0.4),
                                                  painter: SectorPainter(
                                                      background: true,
                                                      color: components
                                                          .component
                                                          .title ==
                                                          "Общие жиры"
                                                          ? Colors.schedule
                                                          : components.component
                                                          .title ==
                                                          "Простые углеводы"
                                                          ? Colors.fats
                                                          : components.component
                                                          .title ==
                                                          "Сложные углеводы"
                                                          ? Colors
                                                          .exercise
                                                          : Colors
                                                          .water,
                                                      width: 2,
                                                      startAngle: -pi / 2,
                                                      endAngle: components
                                                          .value ==
                                                          0
                                                          ? 0
                                                          : ((components.value /
                                                          (components.value >
                                                              components
                                                                  .limit
                                                              ? components
                                                              .value
                                                              : components
                                                              .limit)) *
                                                          2 *
                                                          pi))),
                                              Column(
                                                children: [
                                                  TextPrimary(
                                                    components.value
                                                        .toInt()
                                                        .toString() +
                                                        '/' +
                                                        components.limit
                                                            .toInt()
                                                            .toString(),
                                                    size: Size.fontSmall * 0.8,
                                                  ),
                                                  TextSecondary(
                                                    components.component
                                                        .title ==
                                                        "Общие жиры"
                                                        ? "Общие \nжиры"
                                                        : components.component
                                                        .title ==
                                                        "Простые углеводы"
                                                        ? "Простые \nуглеводы"
                                                        : components.component
                                                        .title ==
                                                        "Сложные углеводы"
                                                        ? "Сложные \nуглеводы"
                                                        : components
                                                        .component
                                                        .title,
                                                    size: Size.fontSmall * 0.6,
                                                    align: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ],
                                  ],
                                ),
                                VerticalSmallSpace(),
                                for (final eating
                                in controller.stats.eatings) ...[
                                  if ((eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "15:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "16:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "17:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "18:00") && eating.scheduleItem.kind.toLowerCase() == "snack")
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextPrimary(
                                            eating.scheduleFood.title,
                                            size: Size.fontSmall,
                                          ),
                                        ),
                                        TextSecondary(eating
                                            .scheduleFood.portion
                                            .toString() +
                                            " гр")
                                      ],
                                    ),
                                  VerticalTinySpace(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Ужин",
                          id: "Ужин" + rng.nextInt(10000).toString(),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: Size.horizontal, right: Size.horizontal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (final component in controller.stats
                                        .foodRating.componentsPerEating) ...[
                                      for (final components
                                      in component.statsEatings) ...[
                                        // if (component.scheduleItem.kind == "dinner")
                                        if((component.scheduleItem.plannedAt == "18:00" || component.scheduleItem.plannedAt == "19:00" || component.scheduleItem.plannedAt == "20:00" || component.scheduleItem.plannedAt == "21:00" || component.scheduleItem.plannedAt == "21:00") && component.scheduleItem.kind.toLowerCase() == "dinner")

                                            Stack(
                                            alignment:
                                            AlignmentDirectional.center,
                                            children: [
                                              CustomPaint(
                                                  size: M.Size(diameter * 0.4,
                                                      diameter * 0.4),
                                                  painter: SectorPainter(
                                                      background: true,
                                                      color: components
                                                          .component
                                                          .title ==
                                                          "Общие жиры"
                                                          ? Colors.schedule
                                                          : components.component
                                                          .title ==
                                                          "Простые углеводы"
                                                          ? Colors.fats
                                                          : components.component
                                                          .title ==
                                                          "Сложные углеводы"
                                                          ? Colors
                                                          .exercise
                                                          : Colors
                                                          .water,
                                                      width: 2,
                                                      startAngle: -pi / 2,
                                                      endAngle: components
                                                          .value ==
                                                          0
                                                          ? 0
                                                          : ((components.value /
                                                          (components.value >
                                                              components
                                                                  .limit
                                                              ? components
                                                              .value
                                                              : components
                                                              .limit)) *
                                                          2 *
                                                          pi))),
                                              Column(
                                                children: [
                                                  TextPrimary(
                                                    components.value
                                                        .toInt()
                                                        .toString() +
                                                        '/' +
                                                        components.limit
                                                            .toInt()
                                                            .toString(),
                                                    size: Size.fontSmall * 0.8,
                                                  ),
                                                  TextSecondary(
                                                    components.component
                                                        .title ==
                                                        "Общие жиры"
                                                        ? "Общие \nжиры"
                                                        : components.component
                                                        .title ==
                                                        "Простые углеводы"
                                                        ? "Простые \nуглеводы"
                                                        : components.component
                                                        .title ==
                                                        "Сложные углеводы"
                                                        ? "Сложные \nуглеводы"
                                                        : components
                                                        .component
                                                        .title,
                                                    size: Size.fontSmall * 0.6,
                                                    align: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ],
                                  ],
                                ),
                                VerticalSmallSpace(),
                                for (final eating
                                in controller.stats.eatings) ...[
                                  if ((eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "18:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "19:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "20:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "21:00" || eating.scheduleItem.plannedAt
                                      .toLowerCase() ==
                                      "22:00") && eating.scheduleItem.kind.toLowerCase() == "dinner")
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextPrimary(
                                            eating.scheduleFood.title,
                                            size: Size.fontSmall,
                                          ),
                                        ),
                                        TextSecondary(eating
                                            .scheduleFood.portion
                                            .toString() +
                                            " гр")
                                      ],
                                    ),
                                  VerticalTinySpace(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        VerticalSmallSpace(),

                        buildAccordion(
                          "Калорийность",
                              id: "Калорийность",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Калорийность")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Colors.failure,
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Вода",
                              id: "Вода",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Вода")
                                      _waterContainer(
                                          waterValue: structure.value,
                                          waterLower: structure.lowerLimit,
                                          waterUpper: structure.upperLimit,
                                          waterMedium: ((structure.upperLimit + structure.lowerLimit) / 2) / 1000,
                                      color: Colors.water,
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Белки",
                              id: "Белки",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Белки")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Colors.exercise,
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Жиры",
                              id: "Жиры",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Жиры")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Colors.fats,
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Углеводы",
                              id: "Углеводы",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Углеводы")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Colors.nutrition,
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Пищевые волокна",
                              id: "Пищевые волокна",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Пищевые волокна")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Colors.schedule,
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Витамины",
                              id: "Витамины",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Витамины")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Color(0xFF2F2F2F),
                                      ),
                                  ],
                                ],
                              ),
                        ),
                        VerticalSmallSpace(),
                        buildAccordion(
                          "Микроэлементы",
                              id: "Микроэлементы",
                              child: Column(
                                children: [
                                  for (final structure
                                  in controller.stats.foodRating.components) ...[
                                    if (structure.foodComponent.section == "Микроэлементы")
                                      _buildIndicator(
                                        title: structure.foodComponent.title,
                                        unit: structure.foodComponent.unit,
                                        value: structure.value,
                                        upperLimit: structure.upperLimit,
                                        lowerLimit: structure.lowerLimit,
                                        color: Colors.primary,
                                      ),
                                  ],
                                ],
                              ),
                        ),

                      ],
                    ),

                    // buildAccordion(
                    //   "Завтрак",
                    //   id: "08:00",
                    //   child: _buildFoodContainer(
                    //     x: 0,
                    //     plannedAt: "08:00",
                    //   ),
                    // ),
                    // VerticalBigSpace(),
                    // buildAccordion("Перекус",
                    //     id: "11:00",
                    //     child: _buildFoodContainer(
                    //       x: 1,
                    //       plannedAt: "11:00",
                    //     )),
                    // VerticalBigSpace(),
                    // buildAccordion("Обед",
                    //     id: "14:00",
                    //     child: _buildFoodContainer(
                    //       x: 2,
                    //       plannedAt: "14:00",
                    //     )),
                    // VerticalBigSpace(),
                    // buildAccordion("Перекус",
                    //     id: "16:00",
                    //     child: _buildFoodContainer(
                    //       x: 3,
                    //       plannedAt: "16:00",
                    //     )),
                    // VerticalBigSpace(),
                    // buildAccordion("Ужин",
                    //     id: "19:00",
                    //     child: _buildFoodContainer(
                    //       x: 4,
                    //       plannedAt: "19:00",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Калорийность",
                    //     child: _buildIndicator(
                    //       color: Colors.primary,
                    //       section: "Калорийность",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Вода",
                    //     child: _waterContainer(
                    //       color: Colors.primary,
                    //       section: "Вода ",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Белки",
                    //     child: _buildIndicator(
                    //       color: Colors.exercise,
                    //       section: "Белки",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Жиры",
                    //     child: _buildIndicator(
                    //       color: Colors.exercise,
                    //       section: "Жиры",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Пищевые волокна",
                    //     child: _buildIndicator(
                    //       color: Colors.schedule,
                    //       section: "Пищевые волокна",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Углеводы",
                    //     child: _buildIndicator(
                    //       color: Colors.heartRate,
                    //       section: "Углеводы",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Витамины",
                    //     child: _buildIndicator(
                    //       color: Colors.success,
                    //       section: "Витамины",
                    //     )),
                    // VerticalSpace(),
                    // buildAccordion("Микроэлементы",
                    //     child: _buildIndicator(
                    //       color: Colors.primary,
                    //       section: "Микроэлементы",
                    //     )),
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
            value: nutrientsValue / 100),
        StatsCellCircle(
            color: Colors.heartRate,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: energyValue / 100),
        StatsCellCircle(
            color: Colors.primary,
            diameter: diameterProper - widthProper * 8,
            width: width,
            value: waterValue / 100)
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
