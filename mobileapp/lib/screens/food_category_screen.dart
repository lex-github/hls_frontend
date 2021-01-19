import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/food_category_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/theme/styles.dart';

class FoodCategoryScreen extends GetView<FoodCategoryController> {
  final FoodCategoryData category;
  final String title;

  @override
  String get tag => title;

  FoodCategoryScreen()
      : category = (Get.arguments as Map).get('category'),
        title = (Get.arguments as Map).get('title') ?? foodCategoryScreenTitle;
  // handlers

  _categoryHandler(FoodCategoryData item) {
    print('FoodCategoryScreen._categoryHandler $item');

    if (!item.children.isNullOrEmpty)
      return Get.toNamed(foodCategoryRoute,
          preventDuplicates: false,
          arguments: {'title': category.title, 'category': item});

    // if (item.parent.id == category.id && !item.children.isNullOrEmpty)
    if (!item.foods.isNullOrEmpty) return controller.toggle(item);

    return showConfirm(title: noDataText);
  }

  _foodsHandler(FoodCategoryData category, FoodData item) =>
      Get.toNamed(foodRoute,
          arguments: {'title': category.title, 'food': item});
  // Get.toNamed(foodCategoryRoute,
  //   preventDuplicates: false, arguments: item);

  // builds

  Widget _buildListItem(FoodCategoryData item) => Button(
      borderColor: Colors.disabled,
      onPressed: () => _categoryHandler(item),
      child: Column(children: [
        Row(children: [
          Image(width: Size.iconBig, title: item.imageUrl),
          HorizontalSpace(),
          TextPrimaryHint(item.title),
          Expanded(child: HorizontalSpace()),
          Obx(() => Transform.rotate(
              angle: controller.getRotationAngle(item),
              child: Icon(Icons.arrow_forward_ios,
                  color: Colors.disabled, size: Size.iconSmall))),
        ]),
        Obx(() => SizeTransition(
            sizeFactor: controller.getSizeFactor(item),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              VerticalSpace(),
              for (final subItem in item.foods)
                Clickable(
                    child: Container(
                        padding: Padding.small,
                        child: TextPrimaryHint(subItem.title)),
                    onPressed: () => _foodsHandler(item, subItem))
            ])))
      ]));

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalSpace(),
        TextPrimary(category?.title),
        VerticalSpace(),
      ]);

  Widget _buildBody() => GetBuilder<FoodCategoryController>(
      tag: tag,
      init: FoodCategoryController(id: category.id),
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
      title: title,
      child: Column(children: [_buildHeader(), Expanded(child: _buildBody())]));
}
