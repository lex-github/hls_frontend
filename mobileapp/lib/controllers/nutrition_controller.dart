import 'dart:async';

import 'package:hls/constants/api.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/food_category_model.dart';

class NutritionController extends Controller {
  List<FoodCategoryData> list;

  @override
  void onInit() async {
    await retrieve();
    super.onInit();
  }

  Future retrieve() async {
    final result = await query(foodCategoriesQuery);
    print('NutritionController.retrieve result: $result');

    list = result
        .get<List>('foodCategories')
        .map((x) => FoodCategoryData.fromJson(x))
        .toList(growable: false);
    update();
  }
}
