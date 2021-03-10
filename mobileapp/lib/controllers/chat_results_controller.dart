import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/chat_card_model.dart';

class ChatResultsController extends Controller {
  final scrollController = ScrollController();

  // fields

  final messages = <ChatMessageData>[].obs;

  ChatResultsController();

  // get x implementation

  @override
  void onInit() async {
    // start dialog of type or continue mysterious previous dialog
    final result = await this.query(chatHistoryQuery);
    print('ChatResultsController.onInit $result');

    // get chat history
    final data = result.get(['currentUser', 'chatBotDialogs']);
    if (data != null) {
      // finished dialogs list
      final allFinishedDialogs = List<ChatDialogStatusData>.from(
              data.map((x) => ChatDialogStatusData.fromJson(x)))
          .where((x) =>
              //x.type != ChatDialogType.WELCOME &&
              x.status == ChatDialogStatus.FINISHED)
          .toList(growable: false);

      // highest ids for each chat type
      final dialogs = <ChatDialogStatusData>[];
      for (final type in ChatDialogType.values) {
        //if (type == ChatDialogType.WELCOME) continue;

        ChatDialogStatusData result;
        for (final dialog in allFinishedDialogs)
          if (type == dialog.type) if (result == null || dialog.id > result.id)
            result = dialog;

        if (result != null) dialogs.add(result);
      }

      // converting dialogs to messages
      //print('ChatResultsController.onInit $dialogs');
      final messages = <ChatMessageData>[];
      for (final dialog in dialogs) {
        dialog.history.sort((a, b) => a.order.compareTo(b.order));

        for (final history in dialog.history) {
          for (final question in history.question)
            messages.add(ChatMessageData.fromQuestion(question));
          for (final answer in history.answer)
            messages.add(ChatMessageData(text: answer.text));
        }
      }
      this.messages.addAll(messages);
    }

    super.onInit();
  }

  @override
  onClose() {
    scrollController.dispose();

    super.onClose();
  }

  // methods

  scroll() =>
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: defaultAnimationDuration);

  // addCard(ChatCardData card) {
  //   //print('ChatController.addCard type: ${card.questionType}');
  //
  //   _cards.add(card);
  //
  //   if (!card.questions.isNullOrEmpty)
  //     for (final question in card.questions)
  //       addMessage(ChatMessageData.fromQuestion(question));
  //
  //   //update();
  // }
}
