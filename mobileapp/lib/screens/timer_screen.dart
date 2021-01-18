import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/timer_controller.dart';
import 'package:hls/controllers/timer_form_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/theme/styles.dart';

class TimerScreen<Controller extends TimerController>
    extends GetView<Controller> {
  // builders

  _buildForm() => GetBuilder<TimerFormController>(
      init: TimerFormController(),
      builder: (form) => Container(
          padding: Padding.content,
          child: Obx(() =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Input<TimerFormController>(field: 'input', shouldFocus: true),
                if (!form.isKeyboardVisible) ...[
                  VerticalBigSpace(),
                  CircularButton(
                      size: Size.buttonTimer,
                      title: timerRestart,
                      titleStyle:
                          TextStyle.buttonTimer.copyWith(color: Colors.primary),
                      background: Colors.light,
                      onPressed: controller.start)
                ]
              ]))));

  _buildTimer() => Stack(children: [
        Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => AnimatedContainer(
                color: Colors.primary,
                height: Size.screenHeight * controller.completion,
                duration: timerDuration))),
        Column(children: [
          Expanded(
              child: Center(
                  child: Obx(() => TextTimer(dateToString(
                      date: controller.time, output: dateTimeSeconds))))),
          Obx(() => controller.timerIsRunning
              ? controller.shouldRequireResult
                  ? CircularButton(
                      size: Size.buttonTimer,
                      title: timerRestart,
                      titleStyle:
                          TextStyle.buttonTimer.copyWith(color: Colors.primary),
                      background: Colors.light,
                      onPressed: controller.start)
                  : CircularButton(
                      size: Size.buttonTimer,
                      title: timerStop,
                      titleStyle:
                          TextStyle.buttonTimer.copyWith(color: Colors.primary),
                      background: Colors.light,
                      onPressed: controller.stop)
              : CircularButton(
                  size: Size.buttonTimer,
                  title: timerStart,
                  titleStyle: TextStyle.buttonTimer,
                  onPressed: controller.start)),
          VerticalBigSpace()
        ])
      ]);

  @override
  Widget build(_) => Screen(
      shouldResize: true,
      padding: Padding.zero,
      shouldHaveAppBar: false,
      child: GetBuilder<Controller>(
          init: TimerController(card: Get.arguments) as Controller,
          builder: (_) => Obx(
              () => controller.shouldShowForm ? _buildForm() : _buildTimer())));
}
