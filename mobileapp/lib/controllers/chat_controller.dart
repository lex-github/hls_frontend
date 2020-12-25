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

  final _scroll = ScrollController();
  final List<ChatCardData> _cards = [];
  final List<ChatMessage> _messages = [];
  final _checkboxSelection = [];
  final _checkboxHasSelection = false.obs;
  final ChatDialogType type;
  ChatController({this.type});

  int currentDialogId;

  // getters

  ScrollController get scroll => _scroll;
  List<ChatMessage> get messages => _messages.reversed.toList(growable: false);
  ChatCardData get card => _cards.lastOrNull;
  String get questionKey => card?.key;
  String get questionRegexp => card?.addons?.regexp;
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
    final index = row * questionRows + column;
    final keys = questionAnswers.keys.toList(growable: false);
    final key = keys.get(index);
    return key == null ? null : (questionAnswers[key]
      ..value = key);
  }

  List<ChatQuestionData> getQuestionResults(value) =>
      questionResults?.get(value);

  // get x implementation

  @override
  void onInit() async {
    // check active chat bot dialog
    print('ChatController.onInit '
        '\n\ttype: $type'
        '\n\tdialogs: ${AuthService.i.profile.dialogs}');

    final activeDialog = AuthService.i.profile.activeDialog;
    final isDialogActive = false; // activeDialog != null;
    final dialogId = activeDialog?.id;

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
    super.onClose();

    _scroll.dispose();
  }

  // methods

  checkboxAdd(value) {
    if (!_checkboxSelection.contains(value)) _checkboxSelection.add(value);

    _checkboxHasSelection.value = !_checkboxSelection.isNullOrEmpty;
  }

  checkboxRemove(value) {
    if (_checkboxSelection.contains(value)) _checkboxSelection.remove(value);

    _checkboxHasSelection.value = !_checkboxSelection.isNullOrEmpty;
  }

  addCard(ChatCardData card) {
    print('ChatController.addCard type: ${card.questionType}');

    _cards.add(card);

    if (!card.questions.isNullOrEmpty)
      for (final question in card.questions)
        addMessage(ChatMessage.fromQuestion(question), shouldUpdate: false);

    update();
  }

  addMessage(ChatMessage message, {bool shouldUpdate = true}) {
    _messages.add(message);

    if (shouldUpdate) update();

    /// TODO: animation is not working
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll.animateTo(.0,
        curve: Curves.easeOut, duration: defaultAnimationDuration));
  }

  Future<bool> post(value) async {
    print('ChatController.post $value');

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
        break;
    }

    // display results
    final questionResults = getQuestionResults(value);
    if (!questionResults.isNullOrEmpty)
      for (final questionResult in questionResults)
        addMessage(ChatMessage.fromQuestion(questionResult),
            shouldUpdate: questionResult == questionResults.last);

    final result = await mutation(chatBotDialogContinueMutation, parameters: {
      'dialogId': currentDialogId,
      'key': questionKey,
      'values': value is List ? value : [value]
    });

    // cleaning previous state
    _checkboxSelection.removeWhere((_) => true);
    _checkboxHasSelection.value = false;

    // process status
    final status = ChatDialogStatus.fromValue(
        result.get(['chatBotDialogContinue', 'dialogStatus']));
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
  final String text;
  final bool isUser;

  ChatMessage({this.text, this.isUser = true});
  ChatMessage.fromQuestion(ChatQuestionData question)
      : text = question.text,
        isUser = false;
}
