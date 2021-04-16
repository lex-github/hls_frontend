import 'dart:math';

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

  _filterHandler(FoodFilterData data) {
    controller.composeFilterValues(data);

    final values = controller.filterValues;
    int from = values.indexOf(controller.getFilterFrom(data.key));
    if (from == -1) from = 0;
    int to = values.indexOf(controller.getFilterTo(data.key));
    if (to == -1) to = values.length;
    else to--;

    print('FoodFilterScreen._filterHandler'
        '\n\tdata: $data'
        '\n\tvalues: $values'
        '\n\tfrom: $from'
        '\n\tto: $to');

    Get.bottomSheet(Container(
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
                    scrollController:
                        FixedExtentScrollController(initialItem: from),
                    onSelectedItemChanged: (index) =>
                        controller.setFilterFrom(data.key, data.min + index),
                    children: _buildFilterFromSelection(data))),
            Expanded(
                child: C.CupertinoPicker(
                    itemExtent: Size.picker,
                    scrollController:
                        FixedExtentScrollController(initialItem: to),
                    onSelectedItemChanged: (index) =>
                        controller.setFilterTo(data.key, data.min + index + 1),
                    children: _buildFilterToSelection(data)))
          ]))
        ])));
  }

  // builders

  List<Widget> _buildFilterFromSelection(FoodFilterData data) {
    final values =
        controller.filterValues.getRange(0, controller.filterValues.length - 1);

    return [
      for (int i in values)
        if (i == values.first)
          Center(child: TextPrimary(filterFromLabel, size: Size.fontBig))
        else
          Center(child: TextPrimary('$i', size: Size.fontBig))
    ];

    return [
      for (int i = toInt(data.min); i < toInt(data.max - 1); i += 1)
        i == data.min
            ? Center(child: TextPrimary(filterFromLabel, size: Size.fontBig))
            : Center(child: TextPrimary('$i', size: Size.fontBig))
    ];
  }

  List<Widget> _buildFilterToSelection(FoodFilterData data) {
    final values = controller.filterValues.getRange(1, controller.filterValues.length);

    return [
      for (int i in values)
        if (i == values.last)
          Center(child: TextPrimary(filterToLabel, size: Size.fontBig))
        else
          Center(child: TextPrimary('$i', size: Size.fontBig))
    ];

    return [
      for (int i = toInt(data.min + 1); i <= toInt(data.max); i += 1)
        i == data.max
            ? Center(child: TextPrimary(filterToLabel, size: Size.fontBig))
            : Center(child: TextPrimary('$i', size: Size.fontBig))
    ];
  }

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
            if (from != null && from != data.min ||
                to != null && to != data.max)
              Transform.translate(
                  offset: Offset(Size.horizontal, .0),
                  child: Clickable(
                      onPressed: () => controller.setFilterClear(data.key),
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Size.verticalTiny,
                              horizontal: Size.horizontal),
                          child: Transform.rotate(
                              angle: pi / 4,
                              child: Icon(Icons.add_circle_outline,
                                  size: Size.iconSmall)))))
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
                          for (final data in items)
                            Row(children: [
                              Expanded(
                                  child: Clickable(
                                      onPressed: () => _filterHandler(data),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Size.verticalTiny),
                                          child: TextSecondary(data.title)))),
                              _buildFilterValue(data)
                            ])
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

  Widget _buildBody() => controller.isInit
      ? !controller.sections.isNullOrEmpty
          ? ListView.builder(
              padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalBig,
                  Size.horizontal, Size.vertical),
              itemCount: controller.sections.length * 2 - 1,
              itemBuilder: (_, i) {
                if (i.isOdd) return VerticalMediumSpace();

                final index = i ~/ 2;

                return _buildListItem(
                    controller.getTitle(index), controller.getSection(index));
              })
          : EmptyPage()
      : Center(child: Loading());

  @override
  Widget build(_) => GetBuilder<FoodFilterController>(
      init: FoodFilterController(),
      builder: (_) => Screen(
          onBackPressed: () => Get.back(result: controller.values),
          padding: Padding.zero,
          shouldShowDrawer: true,
          title: foodFilterScreenTitle,
          trailing: Obx(() => ((int number) => number > 0
              ? Clickable(
                  onPressed: () => controller.setFilterClearAll(),
                  child: TextPrimaryHint('$clearButtonTitle ($number)',
                      color: Colors.failure))
              : Nothing())(controller.filterNumber)),
          child: _buildBody()));
}
