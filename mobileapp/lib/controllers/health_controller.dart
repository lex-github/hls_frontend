import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:health/health.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/stats_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/calendar_model.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/models/schedule_model.dart';
import 'package:hls/models/stats_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTH_NOT_GRANTED,
//   DATA_ADDED,
//   DATA_NOT_ADDED,
// }
class HealthController extends Controller with SingleGetTickerProviderMixin {

  HealthController() {
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
  final _dayItems = RxList<ScheduleItemData>();
  List<ScheduleItemData> get dayItems => _dayItems;
  List<HealthDataPoint> _healthDataList = [];


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


  int steps = 0;
  DateTime sleepFrom;
  DateTime sleepInBed;
  DateTime sleepTo;
  int sleepDuration = 0;
  bool isUpdated = false;

  void checkDay() async {
    //checking current date
    final currentdate = new DateTime.now().day;
    //you need to import this Shared preferences plugin
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //getting last date
    int lastDay = (prefs.getInt('day') ?? 0);

    //check is code already display or not
    if(currentdate!=lastDay){
      await prefs.setInt('day', currentdate);
      //your code will run once in day
      isUpdated = true;
    }

  }

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
  Future fetchData() async {
    // get everything from midnight until now
    DateTime startDate = DateTime.now().subtract(1.days);
    DateTime endDate = DateTime.now();

    HealthFactory health = HealthFactory();

    // define the types to get
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.SLEEP_ASLEEP,
      // HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_AWAKE,
      // HealthDataType.BLOOD_GLUCOSE,
      // Uncomment this line on iOS. This type is supported ONLY on Android!
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    // _state = AppState.FETCHING_DATA;

    // you MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);


    if (accessWasGranted) {
      try {
        // fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        // save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results
      // _healthDataList.forEach((x) {
      //   steps += x.value;
      //   // sleepAsleep += x.value;
      //   // sleepInBed = x.dateFrom;
      //   // sleepAwake = x.value;
      // });

      for(int i = 0; i < _healthDataList.length; i++){
        print("ALLL DATA " + _healthDataList[i].typeString);
        if (_healthDataList[i].typeString == "SLEEP_ASLEEP") {
          sleepFrom = _healthDataList[i].dateFrom;
          sleepTo = _healthDataList[i].dateTo;
          sleepDuration = _healthDataList[i].value.toInt();
        }
        if (_healthDataList[i].typeString == "STEPS") {
            steps += _healthDataList[i].value.round();
          // steps = _healthDataList[i].value.toInt();
        }
      }

      print("steps " + steps.toString());
      print("sleepFrom " + sleepFrom.toString());
      print("sleepTo " + sleepTo.toString());
      print("sleepDuration " + (sleepDuration/60).toString());
      // addSteps();
      checkDay();
      // addSteps();

      if (sleepFrom != 0 && sleepTo != 0
      ) {
        await addSchedule();
        if (steps != 0
        ) {
          addSteps();
        }
      }
      // addSteps();


    } else {

      // print("steps " + steps.toString());
      // setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }


  Future<bool> addSchedule() async {
    // if (!canRequestSchedule) return false;

    final response = await mutation(schedulesCreateMutation, parameters: {
      if (sleepFrom != null)
        'asleepTime': dateToString(date: sleepFrom, output: dateTime),

      if (sleepTo != null)
        'wakeupTime': dateToString(date: sleepTo, output: dateTime),
      // if (trainingTime != null)
      //   'trainingTime': dateToString(date: trainingTime, output: dateTime)
    });

    if (response == null) return false;

    final result = response.get(['schedulesCreate', 'schedule']);
    if (result == null) return false;

    final schedule = ScheduleData.fromJson(result);
    AuthService.i.profile.schedule = schedule;
    _dayItems.assignAll(schedule.items);

    AuthService.i.retrieve();
    //_dayItems.assignAll(AuthService.i.profile.schedule.items);

    return !_dayItems.isNullOrEmpty;
  }

  bool isOpened(String title) => _openedItems.contains(title);

  double getRotationAngle(String title) =>
      title == _lastToggledItem.value
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


  @override
  void onInit() async {
    super.onInit();
    // await fetchData();
  }


  @override
  onClose() {
    super.onClose();
    _animationController.dispose();
  }

  void addSteps() async {
    final scheduleId = AuthService.i.profile.schedule?.id;
    if (scheduleId == null) return showConfirm(title: exerciseNeedScheduleText);

    // final type = form.type?.value ?? item.input.firstOrNull?.type;
    // if (type == null) return showConfirm(title: exerciseNeedTypeText);

    // final value = form.value?.value ?? item.input.firstOrNull?.min;
    // if (value == null) return showConfirm(title: exerciseNeedValueText);

    final result = await exercise(
        scheduleId: scheduleId, exerciseId: 1, type: "QUANTITY", value: steps);

    print('ExerciseScreen._addHandler result: $result');

    // if (!result)
    //   return showConfirm(title: controller.message ?? errorGenericText);

    // Get.until((route) => route.settings.name == '/');
  }

  Future<bool> exercise({@required int scheduleId,
    @required int exerciseId,
    @required String type,
    @required int value}) async {
    final result = await mutation(scheduleTrainingsCreateMutation, parameters: {
      'scheduleId': scheduleId,
      'exerciseId': exerciseId,
      'type': type,
      'value': value
    });

    //print('ExerciseCatalogController.add result: $result');
    AuthService.i.retrieve();

    return result != null;
  }

}

