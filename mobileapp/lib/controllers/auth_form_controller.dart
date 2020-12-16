import 'package:get/instance_manager.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/services/auth_service.dart';

class AuthFormController extends FormController {
  bool get shouldShowForm => ((AuthService auth) =>
      auth.isInit && !auth.isAuthenticated)(Get.find<AuthService>());

  @override
  List<FormConfig> get config => [
        FormConfig(
            field: 'login', label: authLoginLabel, validator: loginValidator),
        FormConfig(
            field: 'password',
            label: authPasswordLabel,
            validator: passwordValidator),
      ];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    return false;
  }

  @override
  onSubmitResponse(bool isSuccess) {
    print('AuthFormController.onSubmitResponse '
        'success: $isSuccess '
        'authenticated: ${Get.find<AuthService>().isAuthenticated}');

    if (isSuccess && !Get.find<AuthService>().isAuthenticated)
      return showConfirm(title: errorGenericText);
  }
}
