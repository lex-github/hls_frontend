import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/screens/_development_screen.dart';
import 'package:hls/screens/auth_form_screen.dart';
import 'package:hls/screens/reset_form_screen.dart';

class Router {
  static final initial = authRoute;
  static final home = () => DevelopmentScreen();
  static final routes = [
    GetPage(
        popGesture: false,
        name: authRoute,
        page: () =>
            WillPopScope(onWillPop: () async => false, child: AuthFormScreen()),
        transition: Transition.downToUp),
    GetPage(
      name: resetRoute,
      page: () => ResetFormScreen(),
      //transition: Transition.rightToLeft
    ),
    GetPage(name: homeRoute, page: home),
  ];
}
