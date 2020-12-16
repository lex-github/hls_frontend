import 'package:get/instance_manager.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/services/auth_service.dart';

class ResetFormController extends FormController {
  @override
  List<FormConfig> get config => [
        FormConfig(
            field: 'login', label: authLoginLabel, validator: loginValidator)
      ];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    return false;
  }

  @override
  onSubmitResponse(bool isSuccess) {
    print('ResetFormController.onSubmitResponse '
        'success: $isSuccess ');
  }
}
