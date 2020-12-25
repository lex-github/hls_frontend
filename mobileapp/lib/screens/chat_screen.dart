import 'dart:math';

import 'package:flutter/material.dart' hide Colors, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/controllers/chat_form_controller.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/screens/_form_screen.dart' hide Button;
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ChatScreen<Controller extends ChatController>
    extends GetWidget<Controller> {
  final ChatDialogType type;
  ChatScreen({Key key, @required this.type}) : super(key: key) {
    Get.lazyPut(() => ChatController(type: type) as Controller, tag: tag);
  }

  @override
  String get tag => type.title;

  // handlers

  _logoutHandler() => AuthService.i.logout();

  // builders

  Widget _buildMessage(ChatMessage message, {bool shouldShowCorner = false}) =>
      ((
                  {EdgeInsets margin,
                  Color color,
                  AlignmentGeometry alignment,
                  double cornerWidth,
                  double cornerHeight}) =>
              Stack(clipBehavior: Clip.none, children: [
                Align(
                    alignment: alignment,
                    child: Container(
                        padding: Padding.small,
                        margin: margin,
                        decoration: BoxDecoration(
                            color: color, borderRadius: borderRadiusCircular),
                        child: TextPrimaryHint(message.text))),
                if (shouldShowCorner && !message.isUser)
                  Positioned(
                      top: 0,
                      left: -Size.horizontalSmall,
                      child: ClipPath(
                          clipper: ChatCornerClipper(),
                          child: Container(
                              width: cornerWidth,
                              height: cornerHeight,
                              color: color))),
                if (shouldShowCorner && message.isUser)
                  Positioned(
                      top: 0,
                      right: -Size.horizontalSmall,
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: ClipPath(
                              clipper: ChatCornerClipper(),
                              child: Container(
                                  width: cornerWidth,
                                  height: cornerHeight,
                                  color: color))))
              ]))(
          margin: message.isUser
              ? EdgeInsets.only(left: Size.horizontalMedium)
              : EdgeInsets.only(right: Size.horizontalMedium),
          color: message.isUser ? Colors.primary : Colors.disabled,
          alignment:
              message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          cornerWidth: Size.horizontalSmall * 2,
          cornerHeight: Size.verticalSmall);

  Widget _buildControlContainer({Widget child}) => Container(
      //height: Size.chatBar,
      //padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
      decoration: BoxDecoration(color: Colors.background, boxShadow: [
        BoxShadow(
            color: panelShadowColor,
            blurRadius: panelShadowBlurRadius,
            offset:
                Offset(panelShadowHorizontalOffset, -panelShadowVerticalOffset))
      ]),
      child: child);

  Widget _buildInput() => _buildControlContainer(
      child: GetBuilder(
          init: ChatFormController(
              validator: getChatInputValidator(controller.questionRegexp)),
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

  Widget _buildRadio() =>
      (({Iterable rows, Iterable columns}) => _buildControlContainer(
              child: Container(
                  padding: EdgeInsets.only(
                      top: Size.vertical, left: Size.horizontal),
                  child: Table(children: [
                    for (final row in rows)
                      TableRow(children: [
                        for (final column in columns)
                          Container(
                              padding: EdgeInsets.only(
                                  bottom: row == rows.last
                                      ? Size.vertical
                                      : Size.verticalSmall,
                                  right: column == columns.last
                                      ? Size.horizontal
                                      : Size.horizontalSmall),
                              child: ((ChatAnswerData answer) => answer != null
                                      ? Button(
                                          padding: Padding.chatButton,
                                          title: answer.text,
                                          titleStyle: TextStyle.chatButton,
                                          onPressed: () =>
                                              controller.post(answer.value))
                                      : Nothing())(
                                  controller.getQuestionAnswer(row, column)))
                      ])
                  ]))))(
          rows: Iterable<int>.generate(controller.questionRows),
          columns: Iterable<int>.generate(controller.questionColumns));

  Widget _buildCheckbox() => _buildControlContainer(
      child: Checkbox(
          tag: tag,
          rows: controller.questionRows,
          columns: controller.questionColumns));

  @override
  Widget build(_) {
    print(controller.questionType);
    return Screen(
        shouldResize: true,
        padding: Padding.zero,
        leading: Clickable(
            child: Icon(Icons.logout, size: Size.iconSmall),
            onPressed: _logoutHandler),
        title: type.title,
        child: Obx(() => controller.isInit
            ? GetBuilder<Controller>(
                init: controller,
                dispose: (_) => Get.delete<Controller>(tag: tag),
                builder: (_) => Column(children: [
                      Expanded(
                          child: Stack(children: [
                        ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            controller: controller.scroll,
                            padding: Padding.content,
                            itemCount:
                                max(controller.messages.length * 2 - 1, 0),
                            itemBuilder: (_, i) {
                              if (i.isOdd) {
                                final index = (i + 1) ~/ 2;
                                final message = controller.messages[index];
                                final prevMessage =
                                    controller.messages[index - 1];
                                return message.isUser == prevMessage.isUser
                                    ? VerticalMediumSpace()
                                    : VerticalSpace();
                              }

                              final index = i ~/ 2;
                              final message = controller.messages[index];
                              final prevMessage = index == 0
                                  ? null
                                  : controller.messages[index - 1];
                              final shouldShowCorner = prevMessage == null ||
                                  prevMessage.isUser != message.isUser;

                              return _buildMessage(message,
                                  shouldShowCorner: shouldShowCorner);
                            }),
                        Obx(() => controller.checkboxHasSelection
                            ? Positioned(
                                bottom: Size.vertical,
                                right: Size.horizontal,
                                child: CircularButton(
                                    size: Size.iconBig,
                                    icon: Icons.check,
                                    iconSize: Size.iconSmall,
                                    onPressed: () => controller
                                        .post(controller.checkboxSelection)))
                            : Nothing())
                      ])),
                      if (controller.questionType == ChatQuestionType.INPUT)
                        _buildInput()
                      else if (controller.questionType ==
                          ChatQuestionType.RADIO)
                        _buildRadio()
                      else if (controller.questionType ==
                          ChatQuestionType.CHECKBOX)
                        _buildCheckbox()
                    ]))
            : LoadingPage()));
  }
}

class Checkbox extends GetWidget<ChatController> {
  final String tag;
  final Iterable rows;
  final Iterable columns;
  Checkbox({@required this.tag, int rows, int columns})
      : rows = Iterable<int>.generate(rows),
        columns = Iterable<int>.generate(columns);

  // handlers

  _answerHandler(ChatAnswerData data, bool isSelected) {
    final value = data.value;
    if (isSelected)
      controller.checkboxAdd(value);
    else
      controller.checkboxRemove(value);
  }

  // builders

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.only(top: Size.vertical, left: Size.horizontal),
      child: Table(children: [
        for (final row in rows)
          TableRow(children: [
            for (final column in columns)
              Container(
                  padding: EdgeInsets.only(
                      bottom:
                          row == rows.last ? Size.vertical : Size.verticalSmall,
                      right: column == columns.last
                          ? Size.horizontal
                          : Size.horizontalSmall),
                  child: ((ChatAnswerData answer) => answer != null
                      ? Button(
                          padding: Padding.chatButton,
                          isSwitch: true,
                          title: answer.text,
                          titleStyle: TextStyle.chatButton,
                          onSelected: (isSelected) =>
                              _answerHandler(answer, isSelected))
                      : Nothing())(controller.getQuestionAnswer(row, column)))
          ])
      ]));
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
