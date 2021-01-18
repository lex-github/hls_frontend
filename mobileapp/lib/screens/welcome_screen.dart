import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/welcome_controller.dart';
import 'package:hls/theme/styles.dart';

class WelcomeScreen<Controller extends WelcomeController>
    extends GetView<Controller> {
  // builders

  Widget _buildIndicator({bool isSelected = true}) =>
      ((double size) => AnimatedContainer(
          decoration: BoxDecoration(
              color: isSelected ? Colors.primary : Colors.disabled,
              borderRadius: BorderRadius.circular(size / 2)),
          height: isSelected ? sliderIndicatorHeightCoefficient * size : size,
          width: isSelected ? sliderIndicatorWidthCoefficient * size : size,
          duration: defaultAnimationDuration))(.8 * Size.horizontalSmall);

  @override
  Widget build(_) => GetBuilder<Controller>(
      init: WelcomeController() as Controller,
      dispose: (_) => Get.delete<Controller>(),
      builder: (_) => Screen(
          fab: CircularButton(
              icon: Icons.arrow_forward_ios,
              iconSize: Size.iconSmall,
              onPressed: () => controller.next()),
          padding: Padding.zero,
          leading: Nothing(),
          shouldHaveAppBar: false,
          child: Column(children: [
            Flexible(
                flex: 5,
                child: CustomPaint(
                    painter: WelcomePainter(),
                    child: ClipPath(
                        clipper: WelcomeClipper(),
                        child: Container(
                            color: Colors.background,
                            child: Center(
                                child: Obx(() => AnimatedSwitcher(
                                    duration: defaultAnimationDuration,
                                    child: Image(
                                        key: ValueKey(
                                            controller.slide.imageTitle),
                                        title:
                                            controller.slide.imageTitle)))))))),
            Flexible(
                flex: 3,
                child: Center(
                    child: Container(
                        padding: Padding.content,
                        child: Obx(() => AnimatedSwitcher(
                            duration: defaultAnimationDuration,
                            child: TextPrimaryHint(controller.slide.text,
                                key: ValueKey(controller.slide.text),
                                align: TextAlign.center)))))),
            Container(
                padding: EdgeInsets.only(left: Size.horizontal),
                height: Size.fab,
                child: Obx(() => Row(children: [
                      for (final i
                          in Iterable<int>.generate(controller.length)) ...[
                        _buildIndicator(isSelected: i == controller.index),
                        if (i != controller.length - 1) HorizontalTinySpace()
                      ]
                    ]))),
            VerticalSpace()
          ])));
}

Path _path(M.Size size) {
  final r = Size.height(welcomeClipRadius);
  final path = Path();
  path.arcTo(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height - r), radius: r),
      0,
      pi,
      false);
  return path..close();
}

class WelcomePainter extends CustomPainter {
  @override
  void paint(canvas, size) =>
      canvas.drawShadow(_path(size), Colors.shadow.withOpacity(.5), 2.0, false);

  @override
  bool shouldRepaint(_) => false;
}

class WelcomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(size) => _path(size);

  @override
  bool shouldReclip(_) => false;
}
