import 'dart:math';

import 'package:flutter/material.dart' hide Colors, Padding, Size;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/controllers/chat_form_controller.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ChatScreen<Controller extends ChatController>
    extends GetWidget<Controller> {
  final ChatDialogType type;
  ChatScreen({Key key, @required this.type}) : super(key: key) {
    Get.put(ChatController(type: type) as Controller);
  }

  // handlers

  _logoutHandler() => AuthService.i.logout();

  // builders

  Widget _buildMessage(ChatMessage message) => ((
              {EdgeInsets margin,
              Color color,
              double cornerWidth,
              double cornerHeight,
              double cornerLeft,
              double cornerRight}) =>
          Stack(clipBehavior: Clip.none, children: [
            Container(
                padding: Padding.small,
                margin: margin,
                decoration: BoxDecoration(
                    color: color, borderRadius: borderRadiusCircular),
                child: TextPrimaryHint(message.text)),
            Positioned(
                top: 0,
                left: cornerLeft,
                right: cornerRight,
                child: ClipPath(
                    clipper: ChatCornerClipper(),
                    child: Container(
                        width: cornerWidth,
                        height: cornerHeight,
                        color: color)))
          ]))(
      margin: message.isUser
          ? EdgeInsets.only(left: Size.horizontalMedium)
          : EdgeInsets.only(right: Size.horizontalMedium),
      color: message.isUser ? Colors.primary : Colors.disabled,
      cornerWidth: Size.horizontalSmall * 2,
      cornerHeight: Size.verticalSmall,
      cornerLeft: message.isUser ? null : -Size.horizontalSmall,
      cornerRight: message.isUser ? -Size.horizontalSmall : null);

  Widget _buildInput() => Container(
      //height: Size.chatBar,
      //padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
      decoration: BoxDecoration(color: Colors.background, boxShadow: [
        BoxShadow(
            color: panelShadowColor,
            blurRadius: panelShadowBlurRadius,
            offset:
                Offset(panelShadowHorizontalOffset, -panelShadowVerticalOffset))
      ]),
      child: GetBuilder(
          init: ChatFormController(
              validator: getChatInputValidator(controller.regexp)),
          builder: (_) => Stack(children: [
                Input<ChatFormController>(
                    field: 'input',
                    isErrorVisible: false,
                    contentPadding: EdgeInsets.only(
                        left: Size.horizontal,
                        right: Size.horizontal * 2 + Size.iconSmall,
                        bottom: Size.verticalTiny)),
                Obx(() => Get.find<ChatFormController>().isValidIgnoreDirty
                    ? Positioned(
                        right: 0,
                        height: Size.chatBar,
                        width: Size.horizontal * 2 + Size.iconSmall,
                        child: Clickable(
                            child: Icon(Icons.send,
                                color: Colors.primary, size: Size.iconSmall),
                            onPressed:
                                Get.find<ChatFormController>().submitHandler))
                    : Nothing())
              ])));

  @override
  Widget build(_) => Screen(
      shouldResize: true,
      padding: Padding.zero,
      leading: Clickable(
          child: Icon(Icons.logout, size: Size.iconSmall),
          onPressed: _logoutHandler),
      title: type.title,
      child: Obx(() => controller.isInit
          ? GetBuilder<Controller>(
              init: controller,
              dispose: (_) => Get.delete<Controller>(),
              builder: (_) => Column(children: [
                    Expanded(
                        child: ListView.builder(
                            padding: Padding.content,
                            itemCount: controller.messages.length,
                            itemBuilder: (_, i) =>
                                _buildMessage(controller.messages[i]))),
                    _buildInput()
                  ]))
          : LoadingPage()));
}

class ChatCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(size) {
    final r = Size.borderRadius / 4;
    final path = Path();
    path.moveTo(r, 0);
    path.arcTo(
        Rect.fromCircle(center: Offset(r, r), radius: r), pi / 2, pi, false);
    path.lineTo(r, r * 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
