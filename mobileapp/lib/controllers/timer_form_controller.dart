import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/helpers/validation.dart';

class TimerFormController extends FormController {
  final field = 'input';

  @override
  List<FormConfig> get config => [
        FormConfig(
            field: field, label: timerInputLabel, validator: timerValidator)
      ];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    Get.back(result: getValue(field));
    return true;
  }

  @override
  onSubmitResponse(_) => null;
}
