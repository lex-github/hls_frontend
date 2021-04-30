import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/food_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/theme/styles.dart';

class FoodScreen extends GetView<FoodController> {
  final FoodData food;
  final String title;

  FoodScreen()
      : food = (Get.arguments as Map).get('food'),
         title = (Get.arguments as Map).get('title') ?? foodScreenTitle;

  // handlers

  _sectionHandler(String title) => controller.toggle(title);

  // builds

  Widget _buildListItem(String title, List<FoodSectionData> items) => Button(
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
              child: Icon(FontAwesomeIcons.chevronRight,
                  color: Colors.disabled, size: Size.iconSmall))),
        ]),
        Obx(() => SizeTransition(
            sizeFactor: controller.getSizeFactor(title),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              VerticalMediumSpace(),
              for (final subItem in items)
                Container(
                    padding: EdgeInsets.symmetric(vertical: Size.verticalTiny),
                    child: Row(children: [
                      Expanded(child: TextSecondary(subItem.title)),
                      TextSecondary('${subItem.quantity} ${subItem.unit}')
                    ]))
            ])))
      ]));

  Widget _buildIndicator(FoodSectionData data,
          {String title, Color color, double value}) =>
      CircularProgress(
          color: color,
          value: value,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(data?.quantity?.toString() ?? '0',
                style:
                    TextStyle.primary.copyWith(fontSize: 1.1 * Size.fontTiny)),
            Text(title ?? data?.title?.toLowerCase() ?? '',
                style:
                    TextStyle.secondary.copyWith(fontSize: .9 * Size.fontTiny))
          ]));

  Widget _buildHeader(FoodData food) => Column(mainAxisSize: MainAxisSize.min, children: [
        //VerticalSpace(),
        TextPrimary(food.title, align: TextAlign.center),
        if (!food.championOn.isNullOrEmpty) ...[
          VerticalSmallSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image(title: 'icons/champion'),
            HorizontalTinySpace(),
            TextSecondary(food?.championOn?.join(', '), color: Colors.champion)
          ])
        ],
        VerticalSpace(),
        Container(
            margin: EdgeInsets.symmetric(horizontal: Size.horizontal),
            padding: Padding.content,
            decoration: BoxDecoration(
                borderRadius: borderRadiusCircular,
                color: Colors.background,
                // border: Border.all(
                //     width: borderWidth / 2,
                //     color:  Colors.primary),
                boxShadow: [
                  BoxShadow(
                      color: panelShadowColor,
                      blurRadius: panelShadowBlurRadius,
                      offset: -Offset(panelShadowHorizontalOffset,
                          panelShadowVerticalOffset)),
                ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    //_buildIndicator(food.water, color: Colors.water, value: .2),
                    _buildIndicator(food.calories,
                        color: Colors.water, value: .2),
                    VerticalSpace(),
                    _buildIndicator(food.proteins,
                        color: Colors.proteins, value: .45)
                  ]),
                  CircularProgress(
                      size: Size.buttonHuge,
                      child: (food?.image?.url?.isNullOrEmpty ?? true)
                          ? Icon(Icons.no_food,
                              color: Colors.disabled,
                              size: .5 * Size.buttonHuge)
                          : Image(
                              title: food.image.url,
                              width: .5 * Size.buttonHuge,
                              height: .5 * Size.buttonHuge)),
                  Column(children: [
                    _buildIndicator(food.fats, color: Colors.fats, value: .65),
                    VerticalSpace(),
                    _buildIndicator(food.carbs,
                        title: foodCarbLabel, color: Colors.carbs, value: .35)
                  ])
                ])),
        //VerticalBigSpace()
      ]);

  Widget _buildBody() => GetX<FoodController>(
      init: FoodController(id: food.id),
      builder: (_) => controller.isInit && !controller.isAwaiting
          ? controller.list.length > 0
              ? ListView.builder(
                  padding: Padding.content,
                  itemCount: controller.list.length * 2 + 1,
                  itemBuilder: (_, i) {
                    if (i == 0) return _buildHeader(controller.item);
                    if (i.isOdd) return VerticalMediumSpace();

                    final index = i ~/ 2 - 1;

                    return _buildListItem(controller.getTitle(index),
                        controller.getSection(index));
                  })
              : Nothing()
          : Center(child: Loading()));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: title,
      child: _buildBody()
      //Column(children: [_buildHeader(), Expanded(child: _buildBody())])
  );
}
