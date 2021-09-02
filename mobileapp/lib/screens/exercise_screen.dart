import 'package:flutter/material.dart' hide Colors, Icon, Image, Padding, Page;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart' as B;
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/controllers/exercise_catalog_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ExerciseScreen<T extends ExerciseFormController> extends StatelessWidget {
  final ExerciseData _item;

  ExerciseScreen({ExerciseData item}) : _item = item;

  ExerciseData get item => controller.detail ?? _item;
  ExerciseFormController get form => Get.find<ExerciseFormController>();
  ExerciseCatalogController get controller =>
      Get.find<ExerciseCatalogController>();

  /// handlers

  void _addHandler() async {
    final scheduleId = AuthService.i.profile.schedule?.id;
    if (scheduleId == null) return showConfirm(title: exerciseNeedScheduleText);

    final type = form.type?.value ?? item.input.firstOrNull?.type;
    if (type == null) return showConfirm(title: exerciseNeedTypeText);

    final value = form.value?.value ?? item.input.firstOrNull?.min;
    if (value == null) return showConfirm(title: exerciseNeedValueText);

    final result = await controller.add(
        scheduleId: scheduleId, exerciseId: item.id, type: type, value: value);

    print('ExerciseScreen._addHandler result: $result');

    if (!result)
      return showConfirm(title: controller.message ?? errorGenericText);

    Get.until((route) => route.settings.name == '/');
  }

  /// builders

  @override
  Widget build(_) => MixinBuilder<T>(
      init: ExerciseFormController() as T,
      initState: (_) => controller..retrieveItem(exerciseId: item.id),
      builder: (_) => Screen(
          padding: Padding.zero,
          shouldShowDrawer: true,
          title: exerciseScreenTitle,
          fab: Obx(() => CircularButton(
              icon: FontAwesomeIcons.check,
              background: Colors.primary,
              isDisabled: form.getValue('value') == null,
              isLoading: controller.isAwaiting,
              onPressed: _addHandler)),
          child: controller.isAwaiting || false ? LoadingPage() : item == null
              ? EmptyPage()
              : SingleChildScrollView(
                  child: Container(
                      padding: Padding.content,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        VerticalMediumSpace(),
                        TextPrimary(item.title),
                        if (!item.imageUrl.isNullOrEmpty) ...[
                          VerticalSpace(),
                          Image(width: Size.iconBig * 2, title: item?.imageUrl)
                        ],
                        VerticalBigSpace(),
                        if (item.values.length > 1) ...[
                          SelectDrum<T, GenericEnum>(
                              field: 'type', values: item.values),
                          VerticalSpace()
                        ],
                        if (form.type != null || item.values.length == 1)
                          SelectExercise<T, GenericEnum>(
                              field: 'value',
                              label:
                                  form.type?.title ?? item.values.first.title,
                              min: item.input
                                  .firstWhere((x) => x.type == form.type?.value,
                                      orElse: () => item.input.first)
                                  .min,
                              max: item.input
                                  .firstWhere((x) => x.type == form.type?.value,
                                      orElse: () => item.input.first)
                                  .max,
                              step: item.input
                                  .firstWhere((x) => x.type == form.type?.value,
                                      orElse: () => item.input.first)
                                  .step,
                              values: item.valuesFor(
                                  form.type?.value ?? item.values.first.value))
                        //Indicator<T>()
                      ])))));
}

class SelectExercise<T extends FormController, Type extends GenericEnum>
    extends SelectDrum<T, Type> {
  final String label;
  final int min;
  final int max;
  final int step;

  SelectExercise(
      {Key key,
      @required String field,
      @required List<Type> values,
      this.label,
      this.min,
      this.max,
      this.step})
      : super(key: key, field: field, values: values);

  int get value {
    final value = controller.getValue(field);
    if (value == null) return min;

    if (value is GenericEnum) return value.value;

    return value.first.value;
  }

  @override
  Widget build(_) => Column(children: [
        Row(children: [
          Expanded(
              flex: 6,
              child: TextSecondary(label ?? controller.getLabel(field))),
          HorizontalSpace(),
          // B.Button(
          //   borderColor: Colors.disabled,
          //   child: TextPrimary("$value"))
          Expanded(
              flex: 4,
              child: B.Clickable(
                  onPressed: optionHandler,
                  child: Container(
                      padding: Padding.content,
                      decoration: BoxDecoration(
                          borderRadius: borderRadiusCircular,
                          border: Border.all(
                              width: borderWidth,
                              color: Colors.disabled,
                              style: BorderStyle.solid)),
                      child: Center(child: TextPrimary("$value")))))
        ]),
        Slider(
            activeColor: Colors.primary,
            inactiveColor: Colors.disabled,
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: ((max - min).toDouble() / step).round(),
            value: value.toDouble(),
            onChanged: (value) {
              print('SLIDER: ${value.round()} $values');

              var selectedItem;
              for (final item in values)
                if (selectedItem == null ||
                    (value - item.value).abs() <
                        (value - selectedItem.value).abs()) selectedItem = item;

              // controller.onChanged(
              //     field, values.firstWhere((x) => x.value == value.round()));

              controller.onChanged(field, selectedItem);
            })
      ]);
}

class ExerciseFormController extends FormController {
  // ExerciseData item;
  //
  // ExerciseFormController({this.item});

  @override
  List<FormConfig> get config => [
        FormConfig(
            field: 'type',
            label: exerciseTypeTitle,
            type: FieldType.SELECT,
            shouldUpdateOnChange: true),
        FormConfig(
            field: 'value', type: FieldType.SELECT, shouldUpdateOnChange: true)
      ];

  GenericEnum get type {
    final type = getValue('type');
    if (type == null || type is List && type.length == 0) return null;

    return type is List ? type.first : type;
  }

  GenericEnum get value {
    final value = getValue('value');
    if (value == null || value is List && value.length == 0) return null;

    return value is List ? value.first : value;
  }

  // form controller implementation
  @override
  void onChanged(String field, value,
      {bool shouldUpdate = true, bool shouldUpdateController = true}) {
    super.onChanged(field, value,
        shouldUpdate: shouldUpdate,
        shouldUpdateController: shouldUpdateController);

    if (field == 'type') super.onChanged('value', null);
  }

  @override
  Future<bool> onSubmitRequest() async => null;

  @override
  onSubmitResponse(_) => null;
}
