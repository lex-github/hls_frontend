import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:health/health.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/calendar_model.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/models/stats_model.dart';
import 'package:hls/services/auth_service.dart';

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTH_NOT_GRANTED,
//   DATA_ADDED,
//   DATA_NOT_ADDED,
// }
class StatsController extends Controller with SingleGetTickerProviderMixin {
  final String id;

  StatsController({@required this.id}) {
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
  StatsData stats;
  List<CalendarData> calendar;

  List<HealthDataPoint> _healthDataList = [];

  // AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 10;
  double _mgdl = 10.0;

  String statsUpdate = "";

  // StatsScheduleItem scheduleItem;
  List<StatsScheduleEatings> eatings;
  List<StatsScheduleComponents> components;
  FoodData item;
  bool d;

  List items;
  Map res;

  // Map<String, List<FoodSectionData>> get list => item.sections ?? {};

  // Map<String, List<StatsScheduleEatings>> get eatings => scheduleItem.kind ?? {};

  AnimationController get animationController => _animationController;

  double get animationProgress => _animationProgress.value;

  double get rotationAngle => maxRotationAngle * animationProgress;

  set animationProgress(double value) => _animationProgress.value = value;
  final HealthFactory health = HealthFactory();
  final List<HealthDataType> types = [HealthDataType.SLEEP_ASLEEP];

  final _isAwaiting = false.obs;

  bool get isAwaiting => _isAwaiting.value;

  final _message = ''.obs;

  String get message => _message.value;

  int sleepAsleep = 0;

  // methods

  // Future addData() async {
  //   HealthFactory health = HealthFactory();
  //
  //   final time = DateTime.now();
  //   final ago = time.add(Duration(minutes: -5));
  //
  //   _nofSteps = Random().nextInt(10);
  //   _mgdl = Random().nextInt(10) * 1.0;
  //   bool success = await health.writeHealthData(
  //       _nofSteps.toDouble(), HealthDataType.STEPS, ago, time);
  //
  //   if (success) {
  //     success = await health.writeHealthData(
  //         _mgdl, HealthDataType.BLOOD_GLUCOSE, time, time);
  //   }
  //
  //   setState(() {
  //     _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
  //   });
  // }

  /// Fetch data from the healt plugin and print it
  // Future fetchData() async {
  //   // get everything from midnight until now
  //   DateTime startDate = DateTime.now().subtract(1.days);
  //   DateTime endDate = DateTime.now();
  //
  //   HealthFactory health = HealthFactory();
  //
  //   // define the types to get
  //   List<HealthDataType> types = [
  //     HealthDataType.SLEEP_ASLEEP,
  //     // HealthDataType.WEIGHT,
  //     // HealthDataType.HEIGHT,
  //     // HealthDataType.BLOOD_GLUCOSE,
  //     // Uncomment this line on iOS. This type is supported ONLY on Android!
  //     // HealthDataType.DISTANCE_WALKING_RUNNING,
  //   ];
  //
  //    // _state = AppState.FETCHING_DATA;
  //
  //   // you MUST request access to the data types before reading them
  //   bool accessWasGranted = await health.requestAuthorization(types);
  //
  //
  //   if (accessWasGranted) {
  //     try {
  //       // fetch new data
  //       List<HealthDataPoint> healthData =
  //       await health.getHealthDataFromTypes(startDate, endDate, types);
  //
  //       // save all the new data points
  //       _healthDataList.addAll(healthData);
  //     } catch (e) {
  //       print("Caught exception in getHealthDataFromTypes: $e");
  //     }
  //
  //     // filter out duplicates
  //     _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
  //
  //     // print the results
  //     _healthDataList.forEach((x) {
  //       print("Data point: $x");
  //       sleepAsleep += x.value.round();
  //     });
  //
  //     // print("Steps: $steps");
  //
  //     // update the UI to display the results
  //     // setState(() {
  //     //   _state =
  //     //   _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
  //     // });
  //   } else {
  //     print("Authorization not granted");
  //     // setState(() => _state = AppState.DATA_NOT_FETCHED);
  //   }
  // }

  // String getTitle(int index) => list.keys.toList(growable: false)[index];

  // List<FoodSectionData> getSection(int index) =>
  //     list.values.toList(growable: false)[index];
  //
  // bool isOpened(String title) => _openedItems.contains(title);
  //
  // double getRotationAngle(String title) => title == _lastToggledItem.value
  //     ? rotationAngle
  //     : isOpened(title)
  //         ? maxRotationAngle
  //         : minRotationAngle;

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
      // parameters: {
      //   'fromDate': dateToString(date: fromDate, output: dateInternalFormat),
      //   'toDate': dateToString(date: toDate, output: dateInternalFormat),
      // },
      fetchPolicy: FetchPolicy.networkOnly                                                    ,
    );
    calendar = responseCalendar
        .get<List>('schedules')
        .map((x) => CalendarData.fromJson(x))
        .toList(growable: false);

    update();
  }

  Future getSchedule(String i) async {
    if (statsUpdate != i && i != null && i != "update") {
      statsUpdate = i;
      final responseStats = await query(
        schedule,
        parameters: {
          'id': i,
        },
        fetchPolicy: FetchPolicy.networkOnly                                                    ,
      );
      stats = StatsData.fromJson(responseStats.get('schedule'));
      print('FoodController.retrieve result:' + stats.eatings.length.toString());
    }else if(i == "update"){
      final responseStats = await query(
        schedule,
        parameters: {
          'id': statsUpdate,
        },
        fetchPolicy: FetchPolicy.networkOnly                                                    ,
      );
      stats = StatsData.fromJson(responseStats.get('schedule'));
    }
    update();
  }

  // bool d;
  bool isOpened(String title) =>
      d == true ? true : _openedItems.contains(title);

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
      d = false;
    } else {
      _openedItems.add(title);
      _animationController.forward(from: minRotationAngle);
    }

    //update();
  }

  @override
  void onInit() async {
    d = true;
    // await fetchData();
    await getCalendar();

    // await getSchedule();

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

  Future<bool> delete({@required String id}) async {
    final result = await mutation(scheduleEatingsDeleteMutation, parameters: {
      'id': id,
    });

    print('StatsController.delete result: $result');
    AuthService.i.retrieve();
    getSchedule("update");
    update();
    return result != null;
  }
}
