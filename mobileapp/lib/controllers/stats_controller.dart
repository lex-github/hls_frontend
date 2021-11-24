import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/calendar_model.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/models/stats_model.dart';
import 'package:hls/services/auth_service.dart';

class StatsController extends Controller with SingleGetTickerProviderMixin {
  final String fromDate;
  final String toDate;

  StatsController({@required this.fromDate, this.toDate}) {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value);
  }

  // fields

  final minRotationAngle = .0;
  final maxRotationAngle = pi / 2;
  final List<String> _openedItems = [];
  final _animationProgress = .0.obs;
  final _lastToggledItem = Rx<String>(null);
  AnimationController _animationController;
  List<StatsData> stats;
  List<CalendarData> calendar;


  // StatsScheduleItem scheduleItem;
  List<StatsScheduleEatings> eatings;
  List<StatsScheduleComponents> components;
  FoodData item;

  List items;
  Map res;

  // Map<String, List<FoodSectionData>> get list => item.sections ?? {};

  // Map<String, List<StatsScheduleEatings>> get eatings => scheduleItem.kind ?? {};

  AnimationController get animationController => _animationController;

  double get animationProgress => _animationProgress.value;

  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;

  // methods

  // String getTitle(int index) => list.keys.toList(growable: false)[index];

  // List<FoodSectionData> getSection(int index) =>
  //     list.values.toList(growable: false)[index];

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

  Future getCalendar() async {
    final responseCalendar = await query(
      calendarQuery,
      parameters: {
        'fromDate': dateToString(date: fromDate, output: dateInternalFormat),
        'toDate': dateToString(date: toDate, output: dateInternalFormat),
      },
      fetchPolicy: FetchPolicy.cacheFirst,
    );
    calendar = responseCalendar
        .get<List>('schedules')
        .map((x) => CalendarData.fromJson(x))
        .toList(growable: false);

    update();

  }

  Future getSchedule() async {
      final responseStats = await query(
        schedules,
        parameters: {
          'fromDate': dateToString(date: fromDate, output: dateInternalFormat),
          'toDate': dateToString(date: toDate, output: dateInternalFormat),
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      stats = responseStats
          .get<List>('schedules')
          .map((x) => StatsData.fromJson(x))
          .toList(growable: false);

    update();

  }

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
    await getCalendar();
    await getSchedule();
    // await getEat();
    super.onInit();
  }

  @override
  onClose() {
    super.onClose();
    _animationController.dispose();
  }

  // Future retrieve() async {
  //   final result = await query(foodQuery,
  //       parameters: {'id': id}, fetchPolicy: FetchPolicy.cacheFirst);
  //   //print('FoodController.retrieve result: $result');
  //
  //   item = FoodData.fromJson(result.get('food'));
  //   update();
  // }

  Future<bool> add(
      {@required int scheduleId,
      @required String scheduleItemId,
      @required int foodId,
      @required int portion}) async {
    final result = await mutation(scheduleEatingsCreateMutation, parameters: {
      'scheduleId': scheduleId,
      'scheduleItemId': scheduleItemId,
      'foodId': foodId,
      'portion': portion
    });

    print('FoodController.add result: $result');
    AuthService.i.retrieve();

    return result != null;
  }
}
