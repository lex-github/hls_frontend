import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/food_model.dart';

class FoodController extends Controller with SingleGetTickerProviderMixin {
  final int id;
  FoodController({@required this.id}) {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value);
  }

  // fields

  final minRotationAngle = .0;
  final maxRotationAngle = pi / 2;
  final List<String> _openedItems = [];
  final _animationProgress = .0.obs;
  final _lastToggledItem = Rx<String>();
  AnimationController _animationController;
  FoodData item;

  Map<String, List<FoodSectionData>> get list => item.sections ?? [];
  AnimationController get animationController => _animationController;
  double get animationProgress => _animationProgress.value;
  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;

  // methods

  String getTitle(int index) => list.keys.toList(growable: false)[index];
  List<FoodSectionData> getSection(int index) =>
      list.values.toList(growable: false)[index];

  bool isOpened(String title) => _openedItems.contains(title);
  double getRotationAngle(String title) => title == _lastToggledItem.value
      ? rotationAngle
      : isOpened(title)
          ? maxRotationAngle
          : minRotationAngle;

  // double getSizeFactor(FoodCategoryData item) {
  //   final factor = animationProgress; // make sure call rxValue not to upset obx
  //   return item == _lastToggledItem
  //       ? factor
  //       : isOpened(item)
  //           ? 1
  //           : 0;
  // }

  Animation<double> getSizeFactor(String title) =>
      title == _lastToggledItem.value
          ? Tween<double>(begin: .0, end: 1.0).animate(_animationController)
          : AlwaysStoppedAnimation(isOpened(title) ? 1.0 : .0);

  toggle(String title) {
    _lastToggledItem(title);

    if (isOpened(title)) {
      _openedItems.remove(title);
      _animationController.reverse(from: maxRotationAngle);
    } else {
      _openedItems.add(title);
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
    final result = await query(foodQuery, parameters: {'id': id});
    print('FoodController.retrieve result: $result');

    item = FoodData.fromJson(result.get('food'));
    update();
  }
}