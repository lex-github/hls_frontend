/// {@category components}
/// Methods for displaying modal dialog widgets.
library common_dialog;

import 'package:flutter/material.dart' hide Colors, Padding, TextStyle;
import 'package:get/get.dart' hide Translations;
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/theme/styles.dart';

/// Global key to access scaffold and display modal without context.
/// TODO: use [Get] package instead
final scaffoldKey = GlobalKey<ScaffoldState>();

/// Mixin to display common dialog patterns such as confirmation message or
/// binary choice.
mixin CommonDialog {
  /// Display message
  ///
  /// Display short message in a form of [SnackBar] i.e., a short informational widget from
  /// the bottom of teh screen.
  // showMessage(String text, {context}) {
  //   print('CommonDialog.showMessage $text');
  //
  //   ScaffoldState scaffoldState =
  //       context != null ? Scaffold.of(context) : scaffoldKey.currentState;
  //   scaffoldState.showSnackBar(SnackBar(
  //     content: Text(text, style: TextStyle.secondary),
  //     action: SnackBarAction(
  //         label: 'x', onPressed: scaffoldState.hideCurrentSnackBar),
  //   ));
  // }

  /// Display confirmation modal.
  ///
  /// Display message that requires confirmation in a form of [AlertDialog] i.e., a short informational
  /// widget which blocks screen until interacted with, usually a result of action like remote request.
  // Future showConfirm(
  //     {onPressed,
  //     title,
  //     description,
  //     Widget child,
  //     Widget confirm,
  //     bool shouldShowConfirm = true,
  //     String confirmImageTitle}) async {
  //   // color
  //   final Color textColor = Colors.primary;
  //   final Color backgroundColor = Colors.background;
  //
  //   final buttonPressedHandler = () {
  //     Get.back();
  //
  //     if (onPressed != null) onPressed();
  //   };
  //
  //   // set up the button
  //   final button = confirm ??
  //       CircularButton(
  //           imageTitle: confirmImageTitle ?? 'icons/submit',
  //           size: SizeConfig.height(buttonSmallHeight),
  //           onPress: (_) => buttonPressedHandler());
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //       insetPadding: Padding.alert,
  //       titlePadding: Padding.generic,
  //       contentPadding: EdgeInsets.symmetric(
  //           horizontal: SizeConfig.width(horizontalPadding)),
  //       actionsPadding: shouldShowConfirm
  //           ? EdgeInsets.symmetric(vertical: SizeConfig.height(verticalPadding))
  //           : EdgeInsets.only(bottom: SizeConfig.height(verticalPadding)),
  //       buttonPadding: Padding.zero,
  //       shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular),
  //       backgroundColor: backgroundColor,
  //       title: title != null
  //           ? Text(title,
  //               textAlign: TextAlign.center,
  //               style: TextStyle.big.copyWith(color: textColor))
  //           : null,
  //       content: child != null
  //           ? child
  //           : description != null
  //               ? Text(description,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle.primary.copyWith(color: textColor))
  //               : null,
  //       actions: [
  //         if (shouldShowConfirm) button,
  //       ]);
  //
  //   // show the dialog
  //   return await Get.dialog(alert);
  // }

  /// Display switch modal.
  ///
  /// Display message that requires binary selection in a form of [AlertDialog] i.e., a short questioning
  /// widget which blocks screen until interacted with, usually a prompt for selection in form.
  Future<T> showSwitch<T>(
      {title,
      description,
      @required Widget left,
      @required Widget right,
      T Function() onLeft,
      T Function() onRight}) async {
    // onLeft ??= () => null;
    // onRight ??= () => null;

    // color
    final Color textColor = Colors.primary;
    final Color backgroundColor = Colors.background;

    // set up the buttons
    Widget leftButton = CircularButton(
        onPressed: () => Get.back(result: onLeft()), child: left);

    Widget rightButton = CircularButton(
        onPressed: () => Get.back(result: onRight()), child: right);

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        titlePadding: EdgeInsets.symmetric(vertical: Size.vertical),
        contentPadding: EdgeInsets.symmetric(horizontal: Size.horizontal),
        actionsPadding: EdgeInsets.symmetric(vertical: Size.vertical),
        buttonPadding: Padding.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular),
        backgroundColor: backgroundColor,
        title: title != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle.primary.copyWith(color: textColor)))
            : null,
        content: description != null
            ? description is String
                ? Text(description,
                    textAlign: TextAlign.center,
                    style: TextStyle.primary.copyWith(color: textColor))
                : description
            : null,
        actions: [leftButton, HorizontalBigSpace(), rightButton]);

    // show the dialog
    return await Get.dialog(alert);
  }

  /// Display authorization navigation widget.
  ///
  /// Display selection to proceed either to [RegisterScreen] or [LoginScreen].
  ///
  /// See [showSwitch].
  // Future<dynamic> showNotAuthorized() async {
  //   Widget result = await showSwitch(
  //       title: Translations().notAuthorizedTitle,
  //       description: Translations().notAuthorizedDescription,
  //       imageTitleLeft: 'icons/register',
  //       imageTitleRight: 'icons/login',
  //       onLeft: () => RegisterScreen(),
  //       onRight: () => LoginScreen());
  //
  //   if (result != null) Get.to(result);
  // }
}
