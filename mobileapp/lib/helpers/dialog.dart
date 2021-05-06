import 'package:flutter/material.dart' hide Colors, Padding, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/theme/styles.dart';

Future showConfirm(
    {onPressed,
    title,
    description,
    Widget child,
    Widget confirm,
    EdgeInsets titlePadding,
    EdgeInsets contentPadding,
    EdgeInsets buttonPadding,
    bool shouldShowConfirm = true,
    String confirmImageTitle}) async {
  titlePadding ??= EdgeInsets.only(
      top: Size.verticalBig, right: Size.horizontal, left: Size.horizontal);
  contentPadding ??= description == null && child == null
      ? Padding.zero
      : EdgeInsets.only(top: Size.vertical);
  buttonPadding ??= EdgeInsets.symmetric(
      horizontal: Size.horizontal, vertical: Size.verticalBig);

  // colors
  final Color backgroundColor = Colors.background;

  final buttonPressedHandler = () {
    Get.back();

    if (onPressed != null) onPressed();
  };

  // set up the button
  final button = confirm ??
      CircularButton(
          icon: confirmImageTitle ?? Icons.check,
          //padding: Padding.tiny,
          size: 1.2 * Size.button,
          onPressed: buttonPressedHandler);

  // set up the AlertDialog
  final alert = AlertDialog(
      //elevation: 50,
      insetPadding: Padding.content,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      actionsPadding: shouldShowConfirm
          // ? EdgeInsets.symmetric(vertical: 2 * Size.verticalBig)
          ? Padding.zero
          : EdgeInsets.only(bottom: 2 * Size.verticalBig),
      buttonPadding: Padding.zero,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadiusCircular,
          side: BorderSide(color: Colors.disabled)),
      backgroundColor: backgroundColor,
      title: title != null ? TextPrimary(title, align: TextAlign.center) : null,
      content: child != null
          ? child
          : description != null
              ? SingleChildScrollView(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: Size.horizontal),
                      child: TextSecondary(description)))
              : null,
      actions: [
        if (shouldShowConfirm) Container(padding: buttonPadding, child: button),
      ]);

  // show the dialog
  return await Get.dialog(alert,
      barrierColor: Colors.background.withOpacity(.9));
}

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
  Widget leftButton =
      CircularButton(onPressed: () => Get.back(result: onLeft()), child: left);

  Widget rightButton = CircularButton(
      onPressed: () => Get.back(result: onRight()), child: right);

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
      titlePadding: EdgeInsets.only(
          top: 2 * Size.verticalBig,
          right: Size.horizontal,
          left: Size.horizontal),
      contentPadding:
          Padding.zero, //EdgeInsets.symmetric(horizontal: Size.horizontal),
      actionsPadding: Padding.zero,
      buttonPadding: Padding.zero,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.disabled),
          borderRadius: borderRadiusCircular),
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
      actions: [
        leftButton,
        Container(
            padding: EdgeInsets.symmetric(vertical: 2 * Size.verticalBig),
            width: Size.horizontalBig),
        rightButton
      ]);

  // show the dialog
  return await Get.dialog(alert,
      barrierColor: Colors.background.withOpacity(.9));
}
