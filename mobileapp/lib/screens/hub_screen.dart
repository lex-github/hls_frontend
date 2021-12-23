import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart'
    hide Card, Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/health_controller.dart';
import 'package:hls/controllers/post_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/post_model.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/navigation/tabbar.dart';
import 'package:hls/services/_graphql_service.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

final radius = Size.screenWidth / 1.4;
final outerRadius = radius + Size.vertical * 2;
final angle = 2 * pi / 3;
final startAngle = -pi / 2;

class HubScreen extends GetView<HubController> {
  UserData get profile => AuthService.i?.profile;

  UserDailyData get profileDaily => profile?.daily;

  // handlers

  _tipHandler({ActivityType type}) => controller.retrieveTooltip(type: type);

  // builders

  Widget _buildSector({ActivityType type, double value, double startAngle}) =>
      CustomPaint(
          size: M.Size(outerRadius, outerRadius),
          painter: SectorProgressPainter(
              title: type.title,
              color: type.color,
              value: value,
              endAngle: angle,
              startAngle: startAngle));

  Widget _buildButton({ActivityType type}) => Expanded(
      child: Button(
          padding: EdgeInsets.symmetric(vertical: Padding.button.top),
          title: type.title,
          borderColor: type.color,
          onLongPressed: () => _tipHandler(type: type),
          onPressed: () => _router(type: type),
          titleStyle: M.TextStyle(fontSize: Size.fontTiny)));

  Widget _buildItem(PostData item, {bool isHalf = false}) => Card(
      type: item.type,
      title: item.title,
      imageTitle: item.imageUrl,
      isHalf: item.isHalf || isHalf,
      duration: item.duration,
      onPressed: () {
        switch (item.type) {
          case PostType.ARTICLE:
            Get.toNamed(articleRoute, arguments: item);
            break;
          case PostType.STORY:
            Get.toNamed(storyRoute, arguments: item.stories);
            break;
          case PostType.VIDEO:
            Get.toNamed(videoRoute, arguments: item.videoUrl);
            break;
        }
      });

  Widget _buildNewsList() => GetX<PostController>(
      init: PostController(),
      builder: (controller) => !controller.isInit && controller.isAwaiting
          ? Loading()
          : controller.list.isBlank && false
              ? Nothing()
              : Column(children: [
                  VerticalBigSpace(),
                  for (int i = 0; i < controller.list.length; i++)
                    ...((PostData item) => !item.isHalf
                        ? [
                            _buildItem(item),
                            if (item != controller.list.last) VerticalSpace()
                          ]
                        : [
                            Row(children: [
                              Expanded(child: _buildItem(item)),
                              HorizontalSpace(),
                              ((PostData item) => item == null
                                      ? Nothing()
                                      : Expanded(
                                          child:
                                              _buildItem(item, isHalf: true)))(
                                  controller.list.get(++i))
                            ]),
                            if (i < controller.list.length - 1) VerticalSpace()
                          ])(controller.list[i]),
                  // Card(
                  //     title: 'ПРОДУКТЫ ЧЕМПИОНЫ Ч.3',
                  //     imageTitle: 'https://placeimg.com/640/480/any',
                  //     onPressed: () => Get.toNamed(articleRoute,
                  //         arguments: PostData()
                  //           ..title = 'ПРОДУКТЫ ЧЕМПИОНЫ Ч.3'
                  //           ..imageUrl = 'https://placeimg.com/640/480/any')),
                  // VerticalSpace(),
                  // Row(children: [
                  //   Expanded(
                  //       child:
                  //           Card(title: 'КУРЕНИЕ НАЧАЛО КОНЦА', isHalf: true)),
                  //   HorizontalSpace(),
                  //   Expanded(
                  //       child: Card(title: 'ЧЕМ СИЛЕН СЕЛЕН?', isHalf: true))
                  // ]),
                  // VerticalSpace(),
                  // Card(title: 'НАШ ОРГАНИЗМ И ВЛИЯНИЕ НА НЕГО НАШЕГО РАЦИОНА')
                ]));

  Widget _buildCenter() =>
      Obx(() => Stack(alignment: Alignment.center, children: [
            Text('${profileDaily?.total?.round()}%',
                style: TextStyle.primary.copyWith(fontSize: Size.fontPercent)),
            if (!controller.tooltip.isNullOrEmpty || controller.isAwaiting)
              Container(
                  width: radius,
                  height: radius,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius / 2),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: submenuBlurStrength,
                              sigmaY: submenuBlurStrength *
                                  submenuBlurVerticalCoefficient),
                          child: M.Padding(
                              padding: Padding.content,
                              child: Center(
                                  child: controller.isAwaiting
                                      ? Loading(
                                          color: controller.tooltipColor ??
                                              Colors.primary)
                                      : AutoSizeText(controller.tooltip,
                                          style: TextStyle.title,
                                          textAlign: TextAlign.center))))))
          ]));

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: hubScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Icon(FontAwesomeIcons.bell)),
      child: SingleChildScrollView(
          child: Column(children: [
        VerticalBigSpace(),
        GetBuilder<HubController>(
            init: HubController(),
            builder: (controller) =>
                Stack(alignment: Alignment.center, children: [
                  RotationTransition(
                      turns: Tween(begin: .0, end: 1.0)
                          .animate(controller.animationController),
                      child: profileDaily == null
                          ? Nothing()
                          : Stack(alignment: Alignment.center, children: [
                              _buildSector(
                                  type: ActivityType.SCHEDULE,
                                  value:
                                      profileDaily.schedule.clamp(0, 100) / 100,
                                  startAngle: startAngle),
                              _buildSector(
                                  type: ActivityType.NUTRITION,
                                  value: profileDaily.nutrition.clamp(0, 100) /
                                      100,
                                  startAngle: startAngle + angle),
                              _buildSector(
                                  type: ActivityType.EXERCISE,
                                  value:
                                      profileDaily.exercise.clamp(0, 100) / 100,
                                  startAngle: startAngle + angle * 2)
                            ])),
                  CircularProgress(size: radius, child: _buildCenter())
                ])),
        VerticalBigSpace(),
        VerticalBigSpace(),
        Row(children: [
          HorizontalSpace(),
          _buildButton(type: ActivityType.SCHEDULE),
          HorizontalSmallSpace(),
          _buildButton(type: ActivityType.NUTRITION),
          HorizontalSmallSpace(),
          _buildButton(type: ActivityType.EXERCISE),
          HorizontalSpace()
        ]),
        VerticalSpace(),
        Container(
            color: Colors.background,
            padding: Padding.content,
            child: Column(children: [
              if (profile?.progress?.goal != null) ...[
                StatusBlock(),
                VerticalSpace()
              ],
              _buildNewsList()
            ]))
      ])));
}

void _router({ActivityType type}) {
  switch (type.title) {
    case dreamTitle:
      Get.toNamed(scheduleAddRoute);
      break;
    case nutritionTitle:
      if (AuthService.i.profile?.schedule?.items?.isNullOrEmpty ?? true) {
        showConfirm(title: foodNeedScheduleText);
      }
      Get.toNamed(foodAddRoute);
      break;
    case exerciseTitle:
      if (AuthService.i.profile?.schedule?.items?.isNullOrEmpty ?? true) {
        showConfirm(title: exerciseNeedScheduleText);
      }
      Get.toNamed(exerciseCatalogRoute);
      break;
  }
}

class StatusBlock extends StatelessWidget {
  UserProgressData get progress => AuthService.i.profile.progress;

  // builders

  Widget _buildRow({String title, String text}) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextSecondary('$title:'),
            Flexible(
                child: TextPrimary(text ?? noDataText,
                    size: Size.fontSmall, align: TextAlign.right, lines: 2))
          ]);

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildRow(title: goalTitle, text: progress.goal),
        VerticalMediumSpace(),
        _buildRow(title: macrocycleTitle, text: progress.macroCycle.title),
        VerticalMediumSpace(),
        _buildRow(
            title: '$microcycleTitle',
            text: progress?.microCycle?.number?.toString() ?? '0'),
        // VerticalMediumSpace(),
        // _buildRow(title: weekTitle, text: '2/8'),
        VerticalMediumSpace(),
        _buildRow(
            title: trainingTitle,
            text:
                '${progress?.microCycle?.completedTrainings ?? 0}/${progress?.microCycle?.totalTrainings ?? 0}')
      ]);
}

class HubController extends GraphqlService with SingleGetTickerProviderMixin {
  HubController() {
    _animationController =
        AnimationController(vsync: this, duration: defaultAnimationDuration)
          ..addListener(() => animationProgress = _animationController.value)
          ..repeat(period: rotationAnimationDuration);
  }

  @override
  void onInit() async {
    super.onInit();
    check();
  }

  @override
  void onClose() {
    if (_tooltipDelayTimer != null) _tooltipDelayTimer.cancel();
  }

  void check() {
    final progressId = AuthService.i.profile.progress.microCycle;
    if (!progressId.isNullEmptyFalseOrZero) {
      // final _c = Get.put(HealthController());
      final _c = Get.put(HealthController());
        _c.fetchData();
    }
  }

  // tooltip

  final _tooltip = ''.obs;

  String get tooltip => _tooltip.value;

  Color _tooltipColor;

  Color get tooltipColor => _tooltipColor;

  // animation

  AnimationController _animationController;

  AnimationController get animationController => _animationController;

  final _animationProgress = .0.obs;

  double get animationProgress => _animationProgress.value;

  set animationProgress(double value) => _animationProgress.value = value;

  // methods

  Timer _tooltipDelayTimer;

  retrieveTooltip({ActivityType type}) async {
    _tooltipColor = type.color;

    final data = await query(dailyRatingTipQuery,
        parameters: {'type': type.value}, fetchPolicy: FetchPolicy.networkOnly);

    _tooltipColor = null;

    _tooltip(data.get(['dailyRatingTip', 'text']));

    if (_tooltipDelayTimer != null) _tooltipDelayTimer.cancel();

    _tooltipDelayTimer = Timer(tooltipDelay.seconds, () => _tooltip(''));
  }
}
