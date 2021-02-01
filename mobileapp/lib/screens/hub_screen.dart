import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle, Card;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/theme/styles.dart';

class HubScreen extends StatelessWidget {
  final radius = Size.screenWidth / 1.5;
  final outerRadius = Size.screenWidth / 1.5 + Size.vertical * 2;
  final angle = 2 * pi / 3;
  final startAngle = -pi / 2;

  // builders

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: hubScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Icon(Icons.notifications)),
      child: ListView(children: [
        Column(children: [
          VerticalSpace(),
          GetBuilder<HubController>(
              init: HubController(),
              builder: (controller) =>
                  Stack(alignment: Alignment.center, children: [
                    RotationTransition(
                        turns: Tween(begin: .0, end: 1.0)
                            .animate(controller.animationController),
                        child: Stack(alignment: Alignment.center, children: [
                          CustomPaint(
                              size: M.Size(outerRadius, outerRadius),
                              painter: SectorProgressPainter(
                                  color: Colors.nutrition,
                                  title: nutritionTitle,
                                  value: .63,
                                  endAngle: angle,
                                  startAngle: -pi / 2)),
                          CustomPaint(
                              size: M.Size(outerRadius, outerRadius),
                              painter: SectorProgressPainter(
                                  color: Colors.exercise,
                                  title: exerciseTitle,
                                  value: .38,
                                  endAngle: angle,
                                  startAngle: startAngle + angle)),
                          CustomPaint(
                              size: M.Size(outerRadius, outerRadius),
                              painter: SectorProgressPainter(
                                  color: Colors.schedule,
                                  title: scheduleTitle,
                                  value: .81,
                                  endAngle: angle,
                                  startAngle: startAngle + angle * 2))
                        ])),
                    CircularProgress(
                        size: radius,
                        child: Text(
                          '64%',
                          style: TextStyle.primary
                              .copyWith(fontSize: Size.fontPercent),
                        ))
                  ]))
        ]),
        VerticalBigSpace(),
        Container(
            child: Column(children: [
          Container(
              child: Row(children: [
            HorizontalSpace(),
            Expanded(
                child: Clickable(
                    child: Button(
                        padding:
                            EdgeInsets.symmetric(vertical: Padding.button.top),
                        title: scheduleTitle,
                        borderColor: Colors.schedule,
                        titleStyle: M.TextStyle(fontSize: Size.fontTiny)))),
            HorizontalSmallSpace(),
            Expanded(
                child: Clickable(
                    child: Button(
                        padding:
                            EdgeInsets.symmetric(vertical: Padding.button.top),
                        title: nutritionTitle,
                        borderColor: Colors.nutrition,
                        titleStyle: M.TextStyle(fontSize: Size.fontTiny)))),
            HorizontalSmallSpace(),
            Expanded(
                child: Clickable(
                    child: Button(
                        padding:
                            EdgeInsets.symmetric(vertical: Padding.button.top),
                        title: exerciseTitle,
                        borderColor: Colors.exercise,
                        titleStyle: M.TextStyle(fontSize: Size.fontTiny)))),
            HorizontalSpace()
          ])),
          Container(
              color: Colors.background,
              padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VerticalBigSpace(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$goalTitle:', style: TextStyle.secondary),
                          Text('Похудение', style: TextStyle.primary)
                        ]),
                    VerticalMediumSpace(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$macrocycleTitle:', style: TextStyle.secondary),
                          Text('Оздоровительный', style: TextStyle.primary)
                        ]),
                    VerticalMediumSpace(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('$microcycleTitle\n' '(2м /16 тр):',
                                  style: TextStyle.secondary,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text('Первый\n' '(подготовительный)',
                                  style: TextStyle.primary,
                                  textAlign: TextAlign.right))
                        ]),
                    VerticalMediumSpace(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$weekTitle:', style: TextStyle.secondary),
                          Text('2/8', style: TextStyle.primary)
                        ]),
                    VerticalMediumSpace(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$trainingTitle:', style: TextStyle.secondary),
                          Text('3/16', style: TextStyle.primary)
                        ]
                      ),
                      VerticalBigSpace(),
                    ]
                  )
                ),
                Container(color: Colors.background,
                  padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                  child: Column(
                    children: [
                     Card(title: 'ПРОДУКТЫ ЧЕМПИОНЫ Ч.3'),
                      VerticalSpace(),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              title: 'КУРЕНИЕ НАЧАЛО КОНЦА')
                          ),
                        HorizontalSpace(),
                        Expanded(
                          child: Card(
                            title: 'ЧЕМ СИЛЕН СЕЛЕН?')
                        )
                        ]),
                      VerticalSpace(),
                      Card(title: 'НАШ ОРГАНИЗМ И ВЛИЯНИЕ НА НЕГО НАШЕГО РАЦИОНА'),
                      VerticalBigSpace()
                    ]
                  )
                )
              ]
            )
          )
      ])
  );
}

class HubController extends Controller with SingleGetTickerProviderMixin {
  HubController() {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value)
          ..repeat(period: rotationAnimationDuration);
  }

  AnimationController _animationController;
  AnimationController get animationController => _animationController;

  final _animationProgress = .0.obs;
  double get animationProgress => _animationProgress.value;
  set animationProgress(double value) => _animationProgress.value = value;
}
