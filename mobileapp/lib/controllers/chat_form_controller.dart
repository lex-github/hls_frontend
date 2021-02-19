import 'package:flutter/foundation.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/controllers/chat_controller.dart';

class ChatFormController extends FormController {
  final field = 'input';
  final ChatController controller;
  ChatFormController({@required this.controller});

  FieldValidator validator;

  @override
  List<FormConfig> get config =>
      [FormConfig(field: field, label: chatInputLabel, validator: validator)];

  // form controller implementation

  @override
  bool get shouldUnfocus => false;

  @override
  bool get shouldValidate => super.shouldValidate || getState(field).hasValue;

  @override
  Future<bool> onSubmitRequest() async {
    if (!getState(field).isValid) {
      error = errorFormText;
      return false;
    }

    final result = await controller.post(getValue(field));
    if (result == true) {
      isDirty = false;
      onChanged(field, '');
    }

    return result;
  }

  @override
  void onKeyboardChanged(isVisible) async {
    await Future.delayed(defaultAnimationDuration);
    await Future.delayed(defaultAnimationDuration);

    controller.scroll();
  }

  @override
  onSubmitResponse(_) => controller.scroll();
}
