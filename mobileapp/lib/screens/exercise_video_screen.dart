import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/video_screen.dart';
import 'package:hls/theme/styles.dart';

class ExerciseVideoScreen extends VideoScreen {
  final ExerciseData data;

  ExerciseVideoScreen()
      : data = Get.arguments,
        super(url: Get.arguments.videoUrl);

  // builders

  Widget buildBackButton() => Obx(() => AnimatedOpacity(
      duration: defaultAnimationDuration,
      opacity: controller.isPlaying ? 0 : playerButtonOpacity,
      child: CircularButton(
          size: Size.button,
          background: Colors.failure,
          icon: FontAwesomeIcons.times,
          onPressed: Get.back)));

  @override
  Widget build(_) => GetBuilder<VideoScreenController>(
      init: VideoScreenController(url: url, autoPlay: true),
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
                Obx(() => !controller.isInitPlay
                    ? Loading()
                    : AnimatedOpacity(
                        duration: defaultAnimationDuration,
                        opacity: controller.isPlaying ? 0 : playerButtonOpacity,
                        child: CircularButton(
                            icon: FontAwesomeIcons.solidPlayCircle,
                            size: Size.buttonHuge,
                            iconSize: .8 * Size.buttonHuge,
                            onPressed: controller.toggle)))
              ]));
}
