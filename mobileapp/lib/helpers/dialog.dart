import 'package:flutter/material.dart' hide Colors, Padding;
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
    bool shouldShowConfirm = true,
    String confirmImageTitle}) async {
  // colors
  final Color backgroundColor = Colors.background;

  final buttonPressedHandler = () {
    Get.back();

    if (onPressed != null) onPressed();
  };

  // set up the button
  final button = confirm ??
      Button(
          isCircular: true,
          icon: confirmImageTitle ?? Icons.check,
          padding: Padding.tiny,
          onPressed: buttonPressedHandler);

  // set up the AlertDialog
  final alert = AlertDialog(
      //elevation: 5,
      insetPadding: Padding.content,
      titlePadding: EdgeInsets.only(
          top: Size.verticalBig, right: Size.horizontal, left: Size.horizontal),
      contentPadding:
          EdgeInsets.zero, //EdgeInsets.symmetric(horizontal: Size.horizontal),
      actionsPadding: shouldShowConfirm
          ? EdgeInsets.symmetric(vertical: Size.vertical)
          : EdgeInsets.only(bottom: Size.verticalBig),
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
        if (shouldShowConfirm) button,
      ]);

  // show the dialog
  return await Get.dialog(alert,
      barrierColor: Colors.background.withOpacity(.9));
}
