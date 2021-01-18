import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/navigation/home_switch.dart';
import 'package:hls/screens/auth_form_screen.dart';
import 'package:hls/screens/food_category_screen.dart';
import 'package:hls/screens/food_screen.dart';
import 'package:hls/screens/otp_request_form_screen.dart';
import 'package:hls/screens/otp_verify_form_screen.dart';
import 'package:hls/screens/reset_form_screen.dart';
import 'package:hls/screens/timer_screen.dart';
import 'package:hls/screens/welcome_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/services/settings_service.dart';

class Router {
  static final initial =
      SettingsService.i.shouldShowWelcome ? welcomeRoute : otpRequestRoute;
  static final home = () => HomeSwitch();
  static final routes = [
    GetPage(
        popGesture: false,
        name: authRoute,
        page: () => WillPopScope(
            onWillPop: () async => AuthService.isAuth, child: AuthFormScreen()),
        transition: Transition.downToUp,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        popGesture: false,
        name: otpRequestRoute,
        page: () => WillPopScope(
            onWillPop: () async => AuthService.isAuth,
            child: OtpRequestFormScreen()),
        transition: Transition.downToUp,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: otpVerifyRoute,
        page: () => OtpVerifyFormScreen(),
        transition: Transition.downToUp,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: resetRoute,
        page: () => ResetFormScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: timerRoute,
        page: () => TimerScreen(),
        transition: Transition.downToUp,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: welcomeRoute,
        page: () => WelcomeScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: homeRoute,
        page: home,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: foodCategoryRoute,
        page: () => FoodCategoryScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
      name: foodRoute,
      page: () => FoodScreen(),
      transitionDuration: navigationTransitionDuration),
  ];
}
