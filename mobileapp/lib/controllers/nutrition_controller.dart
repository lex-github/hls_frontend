import 'dart:async';

import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:hls/models/food_filter_model.dart';
import 'package:hls/models/food_model.dart';

class NutritionController extends Controller {
  // filters
  final _filters = RxMap<String, FoodFilterData>();
  Map<String, FoodFilterData> get filters => _filters;
  set filters(Map<String, FoodFilterData> values) => _filters.assignAll(values);

  // search
  final _search = ''.obs;
  String get search => _search.value;
  set search(String value) => _search.value = value;

  // categories

  List<FoodCategoryData> list;

  Future retrieve() async {
    final result = await query(foodCategoriesQuery);
    print('NutritionController.retrieve result: $result');

    list = result
        .get<List>('foodCategories')
        .map((x) => FoodCategoryData.fromJson(x))
        .toList(growable: false);
    update();
  }

  // foods
  List<FoodData> foods;

  Future retrieveFoods() async {
    final result = await query(foodsQuery, parameters: {
      'filters': {
        if (!filters.isNullOrEmpty)
          for (final filter in filters.values) ...{
            if (filter.values.min != null)
              '${filter.key}_gteq': filter.values.min,
            if (filter.values.max != null)
              '${filter.key}_lteq': filter.values.max
          }
      },
      'search': search
    });

    print('NutritionController.retrieveFoods result: $result');

    foods = result
        .get<List>('foods')
        ?.map((x) => FoodData.fromJson(x))
        ?.toList(growable: false);
    update();
  }

  @override
  void onInit() async {
    await retrieve();

    // retrieve foods on filter change or search change
    ever(_filters, (_) => retrieveFoods());
    debounce(_search, (_) => retrieveFoods(), time: searchDelayDuration);

    super.onInit();
  }
}
