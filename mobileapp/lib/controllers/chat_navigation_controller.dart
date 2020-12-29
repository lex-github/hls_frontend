import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/screens/chat_screen.dart';
import 'package:hls/services/auth_service.dart';

class ChatNavigationController extends Controller {
  final _screens = <Widget>[];
  final _index = 0.obs;

  int get index => _index.value;
  int get length => _screens.length;
  bool get isLast => index == length - 1;
  bool get canGoForward => index < _screens.length - 1;
  Widget get screen => _screens.isNullOrEmpty ? Nothing() : _screens[index];

  // get x implementation

  @override
  void onInit() async {
    super.onInit();

    // hide or show auth form
    ever<bool>(AuthService.i.authenticationState, (isAuthenticated) {
      final isAuthenticated = AuthService.isAuth;
      if (!isAuthenticated) return;

      // init screens
      _screens.removeWhere((_) => true);

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

      update();
    });
  }

  // methods

  void next() => _index.value += 1;
  void skip() => _index.value = _screens.length - 1;
}
