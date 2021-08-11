import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, Text, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/cardio_switch.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/exercise_catalog_controller.dart';
import 'package:hls/controllers/exercise_form_controller.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/screens/video_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ExerciseVideoScreen extends StatefulWidget {
  final ExerciseData data = Get.arguments;

  @override
  _ExerciseVideoScreenState createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  @override
  Widget build(_) => ExerciseVideoScreen_(data: widget.data);
}

class ExerciseVideoScreen_ extends VideoScreen {
  final ExerciseData data;

  ExerciseVideoScreen_({@required this.data}) : super(url: data.videoUrl);

  CardioSwitchController get cardioController =>
      Get.find<CardioSwitchController>();

  // builders

  Widget buildBackButton() => Obx(() => AnimatedOpacity(
      duration: defaultAnimationDuration,
      opacity: controller.isPlaying ? 0 : playerButtonOpacity,
      child: CircularButton(
          size: Size.button,
          background: Colors.failure,
          icon: FontAwesomeIcons.times,
          onPressed: Get.back)));

  Widget _buildInput() => MixinBuilder<ExerciseFormController>(
      init: ExerciseFormController(),
      builder: (formController) => formController.shouldRequestRate
          ? Container(
              decoration: BoxDecoration(color: Colors.background, boxShadow: [
                BoxShadow(
                    color: panelShadowColor,
                    blurRadius: panelShadowBlurRadius,
                    spreadRadius: panelShadowSpreadRadius,
                    offset: -panelShadowOffset)
              ]),
              child: Input<ExerciseFormController>(
                  field: ExerciseFormController.field,
                  inputType: TextInputType.number,
                  isErrorVisible: false,
                  shouldFocus: true,
                  autovalidateMode: formController.shouldValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  contentPadding: EdgeInsets.only(
                      top: Size.verticalTiny,
                      left: Size.horizontal,
                      right: Size.horizontal * 2 + Size.iconSmall,
                      bottom: formController.isKeyboardVisible
                          ? Get.context.mediaQueryViewInsets.bottom
                          : 0)))
          : Nothing());

  @override
  Widget build(_) {
    final cardioController = this.cardioController;
    final exerciseController = Get.find<ExerciseCatalogController>();

    return Material(
        color: Colors.transparent,
        child: GetBuilder<VideoScreenController>(
            init: VideoScreenController(
                url: url,
                autoPlay: true,
                onPlay: cardioController.onPlay,
                onReset: cardioController.onReset,
                onFinish: () async {
                  if (await exerciseController.addRealtime(
                      scheduleId: AuthService.i.profile.schedule.id,
                      exerciseId: data.id,
                      duration: controller.video.value.duration, // TODO: actual duration
                      data: {
                        for (final duration in cardioController.results.keys)
                          "${duration.inHours.toString().padLeft(2, '0')}:"
                          "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
                          "${(duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}":
                              cardioController.results[duration]
                      })) {
                    Get.toNamed(exerciseResultRoute, arguments: data);
                  }
                }),
            dispose: (_) => Get.delete<VideoScreenController>(),
            builder: (controller) => Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(child: Container(color: Colors.black)),
                      Obx(() => controller.isInit
                          ? GestureDetector(
                              onTap: controller.toggle,
                              child: AbsorbPointer(child: buildPlayer()))
                          : Nothing()),
                      Positioned(
                          top: Size.vertical,
                          right: Size.horizontal,
                          child: buildBackButton()),
                      Obx(() => !controller.isInitPlay ||
                              exerciseController.isAwaiting
                          ? Loading()
                          : AnimatedOpacity(
                              duration: defaultAnimationDuration,
                              opacity: controller.isPlaying
                                  ? 0
                                  : playerButtonOpacity,
                              child: CircularButton(
                                  icon: FontAwesomeIcons.solidPlayCircle,
                                  size: Size.buttonHuge,
                                  iconSize: .8 * Size.buttonHuge,
                                  onPressed: controller.toggle))),
                      Positioned(
                          bottom: Size.vertical,
                          child: Obx(() => cardioController.heartRate > 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.heartRate,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(Size.buttonBig / 2))),
                                  width: Size.buttonBig,
                                  height: Size.buttonBig,
                                  child: Center(
                                      child: TextPrimary(
                                          '${cardioController.heartRate}')))
                              : Nothing())),
                      Positioned(
                          bottom: 0, left: 0, right: 0, child: _buildInput())
                    ])));
  }
}
