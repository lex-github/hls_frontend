import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/models/chat_card_model.dart';

class TimerController extends GetxController {
  final ChatCardData card;
  TimerController({@required this.card}) {
    //card.addons.duration = 2;
    _time.value = DateTime(0, 0, 0, 0, 0, card.addons.duration);
  }

  Timer _timer;

  // getters

  final _time = DateTime(0).obs;
  DateTime get time => _time.value;

  double get completion =>
      (card.addons.duration - time.minute * 60 - time.second) /
      card.addons.duration;

  final _timerIsRunning = false.obs;
  bool get timerIsRunning => _timerIsRunning.value;

  bool get shouldRequireResult => card.addons.shouldRequireResult;

  final _shouldShowForm = false.obs;
  bool get shouldShowForm => _shouldShowForm.value;

  // methods

  _finish([value = '']) {
    /// TODO: demand input
    _timer?.cancel();

    if (!shouldRequireResult)
      Get.back(result: value);
    else
      _shouldShowForm.value = true;
  }

  start() {
    //print('seconds: ${card.addons.duration}');

    _shouldShowForm.value = false;
    _timerIsRunning.value = true;
    _time.value = DateTime(0, 0, 0, 0, 0, card.addons.duration);
    _timer?.cancel();
    _timer = Timer.periodic(timerDuration, (_) {
      if (!time.isAfter(DateTime(0, 0, 0))) {
        _finish();

        _timerIsRunning.value = false;
        _time.value = DateTime(0, 0, 0, 0, 0, card.addons.duration);
        return;
      }

      _time.value = _time.value.subtract(timerDuration);
    });
  }

  stop() => _finish();

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
  }
}
