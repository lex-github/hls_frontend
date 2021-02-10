import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/chat_navigation_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/services/auth_service.dart';

class ChatController extends Controller {
  // fields

  final _scrollController = ScrollController();
  final List<ChatCardData> _cards = [];
  final _messages = <ChatMessage>[].obs;
  final _checkboxSelection = [];
  final _checkboxHasSelection = false.obs;
  final ChatDialogType type;
  final _isTyping = false.obs;
  ChatController({this.type});

  int currentDialogId;

  // getters

  ScrollController get scrollController => _scrollController;
  List<ChatMessage> get messages => _messages;
  ChatCardData get card => _cards.lastOrNull;
  String get questionKey => card?.key;
  String get questionRegexp => card?.addons?.regexp;
  bool get isTyping => _isTyping.value;
  ChatQuestionType get questionType => card?.questionType;
  Map<String, ChatAnswerData> get questionAnswers => card?.answers;
  Map<String, List<ChatQuestionData>> get questionResults => card?.results;
  int get questionColumns => (card?.answers?.length ?? 1) == 1
      ? 1
      : card?.style?.columns ?? defaultColumns;
  int get questionRows =>
      card?.style?.rows ??
      ((card?.answers?.length ?? 0) / questionColumns).ceil();
  List get checkboxSelection => _checkboxSelection;
  bool get checkboxHasSelection => _checkboxHasSelection.value;

  ChatAnswerData getQuestionAnswer(int row, int column) {
    if (questionAnswers.isNullOrEmpty) return null;

    final index = row * questionRows + column;
    final keys = questionAnswers.keys.toList(growable: false);
    final key = keys.get(index);
    return key == null ? null : (questionAnswers[key]..value = key);
  }

  List<ChatQuestionData> getQuestionResults(value) => value is List
      ? [for (final x in value) ...questionResults?.get(x)]
      : questionResults?.get(value);

  // get x implementation

  @override
  void onInit() async {
    // check active chat bot dialog
    final activeDialog = AuthService.i.profile.activeDialog;
    final isDialogActive =
        false && activeDialog != null && type == activeDialog.type;
    final dialogId = activeDialog?.id;

    // print('ChatController.onInit '
    //   '\n\ttype: $type'
    //   '\n\tdialogs: ${AuthService.i.profile.dialogs}'
    //   '\n\tactive: $activeDialog');

    // start dialog of type or continue mysterious previous dialog
    final mutation = !isDialogActive
        ? chatBotDialogStartMutation
        : chatBotDialogResumeMutation;
    final parameters =
        !isDialogActive ? {'name': type.value} : {'dialogId': dialogId};
    final result = await this.mutation(mutation, parameters: parameters);
    final key = !isDialogActive ? 'chatBotDialogStart' : 'chatBotDialogResume';

    // add card and process messages
    final data = result.get([key, 'nextCard']);
    if (data != null) {
      addCard(ChatCardData.fromJson(data));
      currentDialogId =
          result.get([key, 'dialogId'], convert: toInt) ?? dialogId;
    }

    super.onInit();
  }

  @override
  onClose() {
    _scrollController.dispose();

    super.onClose();
  }

  // methods

  scroll() =>
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: defaultAnimationDuration);

  bool isCheckboxSelected(ChatAnswerData data) =>
      _checkboxSelection.contains(data.value);

  checkboxAdd(value) {
    if (!_checkboxSelection.contains(value)) _checkboxSelection.add(value);

    _checkboxHasSelection.value = !_checkboxSelection.isNullOrEmpty;
  }

  checkboxRemove(value) {
    if (_checkboxSelection.contains(value)) _checkboxSelection.remove(value);

    _checkboxHasSelection.value = !_checkboxSelection.isNullOrEmpty;
  }

  addCard(ChatCardData card) {
    //print('ChatController.addCard type: ${card.questionType}');

    _cards.add(card);

    if (!card.questions.isNullOrEmpty)
      for (final question in card.questions)
        addMessage(ChatMessage.fromQuestion(question));

    //update();
  }

  bool _isMessageQueueRunning = false;
  final List<ChatMessage> messageQueue = [];
  addMessage(ChatMessage message) async {
    if (message == null || message.text.isNullOrEmpty) return;
    if (_messages.lastOrNull?.text == message.text) return;

    messageQueue.insert(0, message);

    if (!_isMessageQueueRunning) {
      _isMessageQueueRunning = true;
      _isTyping.value = true;

      // might be a bit bold
      while (!_scrollController.hasClients) {
        await Future.delayed(defaultAnimationDuration);
      }

      // consequential message display
      while (!messageQueue.isNullOrEmpty) {
        final message = messageQueue.removeLast();

        // delay before display
        if (!message.isUser) {
          // WidgetsBinding.instance.addPostFrameCallback((_) => Timer.periodic(
          //   chatTyperAnimationDuration,
          //     (timer) => timer.tick < message.text.length && _scroll.hasClients
          //     ? _scroll.animateTo(_scroll.position.maxScrollExtent,
          //     curve: Curves.easeOut, duration: defaultAnimationDuration)
          //     : timer.cancel()));

          await Future.delayed(
              chatTyperAnimationDuration * (message.text?.length ?? 0));
        }

        // message display
        //print('ChatController.addMessage ${message.imageUrl}');
        _messages.add(message);
        //update();

        // scroll to chat end
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollController.hasClients ? scroll() : null);
      }

      _isTyping.value = false;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _isMessageQueueRunning = false);
    }
  }

  Future<bool> post(value) async {
    //print('ChatController.post value: $value');

    if (isAwaiting) return false;

    // display user input
    switch (questionType) {
      case ChatQuestionType.INPUT:
        addMessage(ChatMessage(text: value.toString()));
        break;
      case ChatQuestionType.RADIO:
        addMessage(ChatMessage(text: questionAnswers[value].text));
        break;
      case ChatQuestionType.CHECKBOX:
        addMessage(ChatMessage(
            text: (value as List)
                .map((x) => questionAnswers[x].text)
                .join(', ')));
        break;
      case ChatQuestionType.TIMER:
        addMessage(ChatMessage(text: value.toString()));
        break;
    }

    // display results
    final questionResults = getQuestionResults(value);
    if (!questionResults.isNullOrEmpty)
      for (final questionResult in questionResults)
        addMessage(ChatMessage.fromQuestion(questionResult));

    //return true;

    if (currentDialogId.isNullOrZero || questionKey.isNullOrZero)
      Get.find<ChatNavigationController>().next();

    final result = await mutation(chatBotDialogContinueMutation, parameters: {
      'dialogId': currentDialogId,
      'key': questionKey,
      'values': value is List ? value : [value]
    });

    // cleaning previous state
    _checkboxSelection.removeWhere((_) => true);
    _checkboxHasSelection.value = false;

    // check dialog results
    final dialogResult = result.get(['chatBotDialogContinue', 'dialogResult']);
    //print('ChatController.post result: $value');
    if (dialogResult != null && dialogResult is List) {
      _cards.removeWhere((_) => true);

      for (final data in dialogResult)
        addMessage(ChatMessage.fromQuestion(ChatQuestionData.fromJson(data)));

      return true;
    }

    // ensure message queue is empty
    while (_isMessageQueueRunning)
      await Future.delayed(defaultAnimationDuration);

    // process status
    final status = ChatDialogStatus.fromValue(
        result.get(['chatBotDialogContinue', 'dialogStatus']));
    //print('ChatController.post status: $status');
    if (status != null) {
      switch (status) {
        case ChatDialogStatus.PENDING:
          Get.find<ChatNavigationController>().skip();
          return true;
        case ChatDialogStatus.FINISHED:
          Get.find<ChatNavigationController>().next();
          return true;
      }
    }

    // add card and process messages
    final data = result.get(['chatBotDialogContinue', 'nextCard']);
    if (data == null) return false;

    addCard(ChatCardData.fromJson(data));

    return true;
  }
}

class ChatMessage {
  final Color color;
  final String text;
  final String imageUrl;
  final bool isUser;

  ChatMessage({this.color, this.text, this.imageUrl, this.isUser = true});
  ChatMessage.fromQuestion(ChatQuestionData question)
      : color = question.color,
        imageUrl = question.imageUrl,
        text = question.text,
        isUser = false;
}
