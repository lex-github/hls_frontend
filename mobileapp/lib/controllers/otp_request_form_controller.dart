import 'package:get/get.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/services/auth_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class OtpRequestFormController extends FormController {
  bool get shouldShowForm => ((AuthService auth) =>
      auth.isInit && !auth.isAuthenticated)(AuthService.i);
  bool get isInit => AuthService.i.isInit;
  bool get isAwaiting => AuthService.i.isAwaiting;

  @override
  List<FormConfig> get config => [
        FormConfig(
            field: 'phone',
            label: otpPhoneLabel,
            validator: phoneValidator,
            formatters: [
              MaskTextInputFormatter(
                  mask: phoneMaskPattern, filter: {"#": RegExp(r'[0-9]')})
            ]),
      ];

  // form controller implementation

  String get phone => '+' + getValue('phone').replaceAll(RegExp('[^0-9.]'), '');

  @override
  Future<bool> onSubmitRequest() async =>
      AuthService.i.otpRequest(phone: phone);

  @override
  onSubmitResponse(bool isSuccess) =>
      isSuccess ? Get.toNamed(otpVerifyRoute, arguments: phone) : null;

  @override
  void onChanged(String field, value,
      {bool shouldUpdate = true, bool shouldUpdateController = true}) {
    super.onChanged(field, value,
        shouldUpdate: shouldUpdate,
        shouldUpdateController: shouldUpdateController);

    print('$value');

    if (field == 'phone' && value.length == 18) submitHandler();
  }
}
