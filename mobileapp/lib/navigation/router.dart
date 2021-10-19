import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/navigation/home_switch.dart';
import 'package:hls/screens/article_screen.dart';
import 'package:hls/screens/auth_form_screen.dart';
import 'package:hls/screens/chat_results_screen.dart';
import 'package:hls/screens/exercise_catalog_screen.dart';
import 'package:hls/screens/exercise_category_screen.dart';
import 'package:hls/screens/exercise_realtime_screen.dart';
import 'package:hls/screens/exercise_result_screen.dart';
import 'package:hls/screens/exercise_screen.dart';
import 'package:hls/screens/exercise_video_screen.dart';
import 'package:hls/screens/food_add_screen.dart';
import 'package:hls/screens/food_category_screen.dart';
import 'package:hls/screens/food_filter_screen.dart';
import 'package:hls/screens/food_screen.dart';
import 'package:hls/screens/otp_request_form_screen.dart';
import 'package:hls/screens/otp_verify_form_screen.dart';
import 'package:hls/screens/profile_form_screen.dart';
import 'package:hls/screens/profile_screen.dart';
import 'package:hls/screens/reset_form_screen.dart';
import 'package:hls/screens/schedule_add_screen.dart';
import 'package:hls/screens/stats/stats_tabbar.dart';
import 'package:hls/screens/stats_screen.dart';
import 'package:hls/screens/story_screen.dart';
import 'package:hls/screens/timer_screen.dart';
import 'package:hls/screens/training_story_screen.dart';
import 'package:hls/screens/video_screen.dart';
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
        name: scheduleAddRoute,
        page: () => ScheduleAddScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: foodAddRoute,
        page: () => FoodAddScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: exerciseCatalogRoute,
        page: () => ExerciseCatalogScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: exerciseCategoryRoute,
        page: () => ExerciseCategoryScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: exerciseRoute,
        page: () => ExerciseScreen(item: Get.arguments),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: exerciseRealtimeRoute,
        page: () => ExerciseRealtimeScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: exerciseVideoRoute,
        page: () => ExerciseVideoScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
      name: exerciseResultRoute,
      page: () => ExerciseResultScreen(),
      transitionDuration: navigationTransitionDuration),
    GetPage(
        name: profileRoute,
        page: () => ProfileScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: profileFormRoute,
        page: () => ProfileFormScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: chatResultsRoute,
        page: () => ChatResultsScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: homeRoute,
        page: home,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: articleRoute,
        page: () => ArticleScreen(article: Get.arguments),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: storyRoute,
        page: () => StoryScreen(stories: Get.arguments),
        transition: Transition.downToUp,
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: videoRoute,
        page: () => VideoScreen(url: Get.arguments),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: foodCategoryRoute,
        page: () => FoodCategoryScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: foodRoute,
        page: () => FoodScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: foodFilterRoute,
        page: () => FoodFilterScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: statsRoute,
        page: () => StatsScreen(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: statsTabRoute,
        page: () => StatsTabBar(),
        transitionDuration: navigationTransitionDuration),
    GetPage(
        name: trainingStoryRoute,
        page: () => TrainingStoryScreen(),
        transitionDuration: navigationTransitionDuration,
        transition: Transition.downToUp),
  ];
}
