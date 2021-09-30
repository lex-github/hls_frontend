import 'dart:async';

import 'package:flutter/material.dart' hide Colors, Padding;
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:hls/components/cardio_switch.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/theme/styles.dart';

class CardioHealth extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CardioHealth> {
  CardioHealthController get controller => Get.find<CardioHealthController>();

  @override
  Widget build(_) => GetX(
      init: CardioHealthController(),
      builder: (_) => controller.isAwaiting
          ? Center(child: Loading())
          : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              if (!controller.message.isNullOrEmpty) ...[
                Center(child: TextError(controller.message)),
                VerticalSmallSpace()
              ] else if (controller.isConnected) ...[
                Center(
                    child: TextPrimary('❤️ -> ${controller.heartRate}',
                        color: Colors.primary, size: Size.fontTiny)),
                VerticalSmallSpace()
              ]
            ]));
}

class CardioHealthController extends Controller {
  final HealthFactory health = HealthFactory();
  final List<HealthDataType> types = [HealthDataType.HEART_RATE];

  final _isAwaiting = false.obs;
  bool get isAwaiting => _isAwaiting.value;

  final _message = ''.obs;
  String get message => _message.value;

  final _heartRate = 0.obs;
  int get heartRate => _heartRate.value;

  bool get isConnected => !isAwaiting && heartRate > 0;

  Timer _timer;
  final _duration = const Duration(seconds: 5);
  final _backDuration = const Duration(minutes: 5);

  @override
  void onInit() {
    print('CardioMonitorController.onInit');

    scan();

    super.onInit();
  }

  Future scan() async {
    _isAwaiting.value = true;

    /// you MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);
    print('CardioMonitorController.scan accessWasGranted: $accessWasGranted');

    _isAwaiting.value = false;

    if (accessWasGranted) {
      startTimer();
    } else {
      _message.value = 'Permission not granted';
    }
  }

  void startTimer() {
    _timer = Timer.periodic(_duration, (_) => readValue());
  }

  void stopTimer() {
    _timer.cancel();
  }

  void readValue() async {
    List<HealthDataPoint> healthData;

    try {
      final currentTime = DateTime.now();
      final secondAgo = currentTime.subtract(_backDuration);

      /// fetch new data
      healthData =
          await health.getHealthDataFromTypes(secondAgo, DateTime.now(), types);
    } catch (e) {
      print('Caught exception in getHealthDataFromTypes: $e');
    }

    /// filter out duplicates
    healthData = HealthFactory.removeDuplicates(healthData);

    /// Print the results
    print('CardioMonitorController.health: $healthData');
    if (healthData.length > 0) {
      _heartRate.value = healthData.last.value.toInt();
      _message.value = '';

      Get.find<CardioSwitchController>().heartRate = heartRate;
    } else {
      _heartRate.value = 0;
      _message.value = 'No heartbeat detected';
    }
  }

  @override
  void onClose() async {
    print('CardioMonitorController.onClose');

    stopTimer();

    super.onClose();
  }
}
