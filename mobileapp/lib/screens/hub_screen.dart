import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
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
      child: Column(children: [
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
                                title: 'ПИТАНИЕ',
                                value: .63,
                                endAngle: angle,
                                startAngle: -pi / 2)),
                        CustomPaint(
                            size: M.Size(outerRadius, outerRadius),
                            painter: SectorProgressPainter(
                                color: Colors.exercise,
                                title: 'ДВИЖЕНИЕ',
                                value: .38,
                                endAngle: angle,
                                startAngle: startAngle + angle)),
                        CustomPaint(
                            size: M.Size(outerRadius, outerRadius),
                            painter: SectorProgressPainter(
                                color: Colors.schedule,
                                title: 'РЕЖИМ',
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
      ]));
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
