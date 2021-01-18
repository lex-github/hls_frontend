import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/nutrition_controller.dart';
import 'package:hls/controllers/search_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:hls/screens/_form_screen.dart' hide Button;
import 'package:hls/theme/styles.dart';

class NutritionScreen extends GetView<NutritionController> {
  NutritionScreen() {
    Get.lazyPut(() => SearchFormController());
  }

  // handlers

  _itemHandler(FoodCategoryData item) =>
      Get.toNamed(foodCategoryRoute, arguments: {'category': item});

  // builders

  Widget _buildFilterFirst() => Button(
      borderColor: Colors.disabled,
      child: Row(children: [
        Icon(Icons.filter_alt_rounded, color: Colors.disabled),
        HorizontalSmallSpace(),
        TextPrimaryHint(nutritionFilterLabel),
        HorizontalSmallSpace(),
        Container(
            width: Size.iconSmall,
            height: Size.iconSmall,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Size.iconSmall),
                color: Colors.primary),
            child:
                Center(child: TextPrimaryHint('2', size: .9 * Size.fontTiny)))
      ]));

  Widget _buildFilterItem({String title}) =>
      Button(borderColor: Colors.disabled, child: TextSecondary(title));

  Widget _buildListItem(FoodCategoryData item) => ListItemButton(
      imageTitle: item.imageUrl,
      title: item.title,
      onPressed: () => _itemHandler(item));

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalSpace(),
        TextPrimary(productsScreenHeaderTitle),
        VerticalSmallSpace(),
        TextSecondary(productsScreenHeaderDescription),
        VerticalSpace(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
            child: Input<SearchFormController>(
                field: 'search',
                leading: Icon(Icons.search,
                    color: Colors.disabled, size: .9 * Size.icon))),
        VerticalMediumSpace(),
        ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: .0, maxHeight: Size.buttonHeight),
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                scrollDirection: Axis.horizontal,
                itemCount: 5 * 2 + 1,
                itemBuilder: (_, i) {
                  //if (i == 0) return _buildFilterItem(title: '?');
                  if (i == 0) return _buildFilterFirst();

                  if (i.isOdd) return HorizontalMediumSpace();

                  final index = i ~/ 2 - 1;

                  return Nothing(); //_buildFilterItem(title: '$index');
                }))
      ]);

  Widget _buildBody() => GetBuilder<NutritionController>(
      init: NutritionController(),
      builder: (_) => controller.isInit
          ? ListView.builder(
              padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalMedium,
                  Size.horizontal, Size.vertical),
              itemCount: controller.list.length * 2 - 1,
              itemBuilder: (_, i) {
                if (i.isOdd) return VerticalMediumSpace();

                final index = i ~/ 2;

                return _buildListItem(controller.list[index]);
              })
          : Center(child: Loading()));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: nutritionScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Image(title: 'icons/question')),
      child: Column(children: [_buildHeader(), Expanded(child: _buildBody())]));
}
