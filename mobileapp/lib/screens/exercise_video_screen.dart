import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
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
          onPressed: () {
            controller.pause();
            controller.reset();
            Get.back();
          })));

  @override
  Widget build(_) =>
      Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
        Positioned.fill(child: Container(color: Colors.black)),
        GestureDetector(
            onTap: controller.toggle,
            child: Transform.scale(
                scale: 1, //Size.screenHeight / Size.screenWidth,
                child: Transform.rotate(
                    angle: controller.video.value.aspectRatio > 1 ? pi / 2 : .0,
                    child: buildPlayer()))),
        if (controller.video.value.aspectRatio > 1)
          Positioned(
              bottom: Size.vertical,
              right: Size.horizontal,
              child: Transform.rotate(angle: pi / 2, child: buildBackButton()))
        else
          Positioned(
              top: Size.vertical,
              right: Size.horizontal,
              child: buildBackButton()),
        Obx(() => AnimatedOpacity(
            duration: defaultAnimationDuration,
            opacity: controller.isPlaying ? 0 : playerButtonOpacity,
            child: CircularButton(
                icon: FontAwesomeIcons.play, onPressed: controller.toggle)))
      ]);
}
