import 'package:flutter/material.dart' hide Colors, Icon, Padding, Size, Text;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/cardio_health.dart';
import 'package:hls/components/cardio_monitor.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/exercise_form_controller.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/screens/video_screen.dart';
import 'package:hls/theme/styles.dart';

class CardioSwitch extends StatefulWidget {
  final List<Duration> rateChecks;

  CardioSwitch({@required this.rateChecks});

  @override
  _CardioSwitchState createState() => _CardioSwitchState();
}

class _CardioSwitchState extends State<CardioSwitch> {
  List<Duration> get rateChecks => widget.rateChecks;
  CardioSwitchController get controller => Get.find<CardioSwitchController>();

  @override
  Widget build(BuildContext context) => GetX(
      init: CardioSwitchController(rateChecks: rateChecks),
      builder: (_) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final type in CardioInputType.values) ...[
              Clickable(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                      controller.type == type
                          ? FontAwesomeIcons.checkCircle
                          : FontAwesomeIcons.circle,
                      size: Size.iconSmall),
                  // Checkbox(
                  //     value: controller.type == type, onChanged: (value) => null),
                  HorizontalMediumSpace(),
                  TextPrimary(type.title)
                ]),
                onPressed: () => controller.type = type,
              ),
              if (controller.type == type) ...[
                if (type != CardioInputType.MANUAL) VerticalMediumSpace(),
                if (type == CardioInputType.MONITOR)
                  CardioMonitor(),
                if (type == CardioInputType.HEALTH)
                  CardioHealth()
              ],
              if (type != CardioInputType.values.last) VerticalMediumSpace()
            ]
          ]));
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
  const CardioInputType({int value, String title})
      : super(value: value, title: title);

  static const OTHER = CardioInputType(value: 0, title: '');
  static const MANUAL =
      CardioInputType(value: 1, title: cardioInputTypeManualTitle);
  static const MONITOR =
      CardioInputType(value: 2, title: cardioInputTypeMonitorTitle);
  static const HEALTH =
      CardioInputType(value: 3, title: cardioInputAppleHealthTitle);

  static const values = [MONITOR, HEALTH, MANUAL];

  @override
  String toString() => '$value';
}
