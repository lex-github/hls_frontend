import 'package:flutter/foundation.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/services/auth_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class OtpVerifyFormController extends FormController {
  final String phone;
  OtpVerifyFormController(
      {@required this.phone}); // : assert(!phone.isNullOrEmpty);

  bool get shouldShowForm => ((AuthService auth) =>
      auth.isInit && !auth.isAuthenticated)(AuthService.i);
  bool get isInit => AuthService.i.isInit;
  bool get isAwaiting => AuthService.i.isAwaiting;

  @override
  List<FormConfig> get config => [
        FormConfig(
            field: 'code',
            label: otpCodeLabel,
            validator: codeValidator,
            formatters: [
              MaskTextInputFormatter(
                  mask: codeMaskPattern, filter: {"#": RegExp(r'[0-9]')})
            ]),
      ];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async => AuthService.i.otpVerify(
      phone: phone, code: getValue('code').replaceAll(RegExp('[^0-9.]'), ''));

  @override
  onSubmitResponse(bool isSuccess) => null;

  @override
  void onChanged(String field, value,
      {bool shouldUpdate = true, bool shouldUpdateController = true}) {
    super.onChanged(field, value,
        shouldUpdate: shouldUpdate,
        shouldUpdateController: shouldUpdateController);

    if (field == 'code' && value.length == 6) submitHandler();
  }
}
