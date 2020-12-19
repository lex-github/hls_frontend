import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/services/auth_service.dart';

class AuthFormController extends FormController {
  bool get shouldShowForm => ((AuthService auth) =>
      auth.isInit && !auth.isAuthenticated)(AuthService.i);
  bool get isInit => AuthService.i.isInit;
  bool get isAwaiting => AuthService.i.isAwaiting;

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
  Future<bool> onSubmitRequest() async => AuthService.i.login(values);

  @override
  onSubmitResponse(bool isSuccess) => isSuccess && !AuthService.isAuth
      ? showConfirm(title: errorGenericText)
      : null;
}
