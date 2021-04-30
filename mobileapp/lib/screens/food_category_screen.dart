import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String get tag => category?.title;

  FoodCategoryScreen()
      : category = (Get.arguments as Map).get('category'),
        title = (Get.arguments as Map).get('title') ?? foodCategoryScreenTitle;

  // handlers

  _categoryHandler(FoodCategoryData item) {
    //print('FoodCategoryScreen._categoryHandler $item');

    if (item.canExpand)
      return controller.toggle(item);

    if (!item.children.isNullOrEmpty)
      return Get.toNamed(foodCategoryRoute,
          preventDuplicates: false,
          arguments: {'title': category.title, 'category': item});

    if (!item.foods.isNullOrEmpty && item.foods.length == 1)
      return _foodHandler(category, item.foods.first);

    return showConfirm(title: noDataText);
  }

  _foodHandler(FoodCategoryData category, FoodData item) =>
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
          Expanded(child: TextPrimaryHint(item.title)),
          HorizontalSpace(),
          if (item.canExpand)
          Obx(() => Transform.rotate(
              angle: controller.getRotationAngle(item),
              child: Icon(FontAwesomeIcons.chevronRight,
                  color: Colors.disabled, size: Size.iconSmall))),
        ]),
        if (item.canExpand)
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
                    onPressed: () => _foodHandler(item, subItem))
            ])))
      ]));

  Widget _buildFoodItem(FoodData item) => Button(
      borderColor: Colors.disabled,
      onPressed: () => _foodHandler(category, item),
      child: Row(children: [
        if (!item.imageUrl.isNullOrEmpty) ...[
          Image(width: Size.iconBig, title: item.imageUrl),
          HorizontalSpace()
        ] else
          SizedBox(height: Size.iconBig),
        Expanded(child: TextPrimaryHint(item.title)),
        HorizontalSpace(),
        Icon(FontAwesomeIcons.chevronRight,
            color: Colors.disabled, size: Size.iconSmall)
      ]));

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalSpace(),
        TextPrimary(category?.title),
        VerticalSpace(),
      ]);

  Widget _buildBody() => GetBuilder<FoodCategoryController>(
      tag: tag,
      init: FoodCategoryController(id: category?.id),
      //dispose: (_) => Get.delete<FoodCategoryController>(tag: tag),
      builder: (_) => controller.isInit
          ? controller.list.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(Size.horizontal,
                      Size.verticalMedium, Size.horizontal, Size.vertical),
                  itemCount: controller.list.length * 2 - 1,
                  itemBuilder: (_, i) {
                    if (i.isOdd) return VerticalMediumSpace();

                    final index = i ~/ 2;

                    return _buildListItem(controller.list[index]);
                  })
              : controller.foods.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.fromLTRB(Size.horizontal,
                          Size.verticalMedium, Size.horizontal, Size.vertical),
                      itemCount: controller.foods.length * 2 - 1,
                      itemBuilder: (_, i) {
                        if (i.isOdd) return VerticalMediumSpace();

                        final index = i ~/ 2;

                        return _buildFoodItem(controller.foods[index]);
                      })
                  : EmptyPage()
          : Center(child: Loading()));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: title,
      child: Column(children: [_buildHeader(), Expanded(child: _buildBody())]));
}
