import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/controllers/chat_form_controller.dart';
import 'package:hls/controllers/chat_navigation_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/screens/_form_screen.dart' hide Button;
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

import '../components/generic.dart';

class ChatScreen<Controller extends ChatController>
    extends GetView<Controller> {
  final ChatDialogType type;
  final bool shouldRestart;

  ChatScreen({Key key, @required this.type, this.shouldRestart = false})
      : super(key: key);

  @override
  String get tag => type.title;

  // handlers

  _logoutHandler() => AuthService.i.logout();

  _skipHandler() => Get.find<ChatNavigationController>().skip();

  _timerHandler() async {
    final result = await Get.toNamed(timerRoute, arguments: controller.card);
    print('ChatScreen._timerHandler result: $result');
    if (result == null) return;

    controller.post(result);
  }

  // builders

  Widget _buildControlContainer(
          {Widget child, bool shouldShowLoading = true}) =>
      Container(
          //height: Size.chatBar,
          //padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
          decoration: BoxDecoration(color: Colors.background, boxShadow: [
            BoxShadow(
                color: panelShadowColor,
                blurRadius: panelShadowBlurRadius,
                spreadRadius: panelShadowSpreadRadius,
                offset: -panelShadowOffset)
          ]),
          child: shouldShowLoading && controller.isAwaiting
              ? Container(
                  width: Size.screenWidth,
                  padding: Padding.content,
                  child: Center(child: Loading()))
              : child);

  Widget _buildControlButton(
          {@required bool isSelected,
          ChatAnswerData answer,
          Function(ChatAnswerData, bool) onSelected,
          bool isFirst = false,
          bool isLast = false}) =>
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!answer.imageUrl.isNullOrEmpty) ...[
              ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: .5 * Size.screenHeight),
                  child: ChatImage(title: answer.imageUrl)),
              VerticalMediumSpace(),
            ],
            Container(
                margin: isFirst
                    ? EdgeInsets.only(
                        right: Size.horizontalSmall / 2,
                        bottom: Size.verticalSmall)
                    : isLast
                        ? EdgeInsets.only(
                            left: Size.horizontalSmall / 2,
                            bottom: Size.verticalSmall)
                        : EdgeInsets.only(
                            left: Size.horizontalSmall / 2,
                            right: Size.horizontalSmall / 2,
                            bottom: Size.verticalSmall),
                child: Button(
                    padding: Padding.chatButton,
                    title: answer.text,
                    titleStyle: TextStyle.buttonChat,
                    isSwitch: onSelected != null,
                    isSelected: isSelected,
                    onSelected: onSelected != null
                        ? (isSelected) => onSelected(answer, isSelected)
                        : null,
                    onPressed: onSelected == null
                        ? () => controller.post(answer.value)
                        : null))
          ]);

  Widget _buildInput() => _buildControlContainer(
      shouldShowLoading: false,
      child: GetBuilder<ChatFormController>(
          init: ChatFormController(controller: controller),
          builder: (formController) {
            formController.validator =
                getChatInputValidator(controller.questionRegexp);
            formController.reloadConfig();

            return Stack(children: [
              Obx(() => Input<ChatFormController>(
                  field: 'input',
                  //validator: getChatInputValidator(controller.questionRegexp),
                  isErrorVisible: false,
                  //shouldFocus: true,
                  autovalidateMode: formController.shouldValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  contentPadding: EdgeInsets.only(
                      left: Size.horizontal,
                      right: Size.horizontal * 2 + Size.iconSmall,
                      bottom: Size.verticalTiny))),
              Obx(() => formController.isValidIgnoreDirty
                  ? Positioned(
                      right: 0,
                      height: Size.chatBar,
                      width: Size.horizontal * 2 + Size.iconSmall,
                      child: controller.isAwaiting
                          ? Center(
                              child: SizedBox(
                                  width: Size.iconSmall,
                                  height: Size.iconSmall,
                                  child: Loading()))
                          : Clickable(
                              child: Icon(FontAwesomeIcons.paperPlane,
                                  color: Colors.primary, size: Size.iconSmall),
                              onPressed: formController.submitHandler))
                  : Nothing())
            ]);
          }));

  Widget _buildRadio() =>
      (({Iterable rows, Iterable columns}) => _buildControlContainer(
              child: Container(
                  padding: EdgeInsets.only(
                      left: Size.horizontal,
                      top: Size.vertical,
                      bottom: Size.vertical - Size.verticalSmall,
                      right: Size.horizontal),
                  child: Table(children: [
                    for (final row in rows)
                      TableRow(children: [
                        for (final column in columns)
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.bottom,
                              // padding: EdgeInsets.only(
                              //     bottom: Size.verticalSmall,
                              //     right: Size.horizontalSmall),
                              child: ((ChatAnswerData answer) => answer != null
                                      ? _buildControlButton(
                                          isSelected: false,
                                          answer: answer,
                                          isFirst: column == columns.first,
                                          isLast: column == columns.last)
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
      //shouldShowLoading: false,
      child: Container(
          padding: Padding.content,
          width: Size.screenWidth,
          child: Center(
              child: CircularButton(
                  size: Size.iconBig,
                  background: Colors.transparent,
                  borderColor: Colors.primary,
                  icon: FontAwesomeIcons.clock,
                  iconSize: Size.iconTiny,
                  onPressed: _timerHandler))));

  Widget _buildSubmit() => _buildControlContainer(
      child: Container(
          padding: Padding.content,
          width: Size.screenWidth,
          child: Center(
              child: CircularButton(
                  size: Size.iconBig,
                  background: Colors.transparent,
                  borderColor: Colors.primary,
                  icon: FontAwesomeIcons.check,
                  iconSize: Size.iconTiny,
                  onPressed: Get.find<ChatNavigationController>().next))));

  @override
  Widget build(_) => GetX<Controller>(
      tag: tag,
      //global: false,
      init: ChatController(type: type, shouldRestart: shouldRestart)
          as Controller,
      builder: (currentController) {
        // print('ChatScreen.build '
        //     '\n\tis registered: ${Get.isRegistered<Controller>(tag: tag)} '
        //     '\n\ttype: $type '
        //     '\n\tcurrent type: ${currentController.type}');

        final isRegistered = Get.isRegistered<Controller>(tag: tag);
        if (!isRegistered) {
          // Get bug need to recreate controller
          if (currentController.type != type)
            Get.put(ChatController(type: type) as Controller, tag: tag);
          // Get bug controller unregistered too early
          else
            return LoadingScreen();
        }

        // print('ChatScreen.build'
        //     '\n\tSHOULD SHOW BLOCK: ${controller.messageQueue.firstWhere((x) => !x.isUser, orElse: () => null) == null && !controller.isTyping && !controller.isReadingPause}'
        //     '\n\tqueue: ${controller.messageQueue}'
        //     '\n\tmessage queue null or empty: ${controller.messageQueue.firstWhere((x) => !x.isUser, orElse: () => null) == null}'
        //     '\n\tnot typing: ${!controller.isTyping}'
        //     '\n\tnot reading: ${!controller.isReadingPause}');

        return Screen(
            shouldResize: true,
            padding: Padding.zero,
            leading: Obx(() => !Get.find<ChatNavigationController>().canGoBack
                ? Clickable(
                    child: Icon(FontAwesomeIcons.signOutAlt, size: Size.icon),
                    onPressed: _logoutHandler)
                : Clickable(
                    child: Icon(FontAwesomeIcons.arrowLeft, size: Size.icon),
                    onPressed: _skipHandler)),
            trailing: Obx(() => !Get.find<ChatNavigationController>().canGoBack
                ? Clickable(
                    child: Icon(FontAwesomeIcons.arrowRight, size: Size.icon),
                    onPressed: _skipHandler)
                : Nothing()),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: Size.screenWidth -
                          Size.horizontal * 4 -
                          Size.iconSmall * 2,
                      child: AutoSizeText(type.title,
                          style: TextStyle.title, maxLines: 1)),
                  Visibility(
                      visible: controller.isTyping,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(chatTypingText, style: TextStyle.secondary),
                            HorizontalTinySpace(),
                            SpinKitThreeBounce(
                                color: Colors.disabled, size: Size.fontTiny)
                          ]))
                ]),
            child: GestureDetector(
                onTap: () {
                  final currentFocus = FocusScope.of(Get.context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    currentFocus.focusedChild.unfocus();
                  }
                },
                child: controller.isInit
                    ? Column(children: [
                        Expanded(
                            child: Stack(children: [
                          ListView.builder(
                              shrinkWrap: true,
                              controller: controller.scrollController,
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

                                return ChatMessage(message,
                                    shouldShowCorner: shouldShowCorner);
                              }),
                          controller.checkboxHasSelection &&
                                  !controller.isAwaiting
                              ? Positioned(
                                  bottom: Size.vertical,
                                  right: Size.horizontal,
                                  child: CircularButton(
                                      size: Size.iconBig,
                                      icon: FontAwesomeIcons.check,
                                      iconSize: Size.iconSmall,
                                      onPressed: () => controller
                                          .post(controller.checkboxSelection)))
                              : Nothing()
                        ])),
                        if (controller.messageQueue.isNullOrEmpty &&
                            !controller.isTyping &&
                            !controller.isReadingPause)
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
                          else
                            _buildSubmit()
                        else if (controller.isAwaiting)
                          _buildControlContainer(child: Nothing())
                      ])
                    : LoadingPage()));
      });
}

class ChatMessage extends StatelessWidget {
  final ChatMessageData message;
  final bool shouldShowCorner;

  ChatMessage(this.message, {this.shouldShowCorner});

  @override
  Widget build(BuildContext context) => ((
              {EdgeInsets margin,
              Color color,
              AlignmentGeometry alignment,
              double cornerWidth,
              double cornerHeight}) {


    print("IMAGE_URL!!!_  " + (message.imageUrl.isNullOrEmpty ? "" : message.imageUrl));

    return  Column(children: [
      Stack(clipBehavior: Clip.none, children: [
        Align(
            alignment: alignment,
            child: Container(
                padding: Padding.small,
                margin: margin,
                decoration: BoxDecoration(
                    color: message.color ?? color,
                    borderRadius: borderRadiusCircular),
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
                      color: message.color ?? color))),
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
      ]),
      if (!message.imageUrl.isNullOrEmpty) ...[
        VerticalMediumSpace(),
        ClipRRect(
            borderRadius: borderRadiusCircular,
            child: ConstrainedBox(
                constraints:
                BoxConstraints(maxHeight: .5 * Size.screenHeight),
                child: ChatImage(title: message.imageUrl)))
      ]
    ]);
  }

  )
    (
      margin: message.isUser
          ? EdgeInsets.only(left: Size.horizontalMedium)
          : EdgeInsets.only(right: Size.horizontalMedium),
      color: message.isUser ? Colors.primary : Colors.disabled,
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      cornerWidth: Size.horizontalSmall * 2,
      cornerHeight: Size.verticalSmall);
}

class Checkbox<Controller extends ChatController> extends GetView<Controller> {
  final String tag;
  final Iterable rows;
  final Iterable columns;
  final Function(
      {ChatAnswerData answer,
      bool isSelected,
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
      padding: EdgeInsets.only(
          left: Size.horizontal,
          top: Size.vertical,
          bottom: Size.vertical - Size.verticalSmall,
          right: Size.horizontal - Size.horizontalSmall),
      child: Table(children: [
        for (final row in rows)
          TableRow(children: [
            for (final column in columns)
              Container(
                  padding: EdgeInsets.only(
                      bottom: Size.verticalSmall, right: Size.horizontalSmall),
                  child: ((ChatAnswerData answer) => answer != null
                      ? buildControlButton(
                          isSelected: controller.isCheckboxSelected(answer),
                          answer: answer,
                          onSelected: _answerHandler)
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

class ChatImage extends StatelessWidget {
  final title;

  ChatImage({@required this.title});

  @override
  Widget build(BuildContext context) =>
      //Clickable(
      //onPressed: () => Get.to(ImageScreen(imageUrl: url), transition: Transition.downToUp),
      //child:
      Hero(tag: title, child: Image(title: title, fit: BoxFit.fitWidth));
}
