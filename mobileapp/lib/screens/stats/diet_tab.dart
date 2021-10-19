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

class DietTab extends StatelessWidget {
  double get diameter => (Size.screenWidth - Size.horizontal * 2) / 2;

  final StatsController controller = Get.put(StatsController());
  final width = Get.width;
  final height = Get.height;

  Widget buildAccordion(String title, {String text, Widget child}) => Button(
      padding: Padding.zero,
      borderColor: Colors.disabled,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: Size.horizontal),
                        child: TextSecondary(text))))),
        VerticalSmallSpace()
      ]));

  Widget spacer() => SizedBox(
        width: Size.horizontal * 0.3,
      );

  Widget _buildStatsTitle({int percent, String title, Color indicatorColor}) =>
      Row(
        children: [
          Container(
            width: Size.horizontal * 0.7,
            height: Size.border * 2,
            color: indicatorColor,
          ),
          spacer(),
          TextPrimary(percent.toString() + "%"),
          spacer(),
          TextSecondary(title),
        ],
      );

  Widget _buildStatsContainer() => Column(
        children: [
          StatsCell(diameter: diameter, width: Size.horizontalTiny),
          VerticalSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Жиры",
                    indicatorColor: Colors.exercise,
                  ),
                  VerticalMediumSpace(),
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Калории",
                    indicatorColor: Colors.exercise,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Жиры",
                    indicatorColor: Colors.scheduleMainFood,
                  ),
                  VerticalMediumSpace(),
                  _buildStatsTitle(
                    percent: Random().nextInt(100),
                    title: "Калории",
                    indicatorColor: Colors.nutrition,
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Widget _buildIndicator(
          {double currentCount,
          double minCount,
          double normalCount,
          int maxCount,
          String title,
          Color color}) =>
      Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSecondary(title),
                  TextSecondary(maxCount.toString())
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
                  width: (width - Size.horizontal * 4) * currentCount,
                  color: color,
                ),
                Container(
                  height: Size.border * 7,
                  width: Size.border * 2,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                      left: (width - Size.horizontal * 4) * minCount),
                ),
                Container(
                  height: Size.border * 7,
                  width: Size.border * 2,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                      left: (width - Size.horizontal * 4) * normalCount),
                ),
              ],
            ),
            VerticalSmallSpace(),
          ],
        ),
      );

  Widget _buildCircleIndicator(
          {String title, String currentCount, String maxCount, Color color}) =>
      TitleCircularProgress(
          color: color,
          value: Random().nextDouble(),
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

  Widget _buildFoodItem({String food, String weight}) => Container(
        padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextPrimary(
              food,
              size: Size.fontSmall,
            ),
            TextSecondary('$weight гр')
          ],
        ),
      );

  Widget _buildFoodContainer({
    String carbohydrates,
    String starches,
    String fats,
    String proteins,
  }) =>
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircleIndicator(
                color: Colors.primary,
                title: "углеводы",
                currentCount: carbohydrates,
                maxCount: 150.toString(),
              ),
              _buildCircleIndicator(
                color: Colors.schedule,
                title: "крахмалы",
                currentCount: starches,
                maxCount: 150.toString(),
              ),
              _buildCircleIndicator(
                color: Colors.scheduleMainFood,
                title: "жиры",
                currentCount: fats,
                maxCount: 100.toString(),
              ),
              _buildCircleIndicator(
                color: Colors.exercise,
                title: "белки",
                currentCount: proteins,
                maxCount: 200.toString(),
              ),
            ],
          ),
          VerticalSmallSpace(),
          _buildFoodItem(
            food: "Сало",
            weight: 50.toString(),
          ),
          VerticalSmallSpace(),
          _buildFoodItem(
            food: "Творог",
            weight: 200.toString(),
          ),
          VerticalSmallSpace(),
          _buildFoodItem(
            food: "Яблоко",
            weight: 100.toString(),
          ),
          VerticalSmallSpace(),
          _buildFoodItem(
            food: "Банан",
            weight: 100.toString(),
          ),
        ],
      );

  @override
  Widget build(_) => Container(
        color: Colors.background,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Size.horizontal),
          child: Column(
            children: [
              _buildStatsContainer(),
              VerticalBigSpace(),
              buildAccordion("Завтрак",
                  child: _buildFoodContainer(
                    carbohydrates: Random().nextInt(150).toString(),
                    starches: Random().nextInt(150).toString(),
                    fats: Random().nextInt(150).toString(),
                    proteins: Random().nextInt(150).toString(),
                  )),
              VerticalSpace(),
              buildAccordion("Обед",
                  child: _buildFoodContainer(
                    carbohydrates: Random().nextInt(150).toString(),
                    starches: Random().nextInt(150).toString(),
                    fats: Random().nextInt(150).toString(),
                    proteins: Random().nextInt(150).toString(),
                  )),
              VerticalSpace(),
              buildAccordion("Ужин",
                  child: _buildFoodContainer(
                    carbohydrates: Random().nextInt(150).toString(),
                    starches: Random().nextInt(150).toString(),
                    fats: Random().nextInt(150).toString(),
                    proteins: Random().nextInt(150).toString(),
                  )),
              VerticalSpace(),
              buildAccordion("Доп. приём 1 и/или  Доп. приём 2",
                  child: _buildFoodContainer(
                    carbohydrates: Random().nextInt(150).toString(),
                    starches: Random().nextInt(150).toString(),
                    fats: Random().nextInt(150).toString(),
                    proteins: Random().nextInt(150).toString(),
                  )),
              VerticalSpace(),
              buildAccordion("Калорийность",
                  child: _buildIndicator(
                    currentCount: Random().nextDouble(),
                    minCount: Random().nextDouble(),
                    normalCount: Random().nextDouble(),
                    maxCount: Random().nextInt(3000),
                    color: Colors.primary,
                    title: "Калории",
                  )),
              VerticalSpace(),
              buildAccordion("Белки",
                  child: _buildIndicator(
                    currentCount: Random().nextDouble(),
                    minCount: Random().nextDouble(),
                    normalCount: Random().nextDouble(),
                    maxCount: Random().nextInt(3000),
                    color: Colors.exercise,
                    title: "Белки",
                  )),
              VerticalSpace(),
              buildAccordion("Жиры",
                  child: Column(
                    children: [
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "НЖК",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "Холестерин",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "МНЖК/Омега-9",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "ПНЖК",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "Омега-3",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "Омега-6",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.scheduleMainFood,
                        title: "Трансжиры",
                      ),
                    ],
                  )),
              VerticalSpace(),
              buildAccordion("Пищевые волокна",
                  child: _buildIndicator(
                    currentCount: Random().nextDouble(),
                    minCount: Random().nextDouble(),
                    normalCount: Random().nextDouble(),
                    maxCount: Random().nextInt(3000),
                    color: Colors.schedule,
                    title: "Пищевые волокна",
                  )),
              VerticalSpace(),
              buildAccordion("Углеводы",
                  child: Column(
                    children: [
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.heartRate,
                        title: "Моносахариды",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.heartRate,
                        title: "Крахмал",
                      ),
                    ],
                  )),
              VerticalSpace(),
              buildAccordion("Витамины",
                  child: Column(
                    children: [
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "A",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "B1",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "B2",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "B3/PP/НЭ",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "C",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "D",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.success,
                        title: "K",
                      ),
                    ],
                  )),
              VerticalSpace(),
              buildAccordion("Микроэлементы",
                  child: Column(
                    children: [
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Калий",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Кальций",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Кремний",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Магний",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Натрий",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Фосфор",
                      ),
                      _buildIndicator(
                        currentCount: Random().nextDouble(),
                        minCount: Random().nextDouble(),
                        normalCount: Random().nextDouble(),
                        maxCount: Random().nextInt(3000),
                        color: Colors.primary,
                        title: "Цинк",
                      ),
                    ],
                  )),
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
            color: Colors.scheduleMainFood,
            diameter: diameterProper - widthProper * 4,
            width: width,
            value: Random().nextDouble()),
        StatsCellCircle(
            color: Colors.nutrition,
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
