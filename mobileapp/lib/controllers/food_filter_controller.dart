import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/food_filter_model.dart';

class FoodFilterController<Data extends FoodFilterData> extends Controller
    with SingleGetTickerProviderMixin {
  FoodFilterController() {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value);
  }

  // fields

  final minRotationAngle = .0;
  final maxRotationAngle = pi / 2;
  final _animationProgress = .0.obs;
  final List<Data> _openedItems = [];
  final _lastToggledItem = Rx<Data>();
  List<Data> list;
  AnimationController _animationController;

  AnimationController get animationController => _animationController;
  double get animationProgress => _animationProgress.value;
  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;

  // methods

  bool isOpened(Data item) =>
      _openedItems.firstWhere((x) => item.key == x.key, orElse: () => null) !=
      null;

  double getRotationAngle(Data item) => item.key == _lastToggledItem.value?.key
      ? rotationAngle
      : isOpened(item)
          ? maxRotationAngle
          : minRotationAngle;

  Animation<double> getSizeFactor(Data item) =>
      item.key == _lastToggledItem.value?.key
          ? Tween<double>(begin: .0, end: 1.0).animate(_animationController)
          : AlwaysStoppedAnimation(isOpened(item) ? 1.0 : .0);

  toggle(Data item) {
    _lastToggledItem(item);

    if (isOpened(item)) {
      _openedItems.remove(item);
      _animationController.reverse(from: maxRotationAngle);
    } else {
      _openedItems.add(item);
      _animationController.forward(from: minRotationAngle);
    }

    //update();
  }

  @override
  void onInit() async {
    await retrieve();
    super.onInit();
  }

  @override
  onClose() {
    super.onClose();
    _animationController.dispose();
  }

  Future retrieve() async {
    final result = await query(foodFilterQuery);
    print('FoodFilterController.retrieve result: $result');

    list = result
        .get<List>('foodFiltersList')
        .map((x) => FoodFilterData.fromJson(x))
        .toList(growable: false);
    update();
  }
}
