import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/controllers/chat_controller.dart';

class ChatFormController extends FormController {
  final field = 'input';
  final FieldValidator validator;
  ChatFormController({this.validator});

  @override
  List<FormConfig> get config =>
      [FormConfig(field: field, label: chatInputLabel, validator: validator)];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    final result = await Get.find<ChatController>().post(getValue(field));
    if (result == true) {
      onChanged(field, '');
      isDirty = false;
    }
    return result;
  }

  @override
  onSubmitResponse(_) => null;
}
