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

class CalendarController extends Controller with SingleGetTickerProviderMixin {
  final String fromDate;
  final String toDate;

  CalendarController({@required this.fromDate, this.toDate}) {
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
    // if (!canRequestSchedule) return false;



    final response = await query(
      calendarQuery,
      parameters: {
        'fromDate': dateToString(date: fromDate, output: dateInternalFormat),
        'toDate': dateToString(date: toDate, output: dateInternalFormat),
      },
      fetchPolicy: FetchPolicy.cacheFirst,
    );

    // if (response == null) return false;

    // final result = response.get(['scheduleDate', 'dailyRating']);
    // if (result == null) return false;
    calendar = response
        .get<List>('schedules')
        .map((x) => CalendarData.fromJson(x))
        .toList(growable: false);



    // eatings = stats[3].eatings;
    // components = stats[3].components;

    // eatings = response
    //       .get<List<Map>>('','schedules')
    //       .map((x) => StatsScheduleEatings.fromJson(x))
    //       .toList(growable: false);
    //
    // print("fdate: " + dateToString(date: fromDate, output: dateInternalFormat));
    // print("tdate: " + dateToString(date: toDate, output: dateInternalFormat));
    // print("kind: " + stats[3].eatings[3].scheduleItem.kind.toString());
    // print("titleF: " + eatings[3].scheduleFood.title.toString());
    // print("portion: " + eatings[3].scheduleFood.portion.toString());
    // print("length: " + eatings[3].scheduleFood.structure.length.toString());

    // print("title: " + eatings[3].scheduleFood.structure[0].title.toString());
    // print("key: " + eatings[3].scheduleFood.structure[0].key.toString());
    // print("unit: " + eatings[3].scheduleFood.structure[0].unit.toString());
    // print("quantity: " + eatings[3].scheduleFood.structure[0].quantity.toString());
    // print("section: " + components[3].foodComponent.title.toString());

    // for (int j = 0; j < eatings.length; j++) {
    //   print("----------------------");
    //   print("ID: " + j.toString());
    //   print("----------------------");
    //   print("kind: " + eatings[j].scheduleItem.kind.toString());
    //   print("titleF: " + eatings[j].scheduleFood.title.toString());
    //   print("portion: " + eatings[j].scheduleFood.portion.toString());
    //   print("length: " + eatings[j].scheduleFood.structure.length.toString());
    //   for (int i = 0; i < eatings[j].scheduleFood.structure.length; i++) {
    //     print("\n");
    //     print("title: " + eatings[j].scheduleFood.structure[i].title.toString());
    //     print("key: " + eatings[j].scheduleFood.structure[i].key.toString());
    //     print("unit: " + eatings[j].scheduleFood.structure[i].unit.toString());
    //     print("quantity: " +
    //         eatings[j].scheduleFood.structure[i].quantity.toString());
    //     print("section: " +
    //         eatings[j].scheduleFood.structure[i].section.toString());
    //     print("\n");
    //   }
    // }



    // items = response
    //     .get<List>('scheduleEatings')
    //     .map((x) => StatsData.fromJson(x))
    //     .toList(growable: false);    // print('"RESULT" $result');
    // print('"RESPONSE" $response');
    // final schedule = ScheduleData.fromJson(result);
    // AuthService.i.profile.schedule = schedule;
    //
    // _dayItems.assignAll(schedule.items);
    update();

    // return !_dayItems.isNullOrEmpty;
    // item = StatsData.fromJson(['scheduleDate', 'dailyRating']);
  }

  // Future getEat() async {
  //   // if (!canRequestSchedule) return false;
  //
  //   final response = await query(schedules,
  //       parameters: {
  //         'fromDate': dateToString(date: fromDate, output: dateInternalFormat),
  //         'toDate': dateToString(date: toDate, output: dateInternalFormat),
  //       },
  //       fetchPolicy: FetchPolicy.cacheFirst,
  //   );
  //
  //   // if (response == null) return false;
  //
  //   // final result = response.get(['scheduleDate', 'dailyRating']);
  //   // if (result == null) return false;
  //   eatings = response
  //       .get<List>('scheduleEatings')
  //       .map((x) => StatsData.fromJson(x))
  //       .toList(growable: false);
  //   print('"RESULT" $eatings');
  //   // print('"RESPONSE" $response');
  //   // final schedule = ScheduleData.fromJson(result);
  //   // AuthService.i.profile.schedule = schedule;
  //   //
  //   // _dayItems.assignAll(schedule.items);
  //   update();
  //
  //   // return !_dayItems.isNullOrEmpty;
  //   // item = StatsData.fromJson(['scheduleDate', 'dailyRating']);
  // }

  // Future getEatings() async {
  //   // if (!canRequestSchedule) return false;
  //
  //   final response = await query(schedulesFood,parameters: {
  //     'fromDate': dateToString(date: DateTime.now(), output: dateInternalFormat),
  //     'toDate': dateToString(date: DateTime.now(), output: dateInternalFormat),
  //   },
  //     fetchPolicy: FetchPolicy.cacheFirst,
  //   );
  //
  //   // if (response == null) return false;
  //
  //   // final result = response.get(['scheduleDate', 'dailyRating']);
  //   // if (result == null) return false;
  //   eatings = response
  //       .get<List>('scheduleEatings')
  //       .map((x) => StatsScheduleEatings.fromJson(x))
  //       .toList(growable: false);
  //   print('"RESULT" $eatings');
  //   // print('"RESPONSE" $response');
  //   // final schedule = ScheduleData.fromJson(result);
  //   // AuthService.i.profile.schedule = schedule;
  //   //
  //   // _dayItems.assignAll(schedule.items);
  //   update();
  //
  //   // return !_dayItems.isNullOrEmpty;
  //   // item = StatsData.fromJson(['scheduleDate', 'dailyRating']);
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
    await getCalendar();
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
