import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/food_filter_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_filter_model.dart';
import 'package:hls/theme/styles.dart';

class FoodFilterScreen extends GetView<FoodFilterController> {
  // handlers

  _sectionHandler(FoodFilterData item) => controller.toggle(item);

  // builds

  Widget _buildListItem(FoodFilterData item) => Button(
      borderColor: Colors.disabled,
      onPressed: () => _sectionHandler(item),
      child: Column(children: [
        Row(children: [
          Container(
              height: Size
                  .iconBig), // make row height correspond FoodCategoryScreen
          TextPrimaryHint(item.title),
          Expanded(child: HorizontalSpace()),
          Obx(() => Transform.rotate(
              angle: controller.getRotationAngle(item),
              child: Icon(Icons.arrow_forward_ios,
                  color: Colors.disabled, size: Size.iconSmall))),
        ]),
        // Obx(() => SizeTransition(
        //     sizeFactor: controller.getSizeFactor(item),
        //     child:
        //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       VerticalMediumSpace(),
        //       for (final subItem in items)
        //         Container(
        //             padding:
        //                 EdgeInsets.symmetric(vertical: Size.verticalTiny),
        //             child: Row(
        //               children: [
        //                 Expanded(child: TextSecondary(subItem.title)),
        //                 TextSecondary('${subItem.quantity} ${subItem.unit}')
        //               ]
        //             ))
        //     ])))
      ]));

  Widget _buildBody() => GetBuilder<FoodFilterController>(
      init: FoodFilterController(),
      builder: (_) => controller.isInit
          ? !controller.list.isNullOrEmpty
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(Size.horizontal,
                      Size.verticalBig, Size.horizontal, Size.vertical),
                  itemCount: controller.list.length * 2 - 1,
                  itemBuilder: (_, i) {
                    if (i.isOdd) return VerticalMediumSpace();

                    final index = i ~/ 2;

                    return _buildListItem(controller.list[index]);
                  })
              : EmptyPage()
          : Center(child: Loading()));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: 'Найдено 999',
      child: _buildBody());
}
