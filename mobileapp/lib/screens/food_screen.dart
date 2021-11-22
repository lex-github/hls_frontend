import 'package:flutter/cupertino.dart' as C;
import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/food_add_form_controller.dart';
import 'package:hls/controllers/food_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/models/schedule_model.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/screens/_form_screen.dart' show Input;
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class FoodScreen extends GetView<FoodController> {
  final FoodData food;
  final String title;

  FoodScreen()
      : food = (Get.arguments as Map).get('food'),
        title = (Get.arguments as Map).get('title') ?? foodScreenTitle;

  // handlers

  _sectionHandler(String title) => controller.toggle(title);

  _addHandler() async {
    final contentPadding = EdgeInsets.only(
      //left: Size.horizontal,
      top: Size.verticalBig,
      //right: Size.horizontal
    );
    final fontSize = .9 * Size.fontBig;

    final portionStep = 50;
    final portionMax = portionStep * 10;
    final portions = [
      for (int i = portionStep; i <= portionMax; i += portionStep) i
    ];
    int portion = -1;

    await showConfirm(
        contentPadding: contentPadding,
        title: foodAddPortionTitle,
        child: GetBuilder<FoodAddFormController>(
            init: FoodAddFormController(onFieldChanged: (value) {
              if (value != -1)
                portion = value;
            }),
            builder: (controller) => SizedBox(
                height: Size.cupertinoPicker,
                child: C.Column(children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: Size.horizontal),
                      child: Input<FoodAddFormController>(
                          inputType: TextInputType.number,
                          field: FoodAddFormController.field)),
                  VerticalSpace(),
                  Expanded(
                      child: C.CupertinoPicker(
                          useMagnifier: true,
                          magnification: 1.1,
                          itemExtent: 1.75 * fontSize,
                          onSelectedItemChanged: (i) {
                            portion = portions[i];
                            controller.value = portion;
                          },
                          children: [
                        for (final portion in portions)
                          Center(
                              child: TextPrimary('$portion гр',
                                  size: 1.15 * fontSize))
                      ]))
                ]))));
    if (portion == -1) return;

    final schedule = AuthService.i.profile.schedule;
    final scheduleItems = [
      for (final scheduleItem in schedule.items)
        if (scheduleItem.type.type == ActivityType.NUTRITION) scheduleItem
    ];
    ScheduleItemData scheduleItem = scheduleItems.first;

    await showConfirm(
        contentPadding: contentPadding,
        title: foodAddTimeTitle,
        child: SizedBox(
            height: Size.cupertinoPicker,
            width: Size.screenWidth,
            child: C.CupertinoPicker(
                useMagnifier: true,
                magnification: 1.1,
                itemExtent: 1.75 * fontSize,
                onSelectedItemChanged: (i) => scheduleItem = scheduleItems[i],
                children: [
                  for (final scheduleItem in scheduleItems)
                    if (scheduleItem.type.type == ActivityType.NUTRITION)
                      Center(
                          widthFactor: 1,
                          child: Container(
                              width: Size.screenWidth - 4 * Size.horizontal,
                              padding: EdgeInsets.symmetric(
                                  horizontal: Size.horizontal),
                              child: TextPrimary(
                                  '${dateToString(date: scheduleItem.time, output: dateTime)} '
                                  '${scheduleItem.title}',
                                  size: 1.15 * fontSize,
                                  lines: 1)))
                ])));
    if (scheduleItem == null) return;

    if (controller.isAwaiting) return showConfirm(title: requestWaitingText);

    if (!await controller.add(
        scheduleId: schedule.id,
        scheduleItemId: scheduleItem.id,
        foodId: food.id,
        portion: portion))
      return showConfirm(title: controller.message ?? errorGenericText);

    Get.until((route) => route.settings.name == '/');
  }

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
            Text(title ?? (data?.title?.toLowerCase() == "калории" ? "ккал." : (data?.title?.toLowerCase() == "общие жиры" ? "жиры" : data?.title?.toLowerCase())) ?? '',
                style:
                    TextStyle.secondary.copyWith(fontSize: .9 * Size.fontTiny))
          ]));

  Widget _buildHeader(FoodData food) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
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
                // color: Colors.background,
                // border: Border.all(
                //     width: borderWidth / 2,
                //     color:  Colors.primary),
                boxShadow: [
                  // BoxShadow(
                  //     color: panelShadowColor,
                  //     blurRadius: panelShadowBlurRadius,
                  //     offset: -Offset(panelShadowHorizontalOffset,
                  //         panelShadowVerticalOffset)),
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
      fab: CircularButton(
          icon: FontAwesomeIcons.plus,
          background: Colors.success,
          onPressed: _addHandler),
      child: _buildBody()
      //Column(children: [_buildHeader(), Expanded(child: _buildBody())])
      );
}
