import 'package:flutter/material.dart' hide Colors, Image, Padding;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart' as B;
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/reset_form_controller.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/theme/styles.dart';

class ResetFormScreen<T extends ResetFormController> extends FormScreen<T> {
  static final _key = GlobalKey(debugLabel: 'resetForm');
  static final _formPadding = Size.horizontal * 2;

  // handlers

  _loginHandler() => Get.back();

  // builders

  @override
  Widget buildForm(_) => Obx(() {
        final isKeyboardVisible = controller.isKeyboardVisible;

        return Container(
            padding: EdgeInsets.symmetric(
                horizontal: _formPadding, vertical: Padding.content.top),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (!isKeyboardVisible) ...[
                TextSecondaryAlt(authReset1Text, textAlign: TextAlign.center),
                VerticalMediumSpace(),
                TextSecondaryAlt(authReset2Text, textAlign: TextAlign.center),
                VerticalBigSpace(),
              ],
              VerticalMediumSpace(),
              Container(key: _key, child: Input<T>(field: 'login')),
              VerticalMediumSpace(),
              if (!isKeyboardVisible) ...[
                VerticalBigSpace(),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Size.horizontalMedium),
                    child: B.Button(
                        onPressed: _loginHandler, title: authLoginButtonLabel))
              ]
            ]));
      });

  @override
  Widget buildScreen({Widget child}) => Screen(
      fab: Button<T>(
          isCircular: true,
          size: Size.fab,
          color: Colors.primary,
          icon: Icons.arrow_forward_ios,
          iconSize: Size.iconSmall),
      padding: Padding.zero,
      shouldHaveAppBar: false,
      child: child);

  @override
  T get initController => ResetFormController() as T;
}
