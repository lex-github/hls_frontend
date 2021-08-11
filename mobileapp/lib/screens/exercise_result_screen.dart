import 'package:flutter/material.dart'
    hide Button, Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/exercise_realtime_screen.dart';
import 'package:hls/theme/styles.dart';

class ExerciseResultScreen extends StatefulWidget {
  final ExerciseData data = Get.arguments;

  @override
  _ExerciseResultScreen createState() => _ExerciseResultScreen();
}

class _ExerciseResultScreen extends State<ExerciseResultScreen> {
  ExerciseData get data => widget.data;

  @override
  Widget build(_) => Screen(
      title: "${data.title}. Результаты",
      child: Column(children: [
        Accordion(
            isOpened: true,
            iconWidget: Image(title: 'icons/heart-rate', size: Size.icon),
            title: rateGraphTitle,
            child: Column(children: [

            ])),
        VerticalBigSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Button(
              background: Colors.primary,
              title: exerciseResultButtonTitle,
              onPressed: () => null)
        ])
      ]));
}
