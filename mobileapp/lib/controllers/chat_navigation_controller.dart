import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/chat_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/chat_card_model.dart';
import 'package:hls/screens/chat_screen.dart';
import 'package:hls/services/auth_service.dart';

class ChatNavigationController extends Controller {
  final _screens = <Widget>[];
  final _index = 0.obs;

  int get index => _index.value;
  int get length => _screens.length;
  bool get isLast => index == length - 1;
  bool get canGoForward => index < _screens.length - 1;
  Widget get screen {
    // unsure getter is reactive
    index;

    return _screens.isNullOrEmpty ? Nothing() : _screens[index];
  }

  // get x implementation

  @override
  void onInit() async {
    super.onInit();

    // hide or show auth form
    ever<bool>(AuthService.i.authenticationState, (isAuthenticated) async {
      final isAuthenticated = AuthService.isAuth;
      print('ChatNavigationController.onInit authenticated: $isAuthenticated');
      if (!isAuthenticated) {
        // init screens
        _screens.removeWhere((_) => true);
        // remove controllers
        // for (final type in ChatDialogType.values) {
        //   print('DELETE $type');
        //   Get.delete<ChatController>(tag: type.title);
        // }
        // make sure we start from first
        _index.value = 0;

        update();
        return;
      }

      // check which dialogs are not completed
      final chatDialogsNotCompleted =
          AuthService.i.profile.dialogTypesToComplete;
      // debugPrint(
      //     'ChatNavigationController.onInit completed: ${AuthService.i.profile.completedDialogs}');
      // print(
      //     'ChatNavigationController.onInit types to complete: $chatDialogsNotCompleted');
      if (chatDialogsNotCompleted.isNullOrEmpty) return;

      // create sequence for completing dialogs
      for (int i = 0; i < chatDialogsNotCompleted.length; i++)
        _screens.add(
            ChatScreen(key: ValueKey(i), type: chatDialogsNotCompleted[i]));
      _screens.add(Nothing(key: ValueKey(chatDialogsNotCompleted.length)));

      await Future.delayed(Duration.zero);

      update();
    });
  }

  // methods

  void next() => _index.value += 1;
  void skip() => _index.value = _screens.length - 1;
}
