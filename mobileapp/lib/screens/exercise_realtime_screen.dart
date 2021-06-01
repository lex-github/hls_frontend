import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart' hide Colors, Icon, Image, Padding, Page;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/exercise_catalog_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/hub_screen.dart';
import 'package:hls/theme/styles.dart';

class ExerciseRealtimeScreen extends StatefulWidget {
  @override
  _State createState() => _State(item: Get.arguments);
}

class _State extends State<ExerciseRealtimeScreen> {
  final ExerciseData item;

  _State({this.item}) {
    print('ExerciseRealtimeScreen ${item.videoUrl}');
  }

  ExerciseCatalogController get controller =>
      Get.find<ExerciseCatalogController>();

  /// handlers

  /// builders

  Widget _buildPlayer() =>
      //VideoPlayer(controller.video)

      // GetBuilder<VideoScreenController>(
      //     init: VideoScreenController(url: item.videoUrl),
      //     builder: (controller) => YoutubePlayer(
      //           //width: Size.screenHeight,
      //           //aspectRatio: 9 / 16,
      //           controller: controller.video,
      //           showVideoProgressIndicator: true,
      //           progressIndicatorColor: Colors.primary,
      //           progressColors: ProgressBarColors(
      //               playedColor: Colors.primary, handleColor: Colors.disabled),
      //           //onReady: () => controller.listener()
      //         ));

      BetterPlayer.network(
          'https://eng-demo.cablecast.tv/segmented-captions/vod.m3u8'
          //item.videoUrl,

          // betterPlayerConfiguration: BetterPlayerConfiguration(
          //   aspectRatio: 16 / 9,
          // )
          );

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: item.title,
      child: item == null
          ? EmptyPage()
          : SingleChildScrollView(
              child: Container(
                  padding: Padding.content,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (!item.videoUrl.isNullOrEmpty || true) _buildPlayer(),
                    VerticalSpace(),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Button(
                          background: Colors.primary, title: exerciseStartTitle)
                    ]),
                    VerticalSpace(),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.background,
                            borderRadius: borderRadiusCircular,
                            border: Border.all(
                                width: borderWidth,
                                color: Colors.disabled,
                                style: BorderStyle.solid)),
                        padding: Padding.content,
                        child: StatusBlock()),
                    if (!item.pulse.isNullOrEmpty) ...[
                      VerticalSpace(),
                      Accordion(
                          icon: FontAwesomeIcons.infoCircle,
                          title: exerciseZoneTitle,
                          child: Column(children: [
                            VerticalMediumSpace(),
                            for (final p in item.pulse) ...[
                              Heartbeat(
                                  color: p.color,
                                  title: p.title,
                                  description: p.description,
                                  heartbeat: p.heartRate),
                              if (p.title != item.pulse.last.title)
                                VerticalSmallSpace()
                            ],
                            VerticalMediumSpace()
                          ]))
                    ]
                  ]))));
}

class Heartbeat extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final String heartbeat;

  Heartbeat({this.color, this.title, this.description, this.heartbeat});

  @override
  Widget build(_) => Container(
      color: color,
      padding: Padding.button,
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextPrimary(title, size: Size.fontTiny),
          TextPrimary(description, size: Size.fontTiny)
        ])),
        HorizontalSpace(),
        TextPrimary(heartbeat, size: Size.fontTiny, weight: FontWeight.w900)
      ]));
}

class Accordion extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  Accordion({this.icon, @required this.title, @required this.child});

  @override
  Widget build(BuildContext context) => GetBuilder<AccordionController>(
      init: AccordionController(),
      builder: (controller) => Button(
          borderColor: Colors.disabled,
          onPressed: controller.toggle,
          child: Column(children: [
            Row(children: [
              if (icon != null) ...[
                Icon(icon, size: Size.icon),
                HorizontalSpace()
              ],
              Expanded(child: TextPrimaryHint(title)),
              HorizontalSpace(),
              Obx(() => Transform.rotate(
                  angle: controller.rotationAngle,
                  child: Icon(FontAwesomeIcons.chevronRight,
                      color: Colors.disabled, size: Size.iconSmall))),
            ]),
            SizeTransition(sizeFactor: controller.sizeFactor, child: child)
          ])));
}

class AccordionController extends GetxController
    with SingleGetTickerProviderMixin {
  AccordionController() {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value);
  }

  // fields
  bool _isOpened = false;

  final minRotationAngle = .0;
  final maxRotationAngle = pi / 2;
  final _animationProgress = .0.obs;
  AnimationController _animationController;

  AnimationController get animationController => _animationController;
  double get animationProgress => _animationProgress.value;
  set animationProgress(double value) => _animationProgress.value = value;

  double get rotationAngle => maxRotationAngle * animationProgress;
  Animation<double> get sizeFactor =>
      Tween<double>(begin: .0, end: 1.0).animate(_animationController);

  toggle() {
    if (_isOpened) {
      _animationController.reverse(from: maxRotationAngle);
    } else {
      _animationController.forward(from: minRotationAngle);
    }

    _isOpened = !_isOpened;
  }

  @override
  onClose() {
    super.onClose();
    _animationController.dispose();
  }
}
