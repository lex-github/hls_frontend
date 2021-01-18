import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:flutter/rendering.dart' as R;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart' as B;
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_form_controller.dart';
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
                  //enable: _isKeyboardVisible,
                  //overscroll: 1,
                  autoScroll: autoScroll,
                  child: buildForm(context),
                  config: KeyboardActionsConfig(
                      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                      keyboardBarColor: Colors.background,
                      keyboardSeparatorColor: Colors.black.withOpacity(.6),
                      nextFocus: true,
                      actions: nodes
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
  Widget build(BuildContext context) => Obx(() => B.Button(
      isCircular: isCircular,
      size: size ?? Size.fab,
      background: controller.isValid ? Colors.primary : Colors.failure,
      padding: padding ?? Padding.zero,
      icon: icon ?? Icons.arrow_forward_ios,
      iconSize: iconSize ?? Size.iconSmall,
      color: color,
      isSelected: controller.isAwaiting,
      isLoading: controller.isAwaiting,
      isDisabled: !controller.isValid,
      onPressed: controller.submitHandler));
}

class Input<T extends FormController> extends GetView<T> {
  final String field;
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

  Input(
      {@required this.field,
      Key key,
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
      this.autovalidateMode})
      : super(key: key);

  @override
  Widget build(_) {
    final remoteValidationMessage = controller.validation
        ?.getMessageForValue(field, controller.getValue(field));
    //final focusNode = form?.getNode(field);

    final validator = _composeValidator(
        controller: controller,
        field: field,
        validationMessage: remoteValidationMessage);

    return Obx(() => TextFormField(
        //enableInteractiveSelection: false,
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
    final types = [FieldType.SELECT, FieldType.MULTI_SELECT];
    if (!types.contains(type))
      throw 'Associated FormController field does should be one of $types';

    // show select
    final result = await Get.to(SelectionScreen<Type>(
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
    String validationMessage,
    FormValidationData validationData}) {
  value ??= controller?.getValue(field);
  validationMessage ??= validationData?.getMessageForValue(field, value);

  // no form controller validation
  if (controller == null)
    return validationMessage == null
        ? null
        : UnchangedValueValidator(
            errorText: validationMessage, prevValue: value);

  // combined validation
  final validator = controller.getValidator(field);
  return !validationMessage.isNullOrEmpty
      ? MultiValidatorWithError([
          UnchangedValueValidator(
              errorText: validationMessage, prevValue: value),
          validator,
        ])
      : validator;
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
