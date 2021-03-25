import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/common_dialog.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/components/painters.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/chat_navigation_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/navigation/tabbar_screen.dart';
import 'package:hls/screens/hub_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';
import 'package:pretty_json/pretty_json.dart';

const ages = [0, 20, 30, 36, 38, 40, 50, 60];

class ProfileScreen extends StatelessWidget with CommonDialog {
  UserData get profile => AuthService?.i?.profile;
  UserProgressData get progress => profile?.progress;

  // handlers
  _debugHandler() => showConfirm(
      title: debugTitle,
      description: prettyJson(progress?.health?.debugInfo ?? noDataText));

  _resultsHandler() => Get.toNamed(chatResultsRoute);
  _restartHandler() {
    Get.back(closeOverlays: true);
    tabbarScaffoldKey.currentState.openEndDrawer();
    Get.find<ChatNavigationController>().init(canGoBack: true);
  }

  _editHandler() => Get.toNamed(profileFormRoute);

  // builders

  Widget _buildBlock({String title, Widget child}) => Container(
      decoration: BoxDecoration(
          color: Colors.background,
          borderRadius: borderRadiusCircular,
          border: Border.all(
              width: borderWidth,
              color: Colors.disabled,
              style: BorderStyle.solid)),
      padding: Padding.content,
      child: Column(children: [
        TextSecondary(title, size: Size.fontTiny),
        VerticalSpace(),
        child
      ]));

  Widget _buildParameter({String value, String title}) => Column(children: [
        TextPrimaryHint(value ?? noDataText, size: Size.font),
        TextPrimary(title, size: .9 * Size.fontTiny)
      ]);

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldHaveAppBar: false,
      leadingLeft: Size.horizontal - (Size.iconBig - Size.iconSmall) / 2,
      leadingTop: Size.vertical + Size.top, // - Size.iconBig / 2,
      leading: Clickable(
          borderRadius: Size.iconBig / 2,
          child: Container(
              width: Size.iconBig,
              height: Size.iconBig,
              child: Center(
                  child: Hero(
                      tag: 'icon-back',
                      child:
                          Icon(Icons.arrow_back_ios, size: Size.iconSmall)))),
          onPressed: Get.back),
      trailing: Clickable(
          borderRadius: Size.iconBig / 2,
          child: Container(
              width: Size.iconBig,
              height: Size.iconBig,
              child: Center(child: Icon(Icons.edit, size: .9 * Size.icon))),
          onPressed: _editHandler),
      child: Obx(() => SingleChildScrollView(
              child: Column(children: [
            ProfileHeader(avatarUrl: profile.avatarUrl),
            Container(
                padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                child: Column(children: [
                  if (!profile.name.isNullOrEmpty) ...[
                    VerticalTinySpace(),
                    TextPrimaryTitle(profile.name, size: 1.2 * Size.fontBig)
                  ],
                  if (!(profile.age.isNullOrEmpty &&
                      profile.height.isNullOrEmpty &&
                      profile.weight.isNullOrEmpty)) ...[
                    VerticalSpace(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildParameter(
                              value: '${profile.age}', title: ageProfileText),
                          _buildParameter(
                              value: '${profile.height}',
                              title: heightProfileText),
                          _buildParameter(
                              value: '${profile.weight}',
                              title: weightProfileText)
                        ])
                  ],
                  VerticalSpace(),
                  Button(
                      padding:
                          EdgeInsets.symmetric(vertical: Size.verticalMedium),
                      background: Colors.primary,
                      title: testingResultsProfileLabel,
                      onPressed: _resultsHandler),
                  VerticalMediumSpace(),
                  Button(
                      padding:
                          EdgeInsets.symmetric(vertical: Size.verticalMedium),
                      title: restartTestProfileLabel,
                      onPressed: _restartHandler),
                  VerticalBigSpace(),
                  // TextSecondary(progressProfileText, size: Size.fontTiny),
                  // VerticalSpace(),
                  // StatusBlock(),
                  _buildBlock(title: progressProfileText, child: StatusBlock()),
                  VerticalSpace(),
                  _buildBlock(
                      title: trainingDayText,
                      child: TrainingCalendar(selected: profile.trainings)),
                  VerticalSpace(),
                  _buildBlock(
                      title: microCycleText,
                      child: MicroCycle(
                          title: progress?.microCycle?.title,
                          total: progress?.microCycle?.totalTrainings ?? 0,
                          completed:
                              progress?.microCycle?.completedTrainings ?? 0)),
                  VerticalSpace(),
                  _buildBlock(
                      title: healthDynamicText, child: HealthYearGraph()),
                  VerticalSpace(),
                  _buildBlock(title: macroCycleText, child: MacroCycleGraph()),
                  VerticalSpace(),
                  Button(
                      background: Colors.failure,
                      title: debugTitle,
                      onPressed: _debugHandler),
                  VerticalSpace()
                ]))
          ]))));
}

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final bool showDefaultAvatar;
  final bool isAvatarLocal;

  ProfileHeader(
      {this.avatarUrl,
      this.showDefaultAvatar = true,
      this.isAvatarLocal = false});

  @override
  Widget build(BuildContext context) => SizedBox(
      height: Size.image + Size.avatar / 2,
      child: Stack(children: [
        Hero(
            tag: 'sidebar-background',
            child: Image(
                title: 'sidebar-background.png',
                width: Size.screenWidth,
                height: Size.image,
                fit: BoxFit.cover)),
        Positioned(
            bottom: 0,
            left: Size.screenWidth / 2 -
                Size.avatar / 2 -
                Size.horizontalTiny / 2,
            child: Hero(
                tag: 'avatar',
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Size.avatar / 2 + Size.horizontalTiny / 2),
                    child: Container(
                        color: Colors.background,
                        padding: Padding.tiny,
                        child: avatarUrl.isNullOrEmpty
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Size.avatar / 2),
                                child: Container(
                                    color: Colors.light.withOpacity(.25),
                                    width: Size.avatar,
                                    height: Size.avatar,
                                    child: showDefaultAvatar
                                        ? Icon(Icons.person,
                                            color: Colors.light,
                                            size: .65 * Size.avatar)
                                        : Nothing()))
                            : Avatar(
                                imageUrl: avatarUrl,
                                isLink: !isAvatarLocal,
                                isAsset: isAvatarLocal,
                                size: Size.avatar)))))
      ]));
}

class TrainingCalendar extends GetView<TrainingCalendarController>
    with CommonDialog {
  final List<DayType> selected;

  TrainingCalendar({@required List<int> selected})
      : this.selected =
            selected.map((e) => DayType.fromValue(e)).toList(growable: false);

  DateTime getDateFromWeekday(int weekday) =>
      controller.getDateFromWeekday(weekday);

  // handlers

  _dayHandler(DayType type) async {
    if (controller.isAwaiting) return false;

    if (!await controller.toggle(type)) {
      if (controller.error.status == errorTrainingLimitExceeded)
        return Get.toNamed(trainingStoryRoute);

      return showConfirm(title: controller.message);
    }
  }

  // builders

  Widget _buildWeekday(DayType type) => ClipRRect(
      borderRadius: BorderRadius.circular(Size.button / 2),
      child: Container(
          color: controller.isSelected(type) ? Colors.primary : null,
          child: Clickable(
              onPressed: () => _dayHandler(type),
              child: Container(
                  width: Size.button,
                  height: Size.button,
                  child: Center(
                      child: controller.isAwaiting &&
                              controller.lastToggledType.value == type
                          ? Container(
                              width: .6 * Size.button,
                              height: .6 * Size.button,
                              child: Loading(color: Colors.primaryText))
                          : TextSecondary(type.title,
                              color: controller.isSelected(type)
                                  ? Colors.primaryText
                                  : null,
                              size: Size.fontTiny))))));

  Widget _buildDay(DayType type) {
    final date = getDateFromWeekday(type.value);
    final lastDateOfWeek = getDateFromWeekday(DayType.SUNDAY.value);
    final isOldMonth = date.month != lastDateOfWeek.month;
    final color = isOldMonth ? Colors.secondaryText : Colors.primaryText;

    return TextSecondary('${date.day}', color: color, size: Size.fontTiny);
  }

  @override
  Widget build(BuildContext context) => GetX<TrainingCalendarController>(
      init: TrainingCalendarController(selected: selected),
      builder: (_) =>
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (final day in DayType.values)
              Column(children: [
                _buildWeekday(day),
                VerticalTinySpace(),
                _buildDay(day)
              ])
          ]));
}

class MicroCycle extends StatelessWidget {
  final gaugeHeight = 1.6 * Size.verticalTiny;
  final thumbHeight = Size.iconSmall;
  double get radius => gaugeHeight / 2 + Size.border;

  final String title;
  final int total;
  final int completed;
  MicroCycle(
      {@required this.title, @required this.total, @required this.completed});

  _buildText(String text) =>
      TextSecondary(text, color: Colors.primaryText, size: Size.fontTiny);

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!title.isNullOrEmpty) _buildText(title) else Nothing(),
              _buildText(microCyclePeriod1Text),
              _buildText(microCyclePeriod2Text)
            ]),
        VerticalSmallSpace(),
        Stack(children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: Colors.light, width: Size.border)),
              width: double.infinity,
              height: gaugeHeight),
          if (completed > 0)
            FractionallySizedBox(
                widthFactor: completed / total,
                child: Stack(overflow: Overflow.visible, children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.primary,
                          borderRadius: BorderRadius.circular(radius),
                          border: Border.all(
                              color: Colors.primary, width: Size.border)),
                      width: double.infinity,
                      height: gaugeHeight),
                  Positioned(
                      right: 0,
                      top: -(thumbHeight - gaugeHeight) / 2,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.primary,
                              borderRadius:
                                  BorderRadius.circular(thumbHeight / 2),
                              border: Border.all(
                                  color: Colors.primary, width: Size.border)),
                          width: thumbHeight,
                          height: thumbHeight))
                ]))
        ]),
        VerticalSmallSpace(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (int i = 1; i <= total; i++)
            Container(
                width: Size.fontTiny,
                child: TextSecondary('$i',
                    size: .8 * Size.fontTiny, align: TextAlign.right))
        ])
      ]);
}

class HealthYearGraph extends StatelessWidget {
  final pointSize = .8 * Size.horizontalSmall;
  UserProgressData get progress => AuthService?.i?.profile?.progress;
  HealthData get health => progress?.health;
  List<HealthValueData> get values => health?.values;

  double ordinate(double value) => Size.graph / 2 * value / 100 - pointSize / 2;

  double abscissa(DateTime date) =>
      (Size.screenWidth -
          Size.horizontal * 4 - // padding
          Size.horizontalTiny - // space between 100% and graph
          Size.fontTiny * 2 - // 100% width
          Size.border * 2 - // borders
          pointSize / 2) /
      365 *
      date.difference(DateTime(date.year, 1, 1)).inDays;

  // build

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            padding: EdgeInsets.only(bottom: Size.verticalTiny + Size.fontTiny),
            child: TextSecondary('100%', size: .8 * Size.fontTiny)),
        HorizontalTinySpace(),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(overflow: Overflow.visible, children: [
            Container(
                height: Size.graph / 2,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.disabled, width: Size.border)))),
            Container(
                height: Size.graph,
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.disabled, width: Size.border),
                        bottom: BorderSide(
                            color: Colors.disabled, width: Size.border)))),
            if (!values.isNullOrEmpty)
              for (final point in values)
                Positioned(
                    bottom: ordinate(point.average),
                    left: abscissa(point.date),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.light,
                            borderRadius: BorderRadius.circular(pointSize / 2)),
                        width: pointSize,
                        height: pointSize))
          ]),
          VerticalTinySpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (int i = 0; i <= 12; i += 2)
              Container(
                  width: Size.fontTiny,
                  child: TextSecondary('$i',
                      color: Colors.light,
                      size: .8 * Size.fontTiny,
                      align: TextAlign.left))
          ]),
          VerticalSpace(),
          TextSecondary(
              '$healthLevelLabel – ${values?.lastOrNull?.calculated?.round() ?? 0}%(${values?.lastOrNull?.empirical?.round() ?? 0}):',
              size: Size.fontTiny),
          VerticalSpace(),
          TextSecondary(
              '$healthMassIndexLabel – ${health?.queteletIndex ?? 0}%',
              size: Size.fontTiny),
          TextSecondary(
              '$healthRobensonIndexLabel – ${health?.robinsonIndex ?? 0}%',
              size: Size.fontTiny),
          TextSecondary(
              '$healthRuffierIndexLabel – ${health?.ruffierIndex ?? 0}%',
              size: Size.fontTiny),
          TextSecondary(
              '$healthFunctionalStateLabel – ${health?.functionalityIndex ?? 0}%',
              size: Size.fontTiny),
          TextSecondary(
              '$healthAdaptationPotentialLabel – ${health?.adaptiveCapacity ?? 0}%',
              size: Size.fontTiny),
          TextSecondary(
              '$healthHLSApplicationLabel – нет(${health?.hlsApplication?.round() ?? 0}%)',
              size: Size.fontTiny)
        ]))
      ]);
}

class MacroCycleGraph extends StatelessWidget {
  final pointSize = Size.icon;
  Map<int, double> get values =>
      AuthService?.i?.profile?.progress?.healthHistory;

  double ordinate(double value) => Size.graph / 2 * value / 100 - pointSize / 2;

  double abscissa(int age) =>
      (Size.screenWidth -
          Size.horizontal * 4 - // padding
          Size.horizontalTiny - // space between 100% and graph
          Size.fontTiny * 2 - // 100% width
          Size.border * 2 - // borders
          pointSize / 2) /
      7 *
      ages.indexOf(age.round());

  // builders

  Widget _buildIndicator({@required Color color, @required String text}) =>
      Row(children: [
        Container(
            margin: EdgeInsets.only(top: .6 * Size.verticalTiny),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: color, width: 1.5 * Size.border))),
            height: 0,
            width: Size.horizontalSmall),
        HorizontalTinySpace(),
        TextSecondary(text, size: Size.fontTiny)
      ]);

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            padding: EdgeInsets.only(
                bottom: Size.verticalTiny +
                    Size.fontTiny +
                    Size.vertical +
                    Size.fontTiny),
            child: TextSecondary('100%', size: .8 * Size.fontTiny)),
        HorizontalTinySpace(),
        Expanded(
            child: Column(children: [
          Stack(overflow: Overflow.visible, children: [
            Container(
                height: Size.graph / 2,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.disabled, width: Size.border)))),
            Container(
                height: Size.graph,
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.disabled, width: Size.border),
                        bottom: BorderSide(
                            color: Colors.disabled, width: Size.border)))),
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: CustomPaint(painter: MacroGraphPainter())),
            // Positioned(
            //     left: -Size.width(20),
            //     bottom: -Size.height(48),
            //     child: Image(title: 'macro-graph')),
            // if (!data.isNullOrEmpty)
            //   for (final MapEntry<int, double> point in data.entries)
            //     Positioned(
            //         bottom: ordinate(point.value),
            //         left: abscissa(point.key),
            //         child: Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.light,
            //                 borderRadius: BorderRadius.circular(pointSize / 2)),
            //             width: pointSize,
            //             height: pointSize)),
            if (!values.isNullOrEmpty)
              for (final MapEntry<int, double> point in values.entries)
                if (ages.contains(point.key))
                  Positioned(
                      bottom: ordinate(point.value),
                      left: abscissa(point.key),
                      child: Container(
                          width: pointSize,
                          height: pointSize,
                          decoration: BoxDecoration(
                              color: Colors.light,
                              borderRadius:
                                  BorderRadius.circular(pointSize / 2)),
                          child: Center(
                              child: TextSecondary('${point.value.round()}%',
                                  size: .8 * Size.fontTiny,
                                  color: Colors.darkText))))
          ]),
          VerticalTinySpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (final i in ages)
              Container(
                  width: Size.fontTiny,
                  child: TextSecondary('$i',
                      color: Colors.light,
                      size: .8 * Size.fontTiny,
                      align: TextAlign.left))
          ]),
          VerticalSpace(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildIndicator(color: Colors.macroHLS, text: macroHLSLabel),
            _buildIndicator(color: Colors.macroNoHLS, text: macroNoHLSLabel),
            _buildIndicator(
                color: Colors.macroStatistical, text: macroStatisticalLabel)
          ])
        ]))
      ]);
}

class TrainingCalendarController extends Controller {
  final date = DateTime.now();

  TrainingCalendarController({List<DayType> selected}) {
    this.selected.assignAll(selected ?? []);
  }

  bool get isAwaiting => AuthService.i.isAwaiting;

  // methods

  DateTime getDateFromWeekday(int weekday) =>
      date.subtract(Duration(days: date.weekday - weekday));

  // selection

  final selected = <DayType>[].obs;
  bool isSelected(DayType type) => selected.contains(type);
  final lastToggledType = DayType.OTHER.obs;
  Future<bool> toggle(DayType type) async {
    lastToggledType.value = type;
    final result = await AuthService.i.toggleTraining(type);
    if (result) if (isSelected(type))
      selected.remove(type);
    else
      selected.add(type);
    return result;
  }
}

class DayType extends GenericEnum<int> {
  const DayType({@required String title, @required int value})
      : super(title: title, value: value);

  static DayType fromValue(value) =>
      values.firstWhere((x) => x.value == value, orElse: () => DayType.OTHER);

  static const OTHER = DayType(title: null, value: null);
  static const MONDAY = DayType(title: 'Пн', value: 1);
  static const TUESDAY = DayType(title: 'Вт', value: 2);
  static const WEDNESDAY = DayType(title: 'Ср', value: 3);
  static const THURSDAY = DayType(title: 'Чт', value: 4);
  static const FRIDAY = DayType(title: 'Пт', value: 5);
  static const SATURDAY = DayType(title: 'Сб', value: 6);
  static const SUNDAY = DayType(title: 'Вс', value: 7);

  static const values = [
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
  ];

  @override
  String toString() => 'DayType(title: $title)';
}
