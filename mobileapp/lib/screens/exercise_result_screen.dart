import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/cardio_switch.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/calendar_model.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/exercise_realtime_screen.dart';
import 'package:hls/theme/styles.dart';

class ExerciseResultScreen extends StatefulWidget {
  final ExerciseData data = Get.arguments;

  @override
  _ExerciseResultScreen createState() => _ExerciseResultScreen();
}

class _ExerciseResultScreen extends State<ExerciseResultScreen> {
  final values = Get.find<CardioSwitchController>().results;
  final c = Get.find<StatsController>();

  ExerciseData get data => widget.data;
  int get average => (values.values.reduce((a, b) => a + b) / values.length).round();

  Map<Duration, int> aggregate(Map<Duration, int> input) {
    // interval in minutes
    final interval = 5;

    // list of heartrates by interval
    final results = Map<int, List<int>>();
    for(final duration in input.keys) {
      final intervalGroup = duration.inMinutes ~/ interval;

      if (!results.containsKey(intervalGroup))
        results[intervalGroup] = <int>[];

      results[intervalGroup].add(input[duration]);
    }

    // average heartrate by duration
    final output = Map<Duration, int>();
    for(final intervalGroup in results.keys)
      output[(intervalGroup * interval).minutes] = results[intervalGroup].average.round();

    return output;
  }

  @override
  Widget build(_) => Screen(
      title: "${data.title}. Результаты",
      child: Column(children: [
        Accordion(
            isOpened: true,
            iconWidget: Image(title: 'icons/heart-rate', size: Size.icon),
            title: heartRateGraphTitle,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VerticalSpace(),
                  RichText(
                      text: TextSpan(
                          style: TextStyle.secondary
                              .copyWith(fontSize: Size.fontTiny),
                          children: <TextSpan>[
                        TextSpan(text: 'Средний пульс: '),
                        TextSpan(
                            text: average.toString(),
                            style: TextStyle.secondaryImportant),
                        TextSpan(text: ' уд./мин.')
                      ])),
                  VerticalTinySpace(),
                  HeartRateGraph(
                    borders: data
                      .recommendedPulse
                      .heartRate
                      .split(' ')
                      .first
                      .split('-')
                      .map(int.parse)
                      .toList(growable: false),
                    values: aggregate(values))
                  // HeartRateGraph(values: {
                  //   Duration(minutes: 10): 140,
                  //   Duration(minutes: 20): 160,
                  //   Duration(minutes: 30): 120,
                  //   Duration(minutes: 40): 100,
                  //   Duration(minutes: 50): 180,
                  //   Duration(minutes: 60): 80,
                  //   Duration(minutes: 70): 60
                  // })
                ])),
        VerticalBigSpace(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Button(
              background: Colors.primary,
              title: exerciseResultButtonTitle,
              onPressed: () =>   findLoop,
          )
        ])
      ]));
  void findLoop() {
    for (var i = 0; i < c.calendar.length; i++) {
      if (c.calendar[i].date == dateToString(date: DateTime.now(), output: dateInternalFormat)) {
        Get.toNamed(statsTabRoute, arguments: {'index': i, 'date': dateToString(date: DateTime.now(), output: dateInternalFormat)});
      }
    }
  }
}

class HeartRateGraph extends StatelessWidget {
  //final pointSize = Size.icon;
  final pointSize = .65 * Size.horizontalTiny;
  // Map<int, double> get values =>
  //   AuthService?.i?.profile?.progress?.healthHistory;

  final minutes = [0, 10, 20, 30, 40, 50, 60];
  final rates = [60, 80, 100, 120, 140, 160, 180];

  final List<int> borders;// = [70, 100];
  final Map<Duration, int> values;

  HeartRateGraph({this.borders, this.values}) {
    print("HeartRateGraph borders: $borders values: $values");
  }

  double rateRatio(int rate) =>
      1 - (rate - rates.first) * 1 / (rates.last - rates.first);

  double ordinate(int value) {
    final valueLast = rates.last;
    final relativeValue = 1 / (valueLast - rates.first) * (value - rates.first);
    return relativeValue;
  }

  double abscissa(Duration value) {
    //final minutesLast = minutes.last;
    //final minutesLast = 82;
    final minutesLast = 75;
    final relativeValue =
        1 / (minutesLast - minutes.first) * (value.inMinutes - minutes.first);
    return relativeValue;
  }

  // builders

  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ordinate indicators
        Container(
            height: (1 + 1/(rates.length - 1)) * Size.graph,
            //color: Colors.nutrition.withOpacity(.1),
            child: Transform.translate(
                offset: Offset(.0, -Size.fontTiny / 2),
                //offset: Offset(0, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final i in rates.reversed)
                        Container(
                            width: 1.8 * Size.fontTiny,
                            child: TextSecondary('$i',
                                color: Colors.light,
                                size: .8 * Size.fontTiny,
                                align: TextAlign.left)),
                      Nothing()
                    ]))),
        HorizontalTinySpace(),
        Expanded(
            child: Column(children: [
          Container(
              height: Size.graph,
              child: Stack(
                  alignment: Alignment.bottomLeft,
                  clipBehavior: Clip.none,
                  children: [
                    // vertical lines
                    for (int i = 0; i < rates.length; i++)
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: Size.graph / (rates.length - 1) * i,
                          child: Container(
                              height: 0,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.disabled,
                                          width: Size.border))))),
                    Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                            //color: Colors.exercise.withOpacity(.25),
                            child: CustomPaint(
                                painter: HeartRateGraphPainter(borders: [
                              for (int border in borders) rateRatio(border)
                            ], values: [
                                  if (!values.isNullOrEmpty)
                                    for (final MapEntry<Duration, int> point
                                    in values.entries)
                                      Offset(abscissa(point.key), ordinate(point.value))
                                ], pointSize: pointSize))))
                  ])),
          VerticalTinySpace(),
          // abscissa indicators
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (final i in minutes)
              Container(
                  width: 1.2 * Size.fontTiny,
                  child: TextSecondary('$i',
                      color: Colors.light,
                      size: .8 * Size.fontTiny,
                      align: TextAlign.left)),
            Container(
                width: 2 * Size.fontTiny,
                child: TextSecondary(heartRateAbscissaLabel,
                    color: Colors.light,
                    size: .8 * Size.fontTiny,
                    align: TextAlign.left))
          ])
        ]))
      ]);


}

