import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
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
  final List<String> _openedItems = [];
  final _lastToggledItem = Rx<String>(null);

  List<Data> list;
  AnimationController _animationController;

  // getters

  Map<String, List<Data>> get sections => list != null
      ? list
          .fold({}, (sections, x) => sections.setList(x.section ?? x.title, x))
      : {};
  String getTitle(int index) => sections.keys.toList(growable: false)[index];
  List<Data> getSection(int index) =>
      sections.values.toList(growable: false)[index];
  AnimationController get animationController => _animationController;
  double get animationProgress => _animationProgress.value;
  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;

  // methods

  bool isOpened(String title) =>
      _openedItems.firstWhere((x) => x == title, orElse: () => null) != null;

  double getRotationAngle(String title) => title == _lastToggledItem.value
      ? rotationAngle
      : isOpened(title)
          ? maxRotationAngle
          : minRotationAngle;

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

  // working with filters

  List<int> filterValues = [];
  composeFilterValues(FoodFilterData data) {
    final start = toInt(data.min);
    final end = toInt(data.max);

    final step = (end - start) / filterItemsCount;
    final values = [
      for (int i = 0; i <= filterItemsCount; i++) (start + step * i).round()
    ];

    filterValues = [
      ...{...values}
    ];
  }

  final _filtersFrom = RxMap<String, int>();
  final _filtersTo = RxMap<String, int>();

  int getFilterFrom(String key) => _filtersFrom.get(key);
  int getFilterTo(String key) => _filtersTo.get(key);

  setFilterFrom(String key, int value) =>
      _filtersFrom[key] = filterValues[value];
  setFilterTo(String key, int value) => _filtersTo[key] = filterValues[value];
  setFilterClear(String key) {
    _filtersFrom[key] = null;
    _filtersTo[key] = null;
  }

  setFilterClearAll() {
    _filtersFrom.clear();
    _filtersTo.clear();
  }

  Map<String, FoodFilterData> get values {
    _filtersFrom.keys; // needed for Obx

    Map<String, FoodFilterData> data = {};
    if (list.isNullOrEmpty) return data;

    for (final filter in list) {
      final key = filter.key;
      final title = filter.title;
      final from = _filtersFrom.get<int>(key);
      final to = _filtersTo.get<int>(key);

      if (from != null && from != filter.values.min ||
          to != null && to != filter.values.max) {
        final values = FilterValueData();
        if (from != null && from != filter.values.min.round())
          values.min = from.toDouble();
        if (to != null && to != filter.values.max.round())
          values.max = to.toDouble();

        data[key] = FoodFilterData()
          ..key = key
          ..title = title
          ..values = values;
      }
    }

    return data;
  }

  int get filterNumber => values.keys.length;

  @override
  void onInit() async {
    await retrieve();
    super.onInit();

    final Map<String, FoodFilterData> filters = Get.arguments;
    if (!filters.isNullOrEmpty) {
      _filtersFrom.assignAll({
        for (final data in filters.values)
          if (data.values.min != null) data.key: toInt(data.values.min)
      });
      _filtersTo.assignAll({
        for (final data in filters.values)
          if (data.values.max != null) data.key: toInt(data.values.max)
      });
    }
  }

  @override
  onClose() {
    super.onClose();
    _animationController.dispose();
  }

  Future retrieve() async {
    final result =
        await query(foodFilterQuery, fetchPolicy: FetchPolicy.cacheFirst);
    //print('FoodFilterController.retrieve result: $result');

    list = result
        .get<List>('foodFiltersList')
        .map((x) => FoodFilterData.fromJson(x))
        .toList(growable: false);
    update();
  }
}
