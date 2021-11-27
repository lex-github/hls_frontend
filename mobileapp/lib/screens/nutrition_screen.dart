import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Page, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/nutrition_controller.dart';
import 'package:hls/controllers/search_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:hls/models/food_filter_model.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/screens/_form_screen.dart' hide Button;
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class NutritionScreen<Controller extends NutritionController> extends GetView<Controller> {
  NutritionScreen() {
    Get.lazyPut(() => SearchFormController<Controller>());
  }

  // handlers

  _filterHandler() async {
    final response =
        await Get.toNamed(foodFilterRoute, arguments: controller.filters);
    if (response == null) return;
    final filters = Map<String, FoodFilterData>.from(response);
    //print('NutritionScreen._filterHandler filters: $filters');

    // Map<String, FoodFilterData> filters = await Get.toNamed(foodFilterRoute);
    if (filters == null) return;

    controller.filters = filters;
  }

  _categoryHandler(FoodCategoryData data) =>
      Get.toNamed(foodCategoryRoute, arguments: {'category': data});

  _foodHandler(FoodData item) => Get.toNamed(foodRoute,
      arguments: {'title': item.category.title, 'food': item});

  _reportHandler() async {
    if (controller.isAwaiting) return showConfirm(title: requestWaitingText);

    final user = AuthService.i.profile;
    final title = Get.find<SearchFormController>().search;

    if (title.isNullOrEmpty) return showConfirm(title: noDataText);

    if (user.desiredFoods?.map((e) => e.title)?.contains(title) ?? false)
      return showConfirm(title: foodEmptyAlreadyRequestedText);

    if (!await controller.requestFood(title: title))
      return showConfirm(title: controller.message ?? errorGenericText);

    return showConfirm(
        title: foodEmptyRequestSentTitle,
        description: foodEmptyRequestSentText);
  }

  // builders

  Widget _buildFilterFirst() => Button(
      borderColor: Colors.disabled,
      onPressed: _filterHandler,
      child: Obx(() => Row(children: [
            Icon(FontAwesomeIcons.filter, color: Colors.disabled),
            HorizontalSmallSpace(),
            // TextPrimaryHint(nutritionFilterLabel),
            TextSecondary(nutritionFilterLabel),
            if (!controller.filters.isNullOrEmpty) ...[
              HorizontalSmallSpace(),
              Container(
                  width: Size.iconSmall,
                  height: Size.iconSmall,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Size.iconSmall),
                      color: Colors.primary),
                  child: Center(
                      child: TextPrimaryHint('${controller.filters.length}',
                          size: .9 * Size.fontTiny)))
            ]
          ])));

  // Widget _buildFilterItem({String title}) =>
  //     Button(borderColor: Colors.disabled, child: TextSecondary(title));

  Widget _buildCategoryListItem(FoodCategoryData item) {

    print("lalalaal " + item.imageUrl);
    return ListItemButton(
        imageTitle: item.imageUrl,
        title: item.title,
        onPressed: () => _categoryHandler(item));
  }

  Widget _buildFoodListItem(FoodData item) => ListItemFoodButton(
      item: item,
      filters: controller.filters.values
          // .where((x) =>
          //     !['carbohydrates', 'fats', 'proteins', 'water'].contains(x.key))
          .toList(growable: false),
      onPressed: () => _foodHandler(item));

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalSpace(),
        // TextPrimary(productsScreenHeaderTitle),
        // VerticalSmallSpace(),
        // TextSecondary(productsScreenHeaderDescription),
        // VerticalSpace(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
            child: Input<SearchFormController<Controller>>(
                field: SearchFormController.field,
                leading: Icon(FontAwesomeIcons.search,
                    color: Colors.disabled, size: .9 * Size.icon))),
        VerticalMediumSpace(),
        // ConstrainedBox(
        //     constraints:
        //         BoxConstraints(minHeight: .0, maxHeight: Size.buttonHeight),
        //     child: ListView.builder(
        //         padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
        //         scrollDirection: Axis.horizontal,
        //         itemCount: 5 * 2 + 1,
        //         itemBuilder: (_, i) {
        //           //if (i == 0) return _buildFilterItem(title: '?');
        //           if (i == 0) return _buildFilterFirst();
        //
        //           if (i.isOdd) return HorizontalMediumSpace();
        //
        //           //final index = i ~/ 2 - 1;
        //
        //           return Nothing(); //_buildFilterItem(title: '$index');
        //         }))
        Container(
            padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
            child: _buildFilterFirst())
      ]);

  Widget _buildCategories() => controller.list.isNullOrEmpty
      ? EmptyPage()
      : ListView.builder(
          padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalMedium,
              Size.horizontal, Size.vertical),
          itemCount: controller.list.length * 2 - 1,
          itemBuilder: (_, i) {
            //if (i == 0) return _buildHeader();
            if (i.isOdd) return VerticalMediumSpace();

            final index = i ~/ 2;

            return _buildCategoryListItem(controller.list[index]);
          });

  Widget _buildEmptyFoods() => Page(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextPrimary(foodEmptyTitle),
        VerticalSpace(),
        TextSecondary(foodEmptySubtitle, align: TextAlign.center),
        VerticalBigSpace(),
        CircularButton(
            icon: FontAwesomeIcons.solidPaperPlane, onPressed: _reportHandler)
      ]));

  Widget _buildFoods() => controller.foods.isNullOrEmpty
      ? _buildEmptyFoods()
      : ListView.builder(
          padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalMedium,
              Size.horizontal, Size.vertical),
          //itemCount: controller.foods.length * 2 - 1,
          itemBuilder: (_, i) {
            //if (i == 0) return _buildHeader();
            if (i.isOdd) return VerticalMediumSpace();

            final index = i ~/ 2;

            final data = controller.foods.get(index);
            if (data != null) return _buildFoodListItem(data);

            if (controller.hasNextPage) {
              if (controller.isAwaiting && index == controller.foods.length)
                return Center(child: Loading());

              if (!controller.isAppending) {
                print('RETRIEVING INDEX $index');
                controller.retrieveFoods(shouldAppend: true);
              }
            }

            return null;
          });

  Widget _buildBody() => !controller.isInit ||
          controller.isAwaiting && controller.cursor.isNullOrEmpty
      ? Center(child: Loading())
      : controller.filters.isNullOrEmpty && controller.search.isNullOrEmpty
          ? controller.isAwaiting
              ? Center(child: Loading())
              : _buildCategories()
          : _buildFoods();

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: nutritionScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Image(title: 'icons/question')),
      child: GetX<Controller>(
          init: NutritionController() as Controller,
          dispose: (_) => Get.delete<SearchFormController<Controller>>(),
          builder: (_) => Column(
              children: [_buildHeader(), Expanded(child: _buildBody())])));
}
