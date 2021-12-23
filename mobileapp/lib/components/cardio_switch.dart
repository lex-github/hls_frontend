import 'package:flutter/material.dart'
    hide Colors, Icon, Padding, Size, Text, Image;
import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/cardio_health.dart';
import 'package:hls/components/cardio_monitor.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/exercise_form_controller.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/video_screen.dart';
import 'package:hls/theme/styles.dart';

class CardioSwitch extends StatefulWidget {
  final List<Duration> rateChecks;
  final ExerciseData item;

  CardioSwitch({@required this.rateChecks, @required this.item});

  @override
  _CardioSwitchState createState() => _CardioSwitchState();
}

class _CardioSwitchState extends State<CardioSwitch> {
  List<Duration> get rateChecks => widget.rateChecks;
  ExerciseData get item => widget.item;

  CardioSwitchController get controller => Get.find<CardioSwitchController>();



  @override
  Widget build(BuildContext context) => GetX(
      init: CardioSwitchController(rateChecks: rateChecks),
      builder: (_) => Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final type in CardioInputType.values) ...[
                  Clickable(
                    child: Column(
                      children: [
                        controller.type == type
                            ? Container(
                          width: Size.horizontal * 5,
                          decoration: BoxDecoration(
                              color: Colors.background,
                              borderRadius: borderRadiusCircular,
                              border: Border.all(
                                  width: borderWidth,
                                  color: Colors.water,
                                  style: BorderStyle.solid)),
                          padding: Padding.content * .4,
                          child: Column(
                            children: [
                              Image(
                                title: type.title == cardioInputAppleHealthTitle ? (Platform.isIOS ? "image2vector" : "https://upload.wikimedia.org/wikipedia/commons/d/dc/Google_Fit_icon_%282018%29.svg") : type.imageTitle,
                                width: Size.horizontal * 3,
                                height: Size.horizontal * 3,                                    ),
                              VerticalTinySpace(),
                              TextPrimary(
                                type.title == cardioInputAppleHealthTitle ? (Platform.isIOS ? cardioInputAppleHealthTitle : cardioInputGoogleHealthTitle) : type.title,
                                size: Size.fontSmall * .9,
                              )
                            ],
                          ),
                        )
                            : Container(
                          width: Size.horizontal * 5,
                          decoration: BoxDecoration(
                              color: Colors.background,
                              borderRadius: borderRadiusCircular,
                              border: Border.all(
                                  width: borderWidth,
                                  color: Colors.disabled,
                                  style: BorderStyle.solid)),
                          padding: Padding.content * .4,
                          child: Column(
                            children: [
                              Image(
                                title: type.title == cardioInputAppleHealthTitle ? (Platform.isIOS ? "apple-health" : googleFitUrl) : type.imageTitle,
                                // size: Size.horizontal * 3,
                                width: Size.horizontal * 3,
                                height: Size.horizontal * 3,
                              ),
                              VerticalTinySpace(),
                              TextPrimary(
                                type.title == cardioInputAppleHealthTitle ? (Platform.isIOS ? cardioInputAppleHealthTitle : cardioInputGoogleHealthTitle) : type.title,
                                size: Size.fontSmall * .9,
                              )
                            ],
                          ),
                        ),
                        if (controller.type == type) ...[
                          if (type != CardioInputType.MANUAL)
                            VerticalMediumSpace(),
                          if (type == CardioInputType.MONITOR) CardioMonitor(),
                          if (type == CardioInputType.HEALTH) CardioHealth()
                        ],
                        if (type != CardioInputType.values.last)
                          VerticalMediumSpace()
                      ],
                    ),

                    // AnimatedCrossFade(
                    // duration: Platform.isIOS ? Duration.zero : defaultAnimationDuration,
                    //     crossFadeState:
                    //     controller.type == type ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    //     firstCurve: Curves.easeInCirc,
                    //     secondCurve: Curves.easeOutCirc,
                    //     // firstChild: ButtonInner(
                    //     //     background: background,
                    //     //     borderColor: borderColor,
                    //     //     padding: padding,
                    //     //     size: size,
                    //     //     child: _buildChild(),
                    //     //     isCircular: isCircular),
                    //     // secondChild: ButtonOuter(
                    //     //     background: isDisabled ? Colors.disabled : background,
                    //     //     borderColor: borderColor,
                    //     //     padding: padding,
                    //     //     size: size,
                    //     //     child: _buildChild(),
                    //     //     isClickable: !isDisabled,
                    //     //     isCircular: isCircular)
                    // ),
                    // Button(
                    //   isSwitch: true,
                    //   child: Column(
                    //     children: [
                    //       Image(title: 'hands', size: Size.iconBig),
                    //       TextPrimary(
                    //         "Вручную",
                    //         size: Size.fontSmall,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    //
                    //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    //   Icon(
                    //       controller.type == type
                    //           ? FontAwesomeIcons.checkCircle
                    //           : FontAwesomeIcons.circle,
                    //       size: Size.iconSmall),
                    //   // Checkbox(
                    //   //     value: controller.type == type, onChanged: (value) => null),
                    //   HorizontalMediumSpace(),
                    //   TextPrimary(type.title == cardioInputAppleHealthTitle ||
                    //           type.title == cardioInputAppleHealthTitle
                    //       ? (Platform.isIOS
                    //           ? cardioInputAppleHealthTitle
                    //           : cardioInputGoogleHealthTitle)
                    //       : type.title)
                    //   // TextPrimary(type.title)
                    // ]
                    //     ),
                    onPressed: () => controller.type = type,
                  ),
                ]
              ]),
          VerticalSmallSpace(),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.type.isNullEmptyFalseOrZero ? Button(
                    background: Colors.disabled,
                    title: exerciseStartTitle,
                    onPressed: () async {
                    }) :  Button(
                    background: Colors.primary,
                    title: exerciseStartTitle,
                    onPressed: () async {
                      // if (item.videoUrl.isNullOrEmpty)
                      //   return showConfirm(title: noDataText);

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
              ]),

        ],
      ));
}

class CardioSwitchController extends Controller {
  CardioSwitchController({@required this.rateChecks});

  final _type = Rx<CardioInputType>(null);

  CardioInputType get type => _type.value;

  set type(value) => _type.value = value;

  final List<Duration> rateChecks;
  final List<Duration> rateChecksCopy = [];
  final Map<Duration, int> results = {};

  final _heartRate = 0.obs;

  int get heartRate => _heartRate.value;

  set heartRate(value) => _heartRate.value = value;

  void onReset() {
    if (rateChecks.isNullOrEmpty) {
      print('CardioMonitorController.onReset rate checks null or empty!');

      return;
    }

    rateChecksCopy.clear();
    rateChecksCopy.addAll(rateChecks);
    results.clear();
  }

  void onPlay(Duration position) {
    //print('=====');
    //print('CardioMonitorController.onPlay position: $position checks: $rateChecksCopy');

    // for manual input type read at fixed checks
    if (type == CardioInputType.MANUAL) {
      Duration checkToRemove;
      for (final check in rateChecksCopy) {
        //print('CardioMonitor.onPlay check: $check');

        if (check.compareTo(position) <= 0) {
          print('CardioMonitorController.onPlay position reached: $position');
          readResult(check);

          checkToRemove = check;

          break;
        }

        // print('CardioMonitorController.onPlay $check bigger than $position');
        // print('-----');
      }

      if (checkToRemove != null) {
        //print('CardioMonitorController.onPlay checkToRemove: $checkToRemove');

        rateChecksCopy.remove(checkToRemove);
      }
      // for auto input type read each checkRate seconds
    } else {
      final seconds = position.inSeconds;
      final check = seconds.seconds;
      final checkRate = 5;

      if (seconds % checkRate == 0) {
        if (!results.containsKey(check)) {
          print('CardioSwitch.onPlay seconds: $seconds');
          readResult(check);
        }
      }
    }
  }

  void readResult(Duration position) async {
    /// TODO: read based on type (?)
    int rate = heartRate;

    // manual reading
    if (rate == 0 || type == CardioInputType.MANUAL) {
      final videoController = Get.find<VideoScreenController>();
      final formController = Get.find<ExerciseFormController>();

      videoController.pause();

      rate = await formController.requestRate();

      print('CardioMonitorController.readResult rate: $rate');

      videoController.play();
    }

    results[position] = rate;
  }
}

class CardioInputType extends GenericEnum<int> {
  const CardioInputType({int value, String title, String imageTitle})
      : super(value: value, title: title, imageTitle: imageTitle);

  static const OTHER = CardioInputType(value: 0, title: '');
  static const MANUAL = CardioInputType(
      value: 1, title: cardioInputTypeManualTitle, imageTitle: "hands");
  static const MONITOR = CardioInputType(
      value: 2, title: cardioInputTypeMonitorTitle, imageTitle: "blue");
  static const HEALTH = CardioInputType(
      value: 3, title: cardioInputAppleHealthTitle, imageTitle: "apple-health");

  static const values = [MONITOR, HEALTH, MANUAL];

  @override
  String toString() => '$value';
}
