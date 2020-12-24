import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/chat_card_model.dart';

class ChatController extends Controller {
  // fields

  final List<ChatCardData> _cards = [];
  final List<ChatMessage> _messages = [];
  final ChatDialogType type;
  ChatController({this.type});

  int currentDialogId;

  // getters

  List<ChatMessage> get messages => _messages;
  ChatCardData get card => _cards.last;
  String get questionKey => card.key;
  String get questionRegexp => card.addons?.regexp;
  ChatQuestionType get questionType => card.questionType;
  Map<String, ChatAnswerData> get questionAnswers => card.answers;
  Map<String, ChatQuestionData> get questionResults => card.results;
  int get questionColumns => card.style?.columns ?? defaultColumns;
  int get questionRows =>
      card.style?.rows ?? (card.answers.length ~/ questionColumns).ceil();

  ChatAnswerData getQuestionAnswer(int row, int column) {
    final index = row * questionRows + column;
    final key = questionAnswers.keys.toList(growable: false)[index];
    return questionAnswers[key]..value = key;
  }

  ChatQuestionData getQuestionResult(value) => questionResults?.get(value);

  // get x implementation

  @override
  void onInit() async {
    // check active chat bot dialog
    print('ChatController.onInit '
        '\n\ttype: $type');

    final isDialogActive = false; //!profile.activeDialogId.isNullOrZero;
    final dialogId = null;

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

  // methods

  addCard(ChatCardData card) {
    _cards.add(card);

    if (!card.questions.isNullOrEmpty)
      for (final question in card.questions)
        addMessage(ChatMessage.fromQuestion(question), shouldUpdate: false);

    update();
  }

  addMessage(ChatMessage message, {bool shouldUpdate = true}) {
    _messages.add(message);

    if (shouldUpdate) update();
  }

  Future<bool> post(value) async {
    print('ChatController.post $value');
    addMessage(ChatMessage(text: value.toString()));
    final questionResult = getQuestionResult(value);
    if (questionResult != null)
      addMessage(ChatMessage.fromQuestion(questionResult));

    final result = await mutation(chatBotDialogContinueMutation, parameters: {
      'dialogId': currentDialogId,
      'key': questionKey,
      'values': value is List ? value : [value]
    });

    // process status
    final status = ChatDialogStatus.fromValue(
        result.get(['chatBotDialogContinue', 'dialogStatus']));
    if (status != null) {
      switch (status) {
        case ChatDialogStatus.PENDING:

          /// TODO: skip all chats
          return true;
        case ChatDialogStatus.FINISHED:

          /// TODO: move to next controller sequence
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
