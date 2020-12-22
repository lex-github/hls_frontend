import 'package:flutter/material.dart' hide Colors, Image, Padding;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart' as B;
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/auth_form_controller.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/theme/styles.dart';

class AuthFormScreen<T extends AuthFormController> extends FormScreen<T> {
  static final _key = GlobalKey(debugLabel: 'authForm');
  static final _formPadding = Size.horizontal * 2;

  // handlers

  _registerHandler() => Get.toNamed(chatRoute);
  _forgetPasswordHandler() => Get.toNamed(resetRoute);

  // builders

  @override
  Widget buildForm(_) => Obx(() {
        final isKeyboardVisible = controller.isKeyboardVisible;

        return Container(
            padding: Padding.content,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (!isKeyboardVisible)
                Image(
                    width: Get.mediaQuery.size.width,
                    fit: BoxFit.fitWidth,
                    title: 'login'),
              VerticalMediumSpace(),
              if (controller.shouldShowForm) ...[
                Container(
                    key: _key,
                    padding: EdgeInsets.symmetric(horizontal: _formPadding),
                    child: Column(children: [
                      Input<T>(field: 'login'),
                      VerticalMediumSpace(),
                      Input<T>(field: 'password', isHidden: true),
                    ])),
                VerticalMediumSpace(),
                if (!isKeyboardVisible)
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: _formPadding),
                      child: Column(children: [
                        VerticalBigSpace(),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size.horizontalMedium),
                            child: B.Button(
                                onPressed: _registerHandler,
                                title: authRegisterButtonLabel)),
                        VerticalBigSpace(),
                        B.Clickable(
                            onPressed: _forgetPasswordHandler,
                            child: TextSecondaryActive(authPasswordForgotLabel))
                      ]))
              ] else if (!controller.isInit)
                Loading()
            ]));
      });

  @override
  Widget buildScreen({Widget child}) => Screen(
      fab: controller.shouldShowForm
          ? Button<T>()
          : Nothing(),
      padding: Padding.zero,
      shouldHaveAppBar: false,
      leading: Nothing(),
      child: child);

  @override
  T get initController => AuthFormController() as T;
}
