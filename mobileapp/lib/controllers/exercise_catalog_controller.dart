import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/exercise_category_model.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/services/auth_service.dart';

class ExerciseCatalogController extends SearchController {
  /// categories

  List<ExerciseCategoryData> list;
  ExerciseData detail;

  Future retrieve() async {
    final result = await query(trainingCategoriesQuery,
        fetchPolicy: FetchPolicy.cacheFirst);
    //print('ExerciseCatalogController.retrieve result: $result');

    list = result
        .get<List>(['trainingCategories', 'nodes'])
        .map((x) => ExerciseCategoryData.fromJson(x))
        .toList(growable: false);
    update();
  }

  /// catalog

  bool hasNextPage = true;
  bool isAppending = false;
  String cursor;
  List<ExerciseData> items;

  Future retrieveItems({bool shouldAppend = false}) async {
    if (!shouldAppend) {
      cursor = null;
      hasNextPage = true;
    }

    isAppending = true;
    final result = await query(trainingsQuery, parameters: {
      'search': search,
      'first': defaultItemsPerPage,
      if (cursor != null) 'after': cursor
    });
    //print('ExerciseCatalogController.retrieveFoods result: $result');

    final items = result
        .get<List>(['trainings', 'nodes'])
        ?.map((x) => ExerciseData.fromJson(x))
        ?.toList(growable: false);

    if (shouldAppend)
      this.items += items;
    else
      this.items = items;

    hasNextPage = result
        .get<bool>(['trainings', 'pageInfo', 'hasNextPage'], defaultValue: false);
    cursor = result.get<String>(['trainings', 'pageInfo', 'endCursor']);

    isAppending = false;
    update();
  }

  Future retrieveItem({int exerciseId}) async {
    final result = await query(trainingQuery, parameters: {
      'id': exerciseId
    });

    //print('ExerciseCatalogController.retrieveItem: $result');

    detail = ExerciseData.fromJson(result.get('training'));

    update();
  }

  @override
  void onInit() async {
    await retrieve();

    // retrieve foods on filter change or search change
    debounce(searchReactive, (_) => retrieveItems(), time: searchDelayDuration);

    super.onInit();
  }

  /// methods

  Future<bool> add(
    {@required int scheduleId,
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

  Future<bool> addRealtime({@required int scheduleId,
    @required int exerciseId,
    @required Duration duration,
    @required Map<String,int> data}) async {
    final result = await mutation(scheduleTrainingsCreateMutation, parameters: {
      'scheduleId': scheduleId,
      'exerciseId': exerciseId,
      'type': 'DURATION',
      'value': duration.inMinutes,
      'data': jsonEncode(data)
    });

    //print('ExerciseCatalogController.add result: $result');
    AuthService.i.retrieve();

    return result != null;
  }
}
