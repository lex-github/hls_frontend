import 'package:flutter/material.dart' hide Colors, Image, Padding;
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/otp_verify_form_controller.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/theme/styles.dart';

class OtpVerifyFormScreen<T extends OtpVerifyFormController>
    extends FormScreen<T> {
  static final _key = GlobalKey(debugLabel: 'otpVerifyForm');
  static final _formPadding = Size.horizontal * 2;

  // builders

  @override
  Widget buildForm(_) => Obx(() {
        final isKeyboardVisible = controller.isKeyboardVisible;

        return Container(
            padding: Padding.content,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (!isKeyboardVisible)
                Hero(
                  tag: 'login',
                  child: Image(
                      width: Get.mediaQuery.size.width,
                      fit: BoxFit.fitWidth,
                      title: 'login')),
              VerticalMediumSpace(),
              if (controller.shouldShowForm) ...[
                Container(
                    key: _key,
                    padding: EdgeInsets.symmetric(horizontal: _formPadding),
                    child: Input<T>(field: 'code'))
              ] else if (!controller.isInit)
                Loading()
            ]));
      });

  @override
  Widget buildScreen({Widget child}) => Screen(
      fab: Obx(() =>
          controller.getState('code').hasValue && controller.isValidIgnoreDirty
              ? Button<T>()
              : Nothing()),
      padding: Padding.zero,
      shouldHaveAppBar: false,
      child: child);

  @override
  T get initController => OtpVerifyFormController(phone: Get.arguments) as T;
}
