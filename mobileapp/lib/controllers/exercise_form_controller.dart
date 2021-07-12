import 'dart:async';

import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/validation.dart';

class ExerciseFormController extends FormController {
  static final field = 'rate';
  ExerciseFormController();

  @override
  List<FormConfig> get config =>
      [FormConfig(field: field, label: heartRateLabel, validator: heartRateValidator)];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    if (!getState(field).isValid) {
      error = errorFormText;
      return false;
    }

    //final result = await controller.post(getValue(field));
    final result = true;
    if (result == true) {
      final value = int.parse(getValue(field));

      print('ExerciseFormController.onSubmitRequest $field: $value');

      if (completer != null)
        completer.complete(value);

      _shouldRequestRate.value = false;

      isDirty = false;
      onChanged(field, '');
    }

    return result;
  }

  @override
  onSubmitResponse(_) => null;

  // requesting rate
  final _shouldRequestRate = false.obs;
  bool get shouldRequestRate => _shouldRequestRate.value;
  Completer<int> completer;

  Future<int> requestRate() async {
    _shouldRequestRate.value = true;

    completer = new Completer<int>();
    return completer.future;
  }
}
