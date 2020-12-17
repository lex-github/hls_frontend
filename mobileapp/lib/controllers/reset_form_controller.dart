import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/validation.dart';

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
