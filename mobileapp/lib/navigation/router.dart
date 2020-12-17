import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/navigation/tabbar_screen.dart';
import 'package:hls/screens/auth_form_screen.dart';
import 'package:hls/screens/reset_form_screen.dart';
import 'package:hls/services/auth_service.dart';

class Router {
  static final initial = authRoute;
  static final home = () => TabbarScreen();
  static final routes = [
    GetPage(
        popGesture: false,
        name: authRoute,
        page: () =>
            WillPopScope(onWillPop: () async => AuthService.isAuth, child: AuthFormScreen()),
        transition: Transition.downToUp
    ),
    GetPage(
      name: resetRoute,
      page: () => ResetFormScreen(),
      //transition: Transition.rightToLeft
    ),
    GetPage(name: homeRoute, page: home),
  ];
}
