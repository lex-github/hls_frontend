import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/_generic_model.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/services/_service.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

abstract class FormController extends GetxController {
  // fields

  final _key = GlobalKey<FormState>();
  final _state = <String, FormControllerState>{};
  final _submitState = Rx<SubmitState>();
  final _isDirty = false.obs;
  final _isAwaiting = false.obs;
  final _isKeyboardVisible = false.obs;
  final _isValid = false.obs;
  final _error = RxString();

  int _keyboardListenerId;

  // get x implementation

  @override
  void onInit() {
    loadConfig();

    super.onInit();
  }

  @override
  void onClose() {
    print('_FormController.onClose');

    // free textInputField related resources
    for (final state in _state.values)
      state..controller?.dispose()..node?.dispose();

    // free keyboard visibility listener
    if (_keyboardListenerId != null)
      KeyboardVisibilityNotification().removeListener(_keyboardListenerId);

    super.onClose();
  }

  // need to be implemented

  List<FormConfig> get config;
  Future<bool> onSubmitRequest();
  onSubmitResponse(bool isSuccess);

  // getters

  GlobalKey<FormState> get key => _key;
  String get error => _error.value;
  bool get shouldValidate => _isDirty.value;
  bool get shouldUnfocus => true;
  SubmitState get submitState => _submitState.value;
  bool get isAwaiting => _isAwaiting.value;
  bool get isValid => shouldValidate ? _isValid.value : true;
  bool get isValidIgnoreDirty => _isValid.value;
  bool get isKeyboardVisible => _isKeyboardVisible.value;
  bool get hasValidationErrors => false;
  FormValidationData get validation => null;
  List<String> get fields => _state.keys.toList(growable: true);
  Map<String, dynamic> get values =>
      _state.map((field, state) => MapEntry(field, state.value));
  Map<String, dynamic> get valuesEncodable =>
      values.map((field, value) => MapEntry(
          field,
          value is GenericData
              ? value.id
              : value is GenericEnum
                  ? value.value
                  : value));

  FormControllerState getState(String field) =>
      _state.get<FormControllerState>(field);
  T getValue<T>(String field) => getState(field)?.value;
  TextEditingController getController(String field) =>
      getState(field)?.controller;
  FocusNode getNode(String field) => getState(field)?.node;
  FormConfig getConfig(String field) => getState(field)?.config;
  String getLabel(String field) => getConfig(field)?.label;
  String getHint(String field) => getConfig(field)?.hint;
  FieldType getType(String field) => getConfig(field)?.type;
  FieldValidator getValidator(String field) => getConfig(field)?.validator;
  List<TextInputFormatter> getFormatters(String field) =>
      getConfig(field)?.formatters;
  bool isValidField(String field) {
    final validator = getValidator(field);
    if (validator == null) return true;

    return validator(getValue(field)).isNullOrEmpty;
  }

  // setters

  set isDirty(bool x) => _isDirty.value = x;
  set submitState(SubmitState x) {
    Future.delayed(defaultAnimationDuration)
        .then((_) => _submitState.value = x)
        .then((_) => Future.delayed(inputWaitingDuration))
        .then((_) => _submitState.value = SubmitState.DEFAULT);
  }

  set isAwaiting(bool x) => _isAwaiting.value = x;
  set isValid(bool x) => _isValid.value = x;
  set isKeyboardVisible(bool x) => _isKeyboardVisible.value = x;
  set error(String x) => _error.value = x;

  // events

  void onKeyboardChanged(bool isVisible) => null;

  void onChanged(String field, dynamic value,
      {bool shouldUpdate = true, bool shouldUpdateController = true}) {
    print('FormController.onChanged $field: $value');

    _state[field] ??= FormControllerState();
    final state = _state[field];

    // transform value
    value = state.config?.toValue != null ? state.config.toValue(value) : value;

    // update value
    if (shouldUpdate && state.value != value) {
      state.setValue(value, shouldUpdate: shouldUpdateController);

      if (state.controller == null) update();
    }

    // global validation
    isValid = fields
            .map((field) => isValidField(field))
            .firstWhere((isValid) => !isValid, orElse: () => null) ==
        null;
  }

  // methods
  loadConfig() {
    for (final config in this.config) {
      FormControllerState state = FormControllerState();
      switch (config.type) {
        case FieldType.SELECT:
        case FieldType.MULTI_SELECT:
        case FieldType.DATE_PICKER:
          state
            ..controller = TextEditingController()
            ..node = FocusNode();
          break;
        case FieldType.SWITCH:
          break;
        default:
          state
            ..controller = (TextEditingController()
              // input controller controls state
              ..addListener(() => onChanged(config.field, state.controller.text,
                  shouldUpdateController: false)))
            ..node = (FocusNode()
              ..addListener(() => state.hasFocus = state.node.hasFocus));
      }

      //print('FormController.onInit $config');

      _state[config.field] = state
        ..config = config
        ..value = config.value;

      // keyboard listener
      _keyboardListenerId = KeyboardVisibilityNotification().addNewListener(
          onChange: (bool visible) async {
        isKeyboardVisible = visible;

        onKeyboardChanged(visible);
      });
    }
  }

  reloadConfig() {
    for (final config in this.config) _state[config.field].config = config;
  }

  bool validate() => _key.currentState?.validate() ?? true;

  void submitHandler() async {
    // hide keyboard
    if (shouldUnfocus)
      for (final field in fields) {
        final node = getNode(field);
        if (node != null && node.hasFocus) {
          node.unfocus();
          break;
        }
      }

    // form model marked as having input, autovalidation of fields will trigger
    isDirty = true;

    // if we are awaiting for prev login request abort
    if (isAwaiting) return showConfirm(title: requestWaitingText);

    // if form is not valid abort
    if (!validate()) return;

    // awaiting for server response to login attempt
    isAwaiting = true;
    //submitState = SubmitState.WAITING;
    final result = await onSubmitRequest();
    isAwaiting = false;
    if (!result.isNullEmptyOrFalse) {
      submitState = SubmitState.SUCCESS;
      return onSubmitResponse(true);
    }

    // check if onSubmitRequest generated validation error
    if (!hasValidationErrors) showConfirm(title: error ?? errorGenericText);

    //submitState = SubmitState.FAILURE;
    onSubmitResponse(false);
  }

  Future<HttpResponse> request<T extends Service>(
      Future<HttpResponse> Function(T) callback) async {
    isAwaiting = true;
    final response = await callback(Get.find<T>());
    error = response.error;
    isAwaiting = false;
    return response;
  }
}

class FormControllerState {
  TextEditingController controller;
  FocusNode node;
  FormConfig config;

  String _toRepresentation(value) {
    if (value == null) return '';

    if (value is List) return value.map(_toRepresentation).join(', ');

    if (config?.toRepresentation != null) return config.toRepresentation(value);

    return value.toString();
  }

  bool get isValid =>
      config.validator == null || config.validator(value).isNullOrEmpty;

  // working with focus
  final _hasFocus = false.obs;
  get hasFocus => _hasFocus.value;
  set hasFocus(bool x) => _hasFocus.value != x ? _hasFocus.value = x : null;

  // working with value
  final _hasValue = false.obs;
  get hasValue => _hasValue.value;
  set hasValue(bool x) => _hasValue.value != x ? _hasValue.value = x : null;

  // working with value
  dynamic _value;
  get value => _value;
  set value(x) => setValue(x);
  setValue(x, {bool shouldUpdate = true}) {
    _value = x;
    hasValue = value != null && (value is String ? value.length != 0 : true);
    if (shouldUpdate && controller != null) {
      final String value = _toRepresentation(x);

      //print('FormControllerState._toRepresentation ${config.field}: $x => $value (${controller.text})');

      if (controller.text != value) {
        if (value.isNullOrEmpty)
          controller.clear();
        else
          controller.text = value;
      }
    }
  }

  @override
  String toString() => 'FormControllerState('
      '\n\tvalue: $value'
      ')';
}

class FormConfig {
  final String field;
  final String label;
  final String hint;
  final FieldValidator validator;
  final List<TextInputFormatter> formatters;
  final FieldType type;
  final value;
  final String Function(dynamic) toRepresentation;
  final dynamic Function(String) toValue;

  FormConfig(
      {@required this.field,
      this.label,
      this.hint,
      this.validator,
      this.formatters,
      this.type = FieldType.INPUT,
      this.value,
      this.toRepresentation,
      this.toValue});

  @override
  String toString() => 'FormConfig(field: $field, value: $value)';
}

class FieldType extends Enum<int> {
  const FieldType(v) : super(v);

  static const INPUT = const FieldType(1);
  static const SELECT = const FieldType(2);
  static const MULTI_SELECT = const FieldType(3);
  static const SWITCH = const FieldType(4);
  static const DATE_PICKER = const FieldType(5);
}

class SubmitState extends Enum<int> {
  const SubmitState(v) : super(v);

  static const DEFAULT = const SubmitState(0);
  static const WAITING = const SubmitState(1);
  static const SUCCESS = const SubmitState(2);
  static const FAILURE = const SubmitState(3);
}

// lowercase text formatter
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(
        text: newValue.text?.toLowerCase(),
        selection: newValue.selection,
      );
}
