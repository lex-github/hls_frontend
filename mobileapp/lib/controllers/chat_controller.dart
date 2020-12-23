import 'package:hls/constants/api.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/services/auth_service.dart';

class ChatController extends Controller {
  // fields

  final List<ChatCardData> _cards = [];
  final List<ChatMessage> _messages = [];
  final ChatDialogType type;
  ChatController({this.type});

  // getters

  List<ChatMessage> get messages => _messages;
  String get regexp => _cards.last.addons.regexp;

  // get x implementation

  @override
  void onInit() async {
    // check active chat bot dialog
    final profile = AuthService.i.profile;
    print('ChatController.onInit '
        '\n\ttype: $type'
        '\n\tactiveDialogId: ${profile.activeDialogId}');

    // start dialog of type or continue mysterious previous dialog
    final mutation = profile.activeDialogId.isNullOrZero
        ? chatBotDialogStartMutation
        : chatBotDialogResumeMutation;
    final parameters = profile.activeDialogId.isNullOrZero
        ? {'name': type.value}
        : {'dialogId': profile.activeDialogId};
    final result = await this.mutation(mutation, parameters: parameters);
    final key = profile.activeDialogId.isNullOrZero
        ? 'chatBotDialogStart'
        : 'chatBotDialogResume';

    // add card and process messages
    print('ChatController.onInit $result');
    final data = result.get([key, 'nextCard']);
    if (data != null) addCard(ChatCardData.fromJson(data));

    super.onInit();
  }

  // methods

  addCard(ChatCardData card) {
    _cards.add(card);

    for (final question in card.questions)
      _messages.add(ChatMessage.fromQuestion(question));

    update();
  }

  Future<bool> post(value) {
    
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({this.text, this.isUser = false});
  ChatMessage.fromQuestion(ChatQuestionData question)
      : text = question.text,
        isUser = false;
}
