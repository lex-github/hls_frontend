import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:hls/models/food_model.dart';

class FoodCategoryController extends Controller
    with SingleGetTickerProviderMixin {
  final int id;
  FoodCategoryController({@required this.id}) {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value);
  }

  // fieldsq

  final minRotationAngle = .0;
  final maxRotationAngle = pi / 2;
  final List<FoodCategoryData> _openedItems = [];
  final _animationProgress = .0.obs;
  final _lastToggledItem = Rx<FoodCategoryData>(null);
  AnimationController _animationController;
  FoodCategoryData item;

  List<FoodCategoryData> get list => item.children + foodsAsCategory;
  List<FoodCategoryData> get foodsAsCategory =>
      item.foods.map((x) => FoodCategoryData()
        ..title = x.title
        ..image = x.image
        ..foods = [x]).toList(growable: false);
  List<FoodData> get foods => item.foods;
  AnimationController get animationController => _animationController;
  double get animationProgress => _animationProgress.value;
  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;

  // methods

  bool isOpened(FoodCategoryData item) => _openedItems.contains(item);
  double getRotationAngle(FoodCategoryData item) =>
      item == _lastToggledItem.value
          ? rotationAngle
          : isOpened(item)
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

  Animation<double> getSizeFactor(FoodCategoryData item) =>
      item == _lastToggledItem.value
          ? Tween<double>(begin: .0, end: 1.0).animate(_animationController)
          : AlwaysStoppedAnimation(isOpened(item) ? 1.0 : .0);

  toggle(FoodCategoryData item) {
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
    final result = await query(foodCategoryQuery,
        parameters: {'id': id}, fetchPolicy: FetchPolicy.cacheAndNetwork);
    //print('FoodCategoryController.retrieve result: $result');

    // final subcategories = result.get(['foodCategory', 'subcategories']);
    // if (subcategories != null)
    //   for (final x in subcategories)
    //     print('FoodCategoryController.retrieve subcategory: $x');

    item = FoodCategoryData.fromJson(result.get('foodCategory'));
    update();
  }
}
