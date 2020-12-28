import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/controllers/chat_form_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
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

  _timerHandler() async {
    final result = await Get.toNamed(timerRoute, arguments: controller.card);
    print('ChatScreen._timerHandler result: $result');
    if (result == null)
      return;

    controller.post(result);
  }

  // builders

  Widget _buildMessage(ChatMessage message, {bool shouldShowCorner = false}) =>
      ((
                  {EdgeInsets margin,
                  Color color,
                  AlignmentGeometry alignment,
                  double cornerWidth,
                  double cornerHeight}) =>
              Column(children: [
                if (!message.imageUrl.isNullOrEmpty) ...[
                  ClipRRect(
                      borderRadius: borderRadiusCircular,
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: .5 * Size.screenHeight),
                          child: Image(title: message.imageUrl))),
                  VerticalMediumSpace()
                ],
                Stack(clipBehavior: Clip.none, children: [
                  Align(
                      alignment: alignment,
                      child: Container(
                          padding: Padding.small,
                          margin: margin,
                          decoration: BoxDecoration(
                              color: color, borderRadius: borderRadiusCircular),
                          child: TextAnimated(message.text,
                              duration: message.isUser
                                  ? Duration.zero
                                  : chatTyperAnimationDuration))),
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
                ])
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

  Widget _buildControlButton(
          {ChatAnswerData answer, Function(ChatAnswerData, bool) onSelected}) =>
      Column(children: [
        if (!answer.imageUrl.isNullOrEmpty) ...[
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: .75 *
                      Size.screenHeight /
                      controller.questionAnswers.length),
              child: Image(title: answer.imageUrl)),
          VerticalMediumSpace(),
        ],
        Button(
            padding: Padding.chatButton,
            title: answer.text,
            titleStyle: TextStyle.buttonChat,
            isSwitch: onSelected != null,
            onSelected: onSelected != null
                ? (isSelected) => onSelected(answer, isSelected)
                : null,
            onPressed: onSelected == null
                ? () => controller.post(answer.value)
                : null),
      ]);

  Widget _buildInput() => _buildControlContainer(
      child: GetBuilder<ChatFormController>(
          init: ChatFormController(
              validator: getChatInputValidator(controller.questionRegexp)),
          builder: (controller) => Stack(children: [
                Obx(() => Input<ChatFormController>(
                    field: 'input',
                    isErrorVisible: false,
                    shouldFocus: true,
                    autovalidateMode: controller.shouldValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    contentPadding: EdgeInsets.only(
                        left: Size.horizontal,
                        right: Size.horizontal * 2 + Size.iconSmall,
                        bottom: Size.verticalTiny))),
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
                                      ? _buildControlButton(answer: answer)
                                      : Nothing())(
                                  controller.getQuestionAnswer(row, column)))
                      ])
                  ]))))(
          rows: Iterable<int>.generate(controller.questionRows),
          columns: Iterable<int>.generate(controller.questionColumns));

  Widget _buildCheckbox() => _buildControlContainer(
      child: Checkbox(
          tag: tag,
          buildControlButton: _buildControlButton,
          rows: controller.questionRows,
          columns: controller.questionColumns));

  Widget _buildTimer() => _buildControlContainer(
      child: Container(
          padding: Padding.content,
          width: Size.screenWidth,
          child: Center(
              child: CircularButton(
                  size: Size.iconBig,
                  background: Colors.transparent,
                  borderColor: Colors.primary,
                  icon: Icons.check,
                  iconSize: Size.iconTiny,
                  onPressed: _timerHandler))));

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
              dispose: (_) => Get.delete<Controller>(tag: tag),
              builder: (_) => Column(children: [
                    Expanded(
                        child: Stack(children: [
                      ListView.builder(
                          shrinkWrap: true,
                          controller: controller.scroll,
                          padding: Padding.content,
                          itemCount: max(controller.messages.length * 2 - 1, 0),
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
                    if (controller.messageQueue.isNullOrEmpty)
                      if (controller.questionType == ChatQuestionType.INPUT)
                        _buildInput()
                      else if (controller.questionType ==
                          ChatQuestionType.RADIO)
                        _buildRadio()
                      else if (controller.questionType ==
                          ChatQuestionType.CHECKBOX)
                        _buildCheckbox()
                      else if (controller.questionType ==
                          ChatQuestionType.TIMER)
                        _buildTimer()
                  ]))
          : LoadingPage()));
}

class Checkbox extends GetWidget<ChatController> {
  final String tag;
  final Iterable rows;
  final Iterable columns;
  final Function(
      {ChatAnswerData answer,
      Function(ChatAnswerData, bool) onSelected}) buildControlButton;
  Checkbox(
      {@required this.tag,
      @required this.buildControlButton,
      int rows,
      int columns})
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
                      ? buildControlButton(
                          answer: answer, onSelected: _answerHandler)
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
