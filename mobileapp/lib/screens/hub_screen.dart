import 'dart:math';

import 'package:flutter/material.dart'
    hide Card, Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/post_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/post_model.dart';
import 'package:hls/theme/styles.dart';

final radius = Size.screenWidth / 1.4;
final outerRadius = radius + Size.vertical * 2;
final angle = 2 * pi / 3;
final startAngle = -pi / 2;

class HubScreen extends StatelessWidget {
  // builders

  Widget _buildSector(
          {String title, Color color, double value, double startAngle}) =>
      CustomPaint(
          size: M.Size(outerRadius, outerRadius),
          painter: SectorProgressPainter(
              color: color,
              title: title,
              value: value,
              endAngle: angle,
              startAngle: startAngle));

  Widget _buildButton({String title, Color color}) => Expanded(
      child: Clickable(
          child: Button(
              padding: EdgeInsets.symmetric(vertical: Padding.button.top),
              title: title,
              borderColor: color,
              titleStyle: M.TextStyle(fontSize: Size.fontTiny))));

  Widget _buildItem(PostData item, {bool isHalf = false}) => Card(
      type: item.type,
      title: item.title,
      imageTitle: item.imageUrl,
      isHalf: item.isHalf || isHalf,
      duration: item.duration,
      onPressed: () {
        switch(item.type) {
          case PostType.ARTICLE:
            Get.toNamed(articleRoute, arguments: item);
            break;
          case PostType.STORY:
            Get.toNamed(storyRoute, arguments: item.stories);
            break;
          case PostType.VIDEO:
            Get.toNamed(videoRoute, arguments: item.videoUrl);
            break;
        }
      });

  Widget _buildNewsList() => GetX<PostController>(
      init: PostController(),
      builder: (controller) => !controller.isInit && controller.isAwaiting
          ? Loading()
          : controller.list.isBlank && false
              ? Nothing()
              : Column(children: [
                  VerticalBigSpace(),
                  for (int i = 0; i < controller.list.length; i++)
                    ...((PostData item) => !item.isHalf
                        ? [
                            _buildItem(item),
                            if (item != controller.list.last) VerticalSpace()
                          ]
                        : [
                            Row(children: [
                              Expanded(child: _buildItem(item)),
                              HorizontalSpace(),
                              ((PostData item) => item == null
                                      ? Nothing()
                                      : Expanded(
                                          child:
                                              _buildItem(item, isHalf: true)))(
                                  controller.list.get(++i))
                            ]),
                            if (i < controller.list.length - 1) VerticalSpace()
                          ])(controller.list[i]),
                  // Card(
                  //     title: 'ПРОДУКТЫ ЧЕМПИОНЫ Ч.3',
                  //     imageTitle: 'https://placeimg.com/640/480/any',
                  //     onPressed: () => Get.toNamed(articleRoute,
                  //         arguments: PostData()
                  //           ..title = 'ПРОДУКТЫ ЧЕМПИОНЫ Ч.3'
                  //           ..imageUrl = 'https://placeimg.com/640/480/any')),
                  // VerticalSpace(),
                  // Row(children: [
                  //   Expanded(
                  //       child:
                  //           Card(title: 'КУРЕНИЕ НАЧАЛО КОНЦА', isHalf: true)),
                  //   HorizontalSpace(),
                  //   Expanded(
                  //       child: Card(title: 'ЧЕМ СИЛЕН СЕЛЕН?', isHalf: true))
                  // ]),
                  // VerticalSpace(),
                  // Card(title: 'НАШ ОРГАНИЗМ И ВЛИЯНИЕ НА НЕГО НАШЕГО РАЦИОНА')
                ]));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: hubScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Icon(Icons.notifications)),
      child: SingleChildScrollView(
          child: Column(children: [
        VerticalBigSpace(),
        GetBuilder<HubController>(
            init: HubController(),
            builder: (controller) =>
                Stack(alignment: Alignment.center, children: [
                  RotationTransition(
                      turns: Tween(begin: .0, end: 1.0)
                          .animate(controller.animationController),
                      child: Stack(alignment: Alignment.center, children: [
                        _buildSector(
                            title: scheduleTitle,
                            color: Colors.schedule,
                            value: .63,
                            startAngle: startAngle),
                        _buildSector(
                            title: nutritionTitle,
                            color: Colors.nutrition,
                            value: .38,
                            startAngle: startAngle + angle),
                        _buildSector(
                            title: exerciseTitle,
                            color: Colors.exercise,
                            value: .81,
                            startAngle: startAngle + angle * 2)
                      ])),
                  CircularProgress(
                      size: radius,
                      child: Text('64%',
                          style: TextStyle.primary
                              .copyWith(fontSize: Size.fontPercent)))
                ])),
        VerticalBigSpace(),
        VerticalBigSpace(),
        Row(children: [
          HorizontalSpace(),
          _buildButton(title: scheduleTitle, color: Colors.schedule),
          HorizontalSmallSpace(),
          _buildButton(title: nutritionTitle, color: Colors.nutrition),
          HorizontalSmallSpace(),
          _buildButton(title: exerciseTitle, color: Colors.exercise),
          HorizontalSpace()
        ]),
        VerticalSpace(),
        Container(
            color: Colors.background,
            padding: Padding.content,
            child: Column(
                children: [StatusBlock(), VerticalSpace(), _buildNewsList()]))
      ])));
}

class StatusBlock extends StatelessWidget {
  // builders

  Widget _buildRow({String title, String text}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextSecondary('$title:'),
        TextPrimary(text, size: Size.fontSmall, align: TextAlign.right)
      ]);

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildRow(title: goalTitle, text: 'Похудение'),
        VerticalMediumSpace(),
        _buildRow(title: macrocycleTitle, text: 'Оздоровительный'),
        VerticalMediumSpace(),
        _buildRow(
            title: '$microcycleTitle\n(2м /16 тр)',
            text: 'Первый\n(подготовительный)'),
        VerticalMediumSpace(),
        _buildRow(title: weekTitle, text: '2/8'),
        VerticalMediumSpace(),
        _buildRow(title: trainingTitle, text: '3/16')
      ]);
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
