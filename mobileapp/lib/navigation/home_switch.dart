import 'package:flutter/material.dart' hide Colors, Padding, Size;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/navigation/tabbar_screen.dart';
import 'package:hls/screens/chat_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class HomeSwitch extends StatelessWidget {
  final currentIndex = 0.obs;
  final _screens = <Widget>[].obs;

  // builders

  Widget _buildScreen(int index) => _screens[index];

  @override
  Widget build(_) => Obx(() {
        // this needs to be invoked
        final isAuthenticated = AuthService.isAuth;
        if (!isAuthenticated)
          return Screen(
              shouldHaveAppBar: false,
              child: Center(child: TextSecondary(errorGenericText)));

        // check which dialogs are not completed
        final chatDialogsNotCompleted =
            AuthService.i.profile.chatDialogsNotCompleted;
        if (chatDialogsNotCompleted.isNullOrEmpty) return TabbarScreen();

        // create sequence for completing dialogs
        final screens = <Widget>[];
        for (int i = 0; i < chatDialogsNotCompleted.length; i++)
          screens.add(
              ChatScreen(key: ValueKey(i), type: chatDialogsNotCompleted[i]));
        screens.add(Nothing(key: ValueKey(chatDialogsNotCompleted.length)));
        _screens.assignAll(screens);

        return Obx(() => Stack(children: [
              TabbarScreen(),
              AnimatedSwitcher(
                  duration: navigationTransitionDuration,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final inAnimation =
                        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                            .animate(animation);
                    final outAnimation =
                        Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                            .animate(animation);

                    return child.key == ValueKey(currentIndex.value)
                        ? currentIndex.value == _screens.length - 1
                            ? child
                            : SlideTransition(
                                position: inAnimation, child: child)
                        : currentIndex.value != _screens.length - 1
                            ? child
                            : SlideTransition(
                                position: outAnimation, child: child);
                    // print(
                    //     'AnimatedSwitcher ${child.key} ${currentIndex.value} = $widget');
                    // return widget;
                  },
                  child: _buildScreen(currentIndex.value)),
              if (false && currentIndex.value < _screens.length - 1)
                Positioned(
                    right: Size.horizontal,
                    bottom: Size.vertical,
                    child: CircularButton(
                        icon: Icons.arrow_forward_ios,
                        iconSize: Size.iconSmall,
                        onPressed: () => currentIndex.value += 1))
            ]));
      });
}
