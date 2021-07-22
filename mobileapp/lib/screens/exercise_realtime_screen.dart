import 'dart:math';

import 'package:flutter/material.dart' hide Colors, Icon, Image, Padding, Page;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/cardio_switch.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/exercise_catalog_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/hub_screen.dart';
import 'package:hls/screens/video_screen.dart';
import 'package:hls/theme/styles.dart';

class ExerciseRealtimeScreen extends StatefulWidget {
  final ExerciseData item = Get.arguments;

  @override
  _ExerciseRealtimeScreenState createState() => _ExerciseRealtimeScreenState();
}

class _ExerciseRealtimeScreenState extends State<ExerciseRealtimeScreen> {
  _ExerciseRealtimeScreenState() {
    //print('ExerciseRealtimeScreen url: ${item.videoUrl}');
  }

  ExerciseCatalogController get controller =>
      Get.find<ExerciseCatalogController>();

  ExerciseData get item => controller.detail ?? widget.item;

  /// handlers

  /// builders

  Widget _buildPlayerLoading() =>
      SizedBox(height: Size.image, child: Center(child: Loading()));

  Widget _buildPlayer() {
    //print('ExerciseRealtimeScreen._buildPlayer $item');

    return SizedBox(
        height: Size.image,
        width: Size.screenWidth,
        child: item.thumbnailUrl.isNullOrEmpty
            ? Container(
                color: Colors.failure,
                child: Center(
                    child: Icon(FontAwesomeIcons.exclamationCircle,
                        size: Size.iconHuge)))
            : Image(title: item.thumbnailUrl));

    return GetX<VideoScreenController>(
        init: VideoScreenController(url: item.videoUrl, autoPlay: false),
        builder: (controller) {
          // print(
          //     'ExerciseRealtimeScreen._buildPlayer controller: ${controller.isInit}');

          final aspectRatio = //controller.video?.value?.aspectRatio ??
              Size.screenWidth / Size.screenHeight;
          final width = Size.screenWidth;
          final height = Size.screenHeight;

          return controller.isInit
              ? GestureDetector(
                  onTap: controller.toggle,
                  child: Stack(
                      //clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      children: [
                        AbsorbPointer(
                            child: SizedBox(
                                width: width,
                                height: height,
                                child: VlcPlayer(
                                    controller: controller.video,
                                    aspectRatio: aspectRatio))),
                        controller.isInitPlay
                            ? AnimatedOpacity(
                                duration: defaultAnimationDuration,
                                opacity: controller.isPlaying
                                    ? 0
                                    : playerButtonOpacity,
                                child: CircularButton(
                                    // background: Colors.transparent,
                                    // borderColor: Colors.primary,
                                    // color: Colors.primary,
                                    icon: FontAwesomeIcons.solidPlayCircle,
                                    size: Size.buttonBig,
                                    iconSize: .8 * Size.buttonBig,
                                    onPressed: controller.toggle))
                            : Loading()
                      ]))
              : _buildPlayerLoading();
        });
  }
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

  // BetterPlayer.network(
  //     'https://eng-demo.cablecast.tv/segmented-captions/vod.m3u8'
  //     //item.videoUrl,
  //
  //     // betterPlayerConfiguration: BetterPlayerConfiguration(
  //     //   aspectRatio: 16 / 9,
  //     // )
  //     );

  // VimeoPlayer(
  //     id: '233685439', autoPlay: false, loaderColor: Colors.primary);

  Widget _buildBlock({Widget child}) => Container(
      decoration: BoxDecoration(
          color: Colors.background,
          borderRadius: borderRadiusCircular,
          border: Border.all(
              width: borderWidth,
              color: Colors.disabled,
              style: BorderStyle.solid)),
      padding: Padding.content,
      child: child);

  @override
  Widget build(_) => MixinBuilder(
      init: controller,
      initState: (_) => controller..retrieveItem(exerciseId: item.id),
      autoRemove: false,
      dispose: (_) => controller.detail = null,
      builder: (_) => Screen(
          padding: Padding.zero,
          shouldShowDrawer: true,
          title: item.title,
          child: item == null
              ? EmptyPage()
              : SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  if (controller.isAwaiting) Loading(),
                  if (!item.videoUrl.isNullOrEmpty)
                    _buildPlayer()
                  else ...[VerticalSpace(), TextError(noDataText)],
                  Container(
                      padding: Padding.content,
                      child: Column(children: [
                        if (!item.description.isNullOrEmpty) ...[
                          _buildBlock(
                              child: TextPrimary(item.description,
                                  size: Size.fontSmall)),
                          VerticalSpace()
                        ],
                        if (!item.rateChecks.isNullOrEmpty) ...[
                          //CardioMonitor(rateChecks: item.rateChecks),
                          _buildBlock(
                              child: CardioSwitch(rateChecks: item.rateChecks)),
                          VerticalSpace(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Button(
                                    background: Colors.primary,
                                    title: exerciseStartTitle,
                                    onPressed: () async {
                                      if (item.videoUrl.isNullOrEmpty)
                                        return showConfirm(title: noDataText);

                                      // final controller =
                                      //     Get.find<VideoScreenController>();
                                      // if (controller == null)
                                      //   return showConfirm(title: errorGenericText);
                                      //
                                      // controller.start();

                                      // controller.reset();
                                      // controller.play();

                                      Get.toNamed(exerciseVideoRoute,
                                          arguments: item);
                                    })
                              ])
                        ],
                        VerticalSpace(),
                        _buildBlock(child: StatusBlock()),
                        if (!item.pulse.isNullOrEmpty) ...[
                          VerticalSpace(),
                          Accordion(
                              icon: FontAwesomeIcons.infoCircle,
                              title: exerciseZoneTitle,
                              child: Column(children: [
                                VerticalMediumSpace(),
                                for (final p in item.pulse) ...[
                                  Opacity(
                                      opacity: p.isRecommended ? 1 : .2,
                                      child: Heartbeat(
                                          color: p.color,
                                          title: p.title,
                                          description: p.description,
                                          heartbeat: p.heartRate)),
                                  if (p.title != item.pulse.last.title)
                                    VerticalSmallSpace()
                                ],
                                VerticalMediumSpace()
                              ]))
                        ]
                      ]))
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
