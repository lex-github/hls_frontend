import 'package:flutter/cupertino.dart' as C;
import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/food_filter_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_filter_model.dart';
import 'package:hls/theme/styles.dart';

class FoodFilterScreen extends GetView<FoodFilterController> {
  // handlers

  _sectionHandler(String title) => controller.toggle(title);

  _filterHandler(FoodFilterData data) => Get.bottomSheet(Container(
      height: Size.bottomSheet,
      color: Colors.background,
      child: Column(children: [
        Row(children: [
          Expanded(
              child: Clickable(
                  onPressed: Get.back,
                  child: Container(
                      padding: Padding.content,
                      child: C.Row(children: [
                        Icon(Icons.keyboard_arrow_down) ??
                            TextPrimary(backButtonTitle)
                      ])))),
          Expanded(
              child: TextPrimary(data.title,
                  weight: FontWeight.bold, align: TextAlign.center)),
          Expanded(
              child: Clickable(
                  child: Container(
                      padding: Padding.content,
                      child: Nothing() ??
                          TextPrimary(submitButtonTitle,
                              color: Colors.primary, align: TextAlign.end))))
        ]),
        Expanded(
            child: Row(children: [
          Expanded(
              child: C.CupertinoPicker(
                  itemExtent: Size.picker,
                  scrollController: FixedExtentScrollController(
                      initialItem: controller.getFilterFrom(data.key) ?? 0),
                  onSelectedItemChanged: (index) =>
                      controller.setFilterFrom(data.key, data.min + index),
                  children: _buildFilterFromSelection(data))),
          Expanded(
              child: C.CupertinoPicker(
                  itemExtent: Size.picker,
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          (controller.getFilterTo(data.key) ?? data.max) - 1),
                  onSelectedItemChanged: (index) =>
                      controller.setFilterTo(data.key, data.min + index + 1),
                  children: _buildFilterToSelection(data)))
        ]))
      ])));

  // builders

  List<Widget> _buildFilterFromSelection(FoodFilterData data) => [
        for (int i = toInt(data.min); i < toInt(data.max - 1); i += 1)
          i == data.min
              ? Center(child: TextPrimary(filterFromLabel, size: Size.fontBig))
              : Center(child: TextPrimary('$i', size: Size.fontBig))
      ];

  List<Widget> _buildFilterToSelection(FoodFilterData data) => [
        for (int i = toInt(data.min + 1); i <= toInt(data.max); i += 1)
          i == data.max
              ? Center(child: TextPrimary(filterToLabel, size: Size.fontBig))
              : Center(child: TextPrimary('$i', size: Size.fontBig))
      ];

  Widget _buildFilterValue(FoodFilterData data) => Obx(() => ((from, to) =>
          Row(children: [
            if (from != null &&
                from != data.min &&
                (to == null || to == data.max))
              TextPrimaryHint('$filterFromLabel $from')
            else if (to != null &&
                to != data.max &&
                (from == null || from == data.min))
              TextPrimaryHint('$filterToLabel $to')
            else if (from != null &&
                from != data.min &&
                to != null &&
                to != data.max)
              TextPrimaryHint('$from - $to'),
            // HorizontalSpace(),
            // Icon(Icons.add_circle_outline)
          ]))(
      controller.getFilterFrom(data.key), controller.getFilterTo(data.key)));

  Widget _buildListItem(String title, List<FoodFilterData> items) =>
      items.length > 1
          ? Button(
              borderColor: Colors.disabled,
              onPressed: () => _sectionHandler(title),
              child: Column(children: [
                Row(children: [
                  Container(
                      height: Size
                          .iconBig), // make row height correspond FoodCategoryScreen
                  TextPrimaryHint(title),
                  Expanded(child: HorizontalSpace()),
                  Obx(() => Transform.rotate(
                      angle: controller.getRotationAngle(title),
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.disabled, size: Size.iconSmall)))
                ]),
                Obx(() => SizeTransition(
                    sizeFactor: controller.getSizeFactor(title),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalMediumSpace(),
                          for (final subItem in items)
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Size.verticalTiny),
                                child: Row(children: [
                                  TextSecondary(subItem.title)
                                  // Expanded(child: TextSecondary(subItem.title)),
                                  // TextSecondary('${subItem.quantity} ${subItem.unit}')
                                ]))
                        ])))
              ]))
          : Button(
              borderColor: Colors.disabled,
              onPressed: () => _filterHandler(items[0]),
              child: Row(children: [
                Container(
                    height: Size
                        .iconBig), // make row height correspond FoodCategoryScreen
                TextPrimaryHint(title),
                Expanded(child: HorizontalSpace()),
                _buildFilterValue(items[0])
              ]));

  Widget _buildBody() => GetBuilder<FoodFilterController>(
      init: FoodFilterController(),
      builder: (_) => controller.isInit
          ? !controller.sections.isNullOrEmpty
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(Size.horizontal,
                      Size.verticalBig, Size.horizontal, Size.vertical),
                  itemCount: controller.sections.length * 2 - 1,
                  itemBuilder: (_, i) {
                    if (i.isOdd) return VerticalMediumSpace();

                    final index = i ~/ 2;

                    return _buildListItem(controller.getTitle(index),
                        controller.getSection(index));
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
