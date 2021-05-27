import 'dart:io';

import 'package:flutter/material.dart'
    hide Colors, FormFieldValidator, Icon, Image, Padding, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:flutter/cupertino.dart' as C;
import 'package:flutter/rendering.dart' as R;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
    as DatePickerProvider;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart' as B;
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/screens/_selection_screen.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/theme/styles.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

abstract class FormScreen<T extends FormController> extends GetView<T> {
  T get initController;
  List<String> get nodes => controller?.fields;
  Map<String, PreferredSizeWidget Function(BuildContext)> get keyboards => null;
  bool get tapOutsideToDismiss => true;
  bool get displayArrows => false;
  bool get autoScroll => true;
  List<Widget Function(FocusNode)> get toolbarButtons => null;

  // handlers

  void submitHandler() async => controller.submitHandler();

  // builders

  Widget buildForm(BuildContext context);
  Widget buildScreen({Widget child}) => Screen(child: child);

  @override
  Widget build(context) => GetBuilder<T>(
      init: initController,
      dispose: (_) => Get.delete<T>(),
      builder: (_) => buildScreen(
          child: Form(
              key: controller.key,
              child: KeyboardActions(
                  tapOutsideToDismiss: tapOutsideToDismiss,
                  enable: Platform.isAndroid || Platform.isIOS,
                  //overscroll: 1,
                  autoScroll: autoScroll,
                  child: buildForm(context),
                  config: KeyboardActionsConfig(
                      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                      keyboardBarColor: Colors.background,
                      keyboardSeparatorColor: Colors.black.withOpacity(.6),
                      nextFocus: true,
                      actions: nodes
                          ?.where((field) => controller.getNode(field) != null)
                          ?.map((field) => KeyboardActionsItem(
                              footerBuilder: (keyboards ?? {})[field],
                              displayArrows: displayArrows,
                              focusNode: controller.getNode(field),
                              toolbarButtons: toolbarButtons ??
                                  [
                                    (node) => IconButton(
                                        icon: Icon(Icons.keyboard_hide),
                                        tooltip: 'Hide',
                                        iconSize: Size.icon,
                                        color: Colors.light,
                                        onPressed: node.unfocus),
                                    (node) => HorizontalSmallSpace()
                                  ]))
                          ?.toList(growable: false))))));
}

class Button<T extends FormController> extends GetView<T> {
  final bool isCircular;
  final double size;
  final EdgeInsets padding;
  final IconData icon;
  final double iconSize;
  final Color color;

  Button({
    this.isCircular = true,
    this.size,
    this.padding,
    this.icon = Icons.check,
    this.iconSize,
    this.color = Colors.light,
  });

  @override
  Widget build(_) => Obx(() => B.Button(
      isCircular: isCircular,
      size: size ?? Size.buttonBig,
      background: controller.isValid
          ? controller.submitState == SubmitState.SUCCESS &&
                  !controller.isAwaiting
              ? Colors.success
              : Colors.primary
          : Colors.failure,
      padding: padding ?? Padding.zero,
      icon: icon ?? Icons.arrow_forward_ios,
      //iconSize: iconSize ?? Size.iconSmall,
      color: color,
      isSelected: controller.isAwaiting,
      isLoading: controller.isAwaiting,
      isDisabled: !controller.isValid,
      onPressed: controller.submitHandler));
}

class DatePicker<T extends FormController> extends GetView<T> {
  final String field;
  DatePicker({this.field});

  _datePickerHandler() =>
      DatePickerProvider.DatePicker.showDatePicker(Get.context,
          showTitleActions: true,
          minTime: DateTime.now().subtract((365 * 100).days),
          maxTime: DateTime.now(),
          //onChanged: (_) => null,
          onConfirm: (date) => controller.onChanged(field, date),
          currentTime: controller.getValue(field) ?? DateTime.now(),
          locale: LocaleType.ru,
          theme: DatePickerTheme(
              cancelStyle: TextStyle.primary.copyWith(color: Colors.failure),
              doneStyle: TextStyle.primary.copyWith(color: Colors.primary),
              itemStyle: TextStyle.primary,
              backgroundColor: Colors.background,
              headerColor: Colors.background,
              containerHeight: Size.bottomSheet,
              titleHeight: Size.height(44.0),
              itemHeight: Size.height(36.0)));

  @override
  Widget build(_) => B.Clickable(
      onPressed: _datePickerHandler,
      child: AbsorbPointer(child: Input<T>(field: field)));
}

class Input<T extends FormController> extends GetView<T> {
  final String field;
  final String _tag;
  final TextInputType inputType;
  final int maxLines;
  final int errorMaxLines;
  final bool isHidden;
  final bool isErrorVisible;
  final bool isDisabled;
  final EdgeInsets contentPadding;
  final bool shouldFocus;
  final Widget leading;
  final Widget trailing;
  final AutovalidateMode autovalidateMode;
  final FieldValidator validator;

  Input(
      {@required this.field,
      Key key,
      String tag,
      this.inputType = TextInputType.text,
      this.maxLines = 1,
      this.errorMaxLines = defaultErrorMaxLines,
      this.isHidden = false,
      this.isErrorVisible = true,
      this.isDisabled = false,
      this.shouldFocus = false,
      this.contentPadding,
      this.leading,
      this.trailing,
      this.autovalidateMode,
      this.validator})
      : _tag = tag,
        super(key: key);

  @override
  String get tag => _tag ?? super.tag;

  @override
  Widget build(_) {
    final remoteValidationMessage = controller.validation
        ?.getMessageForValue(field, controller.getValue(field));
    //final focusNode = form?.getNode(field);

    final validator = _composeValidator(
        controller: controller,
        field: field,
        defaultValidator: this.validator,
        validationMessage: remoteValidationMessage);

    return Obx(() => TextFormField(
        //enableInteractiveSelection: false,
        //onChanged: (s) => print(s),
        autofocus: shouldFocus,
        inputFormatters: controller.getFormatters(field),
        maxLines: maxLines,
        style: isDisabled
            ? TextStyle.primary.copyWith(color: Colors.disabled)
            : TextStyle.primary,
        cursorColor: Colors.primary,
        decoration: _getInputDecoration(
            controller: controller,
            shouldHighlight: controller.getState(field).hasFocus ||
                controller.getState(field).hasValue,
            field: field,
            contentPadding: contentPadding,
            isErrorVisible: isErrorVisible,
            errorMaxLines: errorMaxLines,
            leading: leading,
            trailing: trailing),
        keyboardType: inputType,
        obscureText: isHidden,
        controller: controller.getController(field),
        focusNode: controller.getNode(field),
        enabled: !isDisabled,
        validator: validator,
        autovalidateMode: autovalidateMode ??
            (controller.shouldValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction),
        onEditingComplete: () => controller.submitHandler()));
  }
}

class Select<T extends FormController, Type extends GenericEnum>
    extends GetView<T> {
  final String field;
  final List<Type> values;
  final int errorMaxLines;
  final bool isErrorVisible;
  final EdgeInsets contentPadding;
  final Widget Function(SelectionLogicController<Type>, List<Type>) listBuilder;

  Select(
      {Key key,
      @required this.field,
      @required this.values,
      this.errorMaxLines = defaultErrorMaxLines,
      this.isErrorVisible = true,
      this.contentPadding,
      this.listBuilder})
      : super(key: key);

  // handlers

  void _optionHandler() async {
    // get current value
    final value = ((value) => value == null
        ? null
        : value is List
            ? List<Type>.from(value)
            : <Type>[value])(controller.getValue(field));

    // check that config type set correctly
    final type = controller.getType(field);
    final title = controller.getLabel(field);
    final types = [FieldType.SELECT, FieldType.MULTI_SELECT];
    if (!types.contains(type))
      throw 'Associated FormController field does should be one of $types';

    // show select
    final result = await Get.to(SelectionScreen<Type>(
        title: title,
        listBuilder: listBuilder,
        initialValue: value,
        values: values,
        isMultiple: type == FieldType.MULTI_SELECT));
    if (result == null) return;

    //print('Select._optionHandler $result');

    // change controller value
    controller.onChanged(field, result);
  }

  @override
  Widget build(_) {
    final remoteValidationMessage = controller.validation
        ?.getMessageForValue(field, controller.getValue(field));
    //final focusNode = form?.getNode(field);

    final validator = _composeValidator(
        controller: controller,
        field: field,
        validationMessage: remoteValidationMessage);

    final decoration = _getInputDecoration(
        controller: controller,
        field: field,
        contentPadding: contentPadding,
        isErrorVisible: isErrorVisible,
        errorMaxLines: errorMaxLines);

    return MouseRegion(
        cursor: R.SystemMouseCursors.click,
        child: GestureDetector(
            onTap: _optionHandler,
            child: AbsorbPointer(
                child: Obx(() => TextFormField(
                    style: TextStyle.primary,
                    cursorColor: Colors.primary,
                    decoration: decoration,
                    controller: controller.getController(field),
                    focusNode: controller.getNode(field),
                    validator: (_) => validator(controller.getValue(field)),
                    autovalidateMode: controller.shouldValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.onUserInteraction,
                    onEditingComplete: () => controller.submitHandler())))));
  }
}

class SelectDrum<T extends FormController, Type extends GenericEnum>
    extends GetView<T> {
  final String field;
  final List<Type> values;
  final int errorMaxLines;
  final bool isErrorVisible;
  final EdgeInsets contentPadding;

  SelectDrum(
      {Key key,
      @required this.field,
      @required this.values,
      this.errorMaxLines = defaultErrorMaxLines,
      this.isErrorVisible = true,
      this.contentPadding})
      : super(key: key);

  // handlers

  void optionHandler() async {
    // get current value
    final value = ((value) => value == null
        ? null
        : value is List
            ? List<Type>.from(value)
            : <Type>[value])(controller.getValue(field));

    // check that config type set correctly
    final type = controller.getType(field);
    final title = controller.getLabel(field);
    final types = [FieldType.SELECT, FieldType.MULTI_SELECT];
    if (!types.contains(type))
      throw 'Associated FormController field should be one of $types';

    // print('SelectDrum.optionHandler'
    //     '\n\tvalues: $values'
    //     '\n\tvalue: ${value?.first}'
    //     '\n\tindex: ${values.indexOf(value?.first)}');

    // show select
    dynamic result = value;
    await showConfirm(
        contentPadding: contentPadding,
        title: title ?? selectionScreenSingleTitle,
        child: SizedBox(
            height: Size.cupertinoPicker,
            width: Size.screenWidth,
            child: C.CupertinoPicker(
                scrollController: C.FixedExtentScrollController(
                    initialItem:
                        values.indexWhere((x) => x.value == value?.first?.value)),
                useMagnifier: true,
                magnification: 1.1,
                itemExtent: 1.75 * fontSize,
                onSelectedItemChanged: (i) => result = values[i],
                children: [
                  for (final value in values)
                    Center(
                        //widthFactor: 1,
                        // child: Container(
                        //     width: Size.screenWidth - 4 * Size.horizontal,
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: Size.horizontal),
                        child: TextPrimary(value.title,
                            size: 1.15 * fontSize, lines: 1))
                ])));
    if (result == null) return;

    //print('Select._optionHandler $result');

    // change controller value
    controller.onChanged(field, result);
  }

  @override
  Widget build(_) {
    final remoteValidationMessage = controller.validation
        ?.getMessageForValue(field, controller.getValue(field));
    //final focusNode = form?.getNode(field);

    final validator = _composeValidator(
        controller: controller,
        field: field,
        validationMessage: remoteValidationMessage);

    final decoration = _getInputDecoration(
        controller: controller,
        field: field,
        contentPadding: contentPadding,
        isErrorVisible: isErrorVisible,
        errorMaxLines: errorMaxLines);

    return MouseRegion(
        cursor: R.SystemMouseCursors.click,
        child: GestureDetector(
            onTap: optionHandler,
            child: AbsorbPointer(
                child: Obx(() => TextFormField(
                    style: TextStyle.primary,
                    cursorColor: Colors.primary,
                    decoration: decoration,
                    controller: controller.getController(field),
                    focusNode: controller.getNode(field),
                    validator: (_) => validator(controller.getValue(field)),
                    autovalidateMode: controller.shouldValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.onUserInteraction,
                    onEditingComplete: () => controller.submitHandler())))));
  }
}

class Switch<T extends FormController, Type extends GenericEnum>
    extends GetView<T> {
  final String field;
  final List<Type> values;
  final bool isErrorVisible;

  Switch(
      {Key key,
      @required this.field,
      @required this.values,
      this.isErrorVisible = true})
      : super(key: key);

  // builders

  _buildOption(Type value) => B.Button(
      isSwitch: true,
      isSelected: controller.getValue(field) == value,
      size: Size.iconBig,
      child: value.imageTitle.isNullOrEmpty
          ? null
          : Image(
              title: value.imageTitle,
              size: Size.iconBig * .5,
            ),
      icon: value.icon,
      onPressed: () => controller.onChanged(field, value));

  @override
  Widget build(_) {
    final remoteValidationMessage = controller.validation
        ?.getMessageForValue(field, controller.getValue(field));

    final validator = _composeValidator(
        controller: controller,
        field: field,
        validationMessage: remoteValidationMessage);

    //print('Switch.build ${controller.getValue(field)}');

    return Column(children: [
      Row(children: [
        for (final value in values) ...[
          _buildOption(value),
          if (value != values.last) HLSpace()
        ]
      ]),
      Obx(() => controller.shouldValidate
          ? ((String error) => error.isNullOrEmpty
              ? Nothing()
              : Container(
                  padding: EdgeInsets.only(top: Size.verticalSmall),
                  child:
                      TextError(error)))(validator(controller.getValue(field)))
          : Nothing())
    ]);
  }
}

FormFieldValidator _composeValidator(
    {@required FormController controller,
    @required String field,
    dynamic value,
    FieldValidator defaultValidator,
    String validationMessage,
    FormValidationData validationData}) {
  value ??= controller?.getValue(field);
  validationMessage ??= validationData?.getMessageForValue(field, value);

  // no form controller validation
  if (controller == null)
    return validationMessage == null
        ? defaultValidator
        : UnchangedValueValidator(
            errorText: validationMessage, prevValue: value);

  // combined validation
  final validator = controller.getValidator(field);

  return MultiValidatorWithError(<FieldValidator>[
    if (!validationMessage.isNullOrEmpty)
      UnchangedValueValidator(errorText: validationMessage, prevValue: value),
    if (defaultValidator != null) defaultValidator,
    if (validator != null) validator
  ]);
}

InputDecoration _getInputDecoration(
        {FormController controller,
        String field,
        bool shouldHighlight = false,
        String prefixImage,
        Widget leading,
        String suffixImage,
        Widget trailing,
        bool isErrorVisible = true,
        EdgeInsets contentPadding,
        int errorMaxLines}) =>
    InputDecoration(
        alignLabelWithHint: true,
        prefixIcon: leading.isNotNull
            ? Center(
                widthFactor: 0,
                child: Container(
                    padding: M.EdgeInsets.only(right: Size.horizontalTiny),
                    child: leading))
            : prefixImage.isNullOrEmpty
                ? null
                : Container(
                    child: Image(title: prefixImage),
                    padding: M.EdgeInsets.only(left: Size.horizontalSmall)),
        suffixIcon: trailing.isNotNull
            ? Center(
                widthFactor: 0,
                child: Container(
                    padding: M.EdgeInsets.only(left: Size.horizontalTiny),
                    child: trailing))
            : suffixImage.isNullOrEmpty
                ? null
                : Container(
                    child: Image(title: suffixImage, color: Colors.icon),
                    padding: M.EdgeInsets.only(right: Size.horizontalSmall)),
        prefixIconConstraints:
            BoxConstraints(minHeight: Size.icon, minWidth: Size.icon),
        suffixIconConstraints:
            BoxConstraints(minHeight: Size.icon, minWidth: Size.icon),
        hintText: controller.getHint(field),
        labelText: controller.getLabel(field),
        errorStyle: isErrorVisible
            ? TextStyle.error
            : M.TextStyle(height: 0, fontSize: 0),
        labelStyle:
            //isDisabled ? TextStyle.primary.copyWith(color: Colors.disabled) :
            shouldHighlight
                ? TextStyle.primary.copyWith(color: Colors.primary, height: .9)
                : TextStyle.primary.copyWith(color: Colors.icon, height: .9),
        focusColor: Colors.primary,
        hintStyle: M.TextStyle(color: Colors.disabled),
        //alignLabelWithHint:true,
        contentPadding:
            contentPadding ?? EdgeInsets.only(bottom: Size.verticalSmall),
        isDense: true,
        enabledBorder: inputBorder,
        focusedBorder: focusedInputBorder,
        errorBorder: errorInputBorder,
        disabledBorder: disabledBorder,
        focusedErrorBorder: errorInputBorder,
        errorMaxLines: errorMaxLines);

class UnderlineInputShadowBorder extends UnderlineInputBorder {
  final BorderRadius borderRadius;
  final BorderSide topBorderSide;
  final BorderSide bottomBorderSide;

  UnderlineInputShadowBorder(
      {BorderSide borderSide = const BorderSide(),
      shadowColor = Colors.transparent,
      this.borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(4.0),
        topRight: Radius.circular(4.0),
      )})
      : assert(borderRadius != null),
        topBorderSide = borderSide.copyWith(width: borderSide.width / 2),
        bottomBorderSide = borderSide.copyWith(
            color: shadowColor, width: borderSide.width / 2),
        super(borderSide: borderSide);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection textDirection,
  }) {
    Offset o = Offset(0, borderSide.width / 4);
    if (borderRadius.bottomLeft != Radius.zero ||
        borderRadius.bottomRight != Radius.zero)
      canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
    canvas.drawLine(
        rect.bottomLeft + o, rect.bottomRight + o, bottomBorderSide.toPaint());
    canvas.drawLine(
        rect.bottomLeft - o, rect.bottomRight - o, topBorderSide.toPaint());
  }
}

final inputBorder = UnderlineInputShadowBorder(
    borderSide: BorderSide(color: Colors.icon, width: Size.border),
    shadowColor: Colors.shadow);
final focusedInputBorder = UnderlineInputShadowBorder(
    borderSide: BorderSide(color: Colors.primary, width: Size.border),
    shadowColor: Colors.shadow);
final errorInputBorder = UnderlineInputShadowBorder(
    borderSide: BorderSide(color: Colors.failure, width: Size.border),
    shadowColor: Colors.shadow);
final disabledBorder = UnderlineInputShadowBorder(
    borderSide: BorderSide(color: Colors.icon, width: Size.border),
    shadowColor: Colors.shadow);
