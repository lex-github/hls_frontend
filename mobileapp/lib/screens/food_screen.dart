import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/food_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/food_category_model.dart';
import 'package:hls/theme/styles.dart';

class FoodScreen extends GetView<FoodController> {
  final FoodData food;
  final String title;

  FoodScreen()
      : food = (Get.arguments as Map).get('food'),
        title = (Get.arguments as Map).get('title') ?? foodCategoryScreenTitle;

  // handlers

  //_categoryHandler(FoodCategoryData item) => controller.toggle(item);

  // builds

  // Widget _buildListItem(FoodCategoryData item) => Button(
  //     borderColor: Colors.disabled,
  //     onPressed: () => _categoryHandler(item),
  //     child: Column(children: [
  //       Row(children: [
  //         Image(width: Size.iconBig, title: item.imageUrl),
  //         HorizontalSpace(),
  //         TextPrimaryHint(item.title),
  //         Expanded(child: HorizontalSpace()),
  //         Obx(() => Transform.rotate(
  //             angle: controller.getRotationAngle(item),
  //             child: Icon(Icons.arrow_forward_ios,
  //                 color: Colors.disabled, size: Size.iconSmall))),
  //       ]),
  //       Obx(() => SizeTransition(
  //           sizeFactor: controller.getSizeFactor(item),
  //           child:
  //               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //                 VerticalSpace(),
  //                 for (final subItem in item.foods)
  //               Clickable(
  //                   child: Container(
  //                       padding: Padding.small,
  //                       child: TextPrimaryHint(subItem.title)),
  //                   onPressed: () => _foodsHandler(subItem))
  //           ])))
  //     ]));

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalSpace(),
        TextPrimary(food.title, align: TextAlign.center),
        VerticalSpace(),
      ]);

  Widget _buildBody() => Nothing();
    // GetBuilder<FoodCategoryController>(
    // init: FoodController(id: food.id),
    //   builder: (_) => controller.isInit
    //       ? ListView.builder(
    //           padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalMedium,
    //               Size.horizontal, Size.vertical),
    //           itemCount: controller.list.length * 2 - 1,
    //           itemBuilder: (_, i) {
    //             if (i.isOdd) return VerticalMediumSpace();
    //
    //             final index = i ~/ 2;
    //
    //             return _buildListItem(controller.list[index]);
    //           })
    //       : Center(child: Loading()));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: title,
      child: Column(children: [_buildHeader(), Expanded(child: _buildBody())]));
}
