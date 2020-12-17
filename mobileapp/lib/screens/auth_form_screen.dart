import 'package:flutter/material.dart' hide Colors, Image, Padding;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/components/buttons.dart' as B;
import 'package:hls/components/generic.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/auth_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/services/settings_service.dart';
import 'package:hls/theme/styles.dart';

class AuthFormScreen<T extends AuthFormController> extends FormScreen<T> {
  static final _key = GlobalKey(debugLabel: 'authForm');
  static final _formPadding = Size.horizontal * 2;

  // handlers

  _registerHandler() => showConfirm(title: developmentText);
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
                            child: TextActive(authPasswordForgotLabel))
                      ]))
              ] else if (!controller.isInit)
                Loading()
            ]));
      });

  @override
  Widget buildScreen({Widget child}) => Screen(
      fab: controller.shouldShowForm ? Mutation(
          options: MutationOptions(
              documentNode: gql(authSignInMutation),
              update: (Cache cache, QueryResult result) => cache,
              onCompleted: (result) { print(
                  '\n-----\nAuthFormScreen.buildScreen onCompleted: $result');

                final String token = (result as Map<String, dynamic>).get(['authSignIn', 'authToken']);
              print('AuthFormScreen.buildScreen token: $token');
                if (token.isNullOrEmpty)
                  return showConfirm(title: errorGenericText);

                Get.find<SettingsService>().token = token;
              },
              onError: (error) {
                // if (!(error?.clientException?.message?.isNullOrEmpty ?? true))
                //   showConfirm(title: error.clientException.message);
              }),
          builder: (run, result) => B.Button(
              onPressed: () {
                /// TODO: rewrite all of this shit
                controller.isDirty = true;
                if (!controller.validate()) return;

                run(controller.values);
              },
              isCircular: true,
              isSwitch: result.loading,
              isLoading: result.loading,
              isSelected: result.loading,
              size: Size.fab,
              color: Colors.light,
              background: Colors.primary,
              padding: Padding.zero,
              icon: Icons.arrow_forward_ios,
              iconSize: Size.iconSmall)) : Nothing(),
      padding: Padding.zero,
      shouldHaveAppBar: false,
      leading: Nothing(),
      child: child);

  @override
  T get initController => AuthFormController() as T;
}
