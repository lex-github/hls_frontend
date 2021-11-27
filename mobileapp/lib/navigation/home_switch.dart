import 'package:flutter/material.dart' hide Colors, Padding, Size;
import 'package:get/get.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/chat_navigation_controller.dart';
import 'package:hls/controllers/health_controller.dart';
import 'package:hls/navigation/tabbar_screen.dart';

class HomeSwitch extends StatelessWidget {
  // builders

  @override
  Widget build(_) => MixinBuilder<ChatNavigationController>(
      init: ChatNavigationController(),
      builder: (chatNavigation) => Stack(children: [
            TabbarScreen(),
            AnimatedSwitcher(
                duration: navigationTransitionDuration,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation =
                      Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                          .animate(animation);
                  final outAnimation =
                      Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                          .animate(animation);

                  return child.key == ValueKey(chatNavigation.index)
                      ? chatNavigation.isLast
                          ? child
                          : SlideTransition(position: inAnimation, child: child)
                      : !chatNavigation.isLast
                          ? child
                          : SlideTransition(
                              position: outAnimation, child: child);
                  // print(
                  //     'AnimatedSwitcher ${child.key} ${currentIndex.value} = $widget');
                  // return widget;
                },
                child: chatNavigation.screen)
            // if (false && chatNavigation.canGoForward)
            //   Positioned(
            //       right: Size.horizontal,
            //       bottom: Size.vertical,
            //       child: CircularButton(
            //           icon: Icons.arrow_forward_ios,
            //           iconSize: Size.iconSmall,
            //           onPressed: chatNavigation.next))
          ]));
}
