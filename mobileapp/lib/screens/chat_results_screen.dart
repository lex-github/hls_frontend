import 'dart:math';
import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/controllers/chat_form_controller.dart';
import 'package:hls/controllers/chat_navigation_controller.dart';
import 'package:hls/controllers/chat_results_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/helpers/validation.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/screens/_form_screen.dart' hide Button;
import 'package:hls/screens/chat_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

import '../components/generic.dart';

class ChatResultsScreen<Controller extends ChatResultsController>
    extends GetView<Controller> {
  // builders

  @override
  Widget build(_) => GetX<Controller>(
      init: ChatResultsController() as Controller,
      builder: (currentController) => Screen(
          padding: Padding.zero,
          title: testingResultsProfileLabel,
          child: controller.isInit
              ? ListView.builder(
                  shrinkWrap: true,
                  controller: controller.scrollController,
                  padding: Padding.content,
                  itemCount: max(controller.messages.length * 2 - 1, 0),
                  itemBuilder: (_, i) {
                    if (i.isOdd) {
                      final index = (i + 1) ~/ 2;
                      final message = controller.messages[index];
                      final prevMessage = controller.messages[index - 1];
                      return message.isUser == prevMessage.isUser
                          ? VerticalMediumSpace()
                          : VerticalSpace();
                    }
                    final index = i ~/ 2;
                    final message = controller.messages[index];
                    final prevMessage =
                        index == 0 ? null : controller.messages[index - 1];
                    final shouldShowCorner = prevMessage == null ||
                        prevMessage.isUser != message.isUser;

                    return ChatMessage(message,
                        shouldShowCorner: shouldShowCorner);
                  })
              : LoadingPage()));
}
