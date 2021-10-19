import 'dart:io';

import 'package:flutter/material.dart' hide Image, Router;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/notifications.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/navigation/router.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/services/analytics_service.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/services/settings_service.dart';
import 'package:hls/theme/theme_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:window_size/window_size.dart';

void main() => initServices().then((_) => runApp(HLS()));

Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS)
    //DesktopWindow.setWindowSize(Size(desktopWindowWidth, desktopWindowHeight));
    setWindowMaxSize(Size(desktopWindowWidth, desktopWindowHeight));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await initializeDateFormatting('ru_RU', null);

  await Get.put(SettingsService()).init();
  // await Get.put(AnalyticsService()).init();
  await Get.put(HttpService()).init();

  await PushNotificationsManager().init();
}

class HLS extends StatelessWidget {
  @override
  Widget build(context) => RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
          spacing: 0,
          idleText: idleRefreshText,
          releaseText: releaseRefreshText,
          refreshingText: activeRefreshText,
          completeText: completedRefreshText),
      child: Obx(() => GraphQLProvider(
          // rebuild when token changes
          client: ValueNotifier(GraphQLClient(
              link: HttpLink(apiUri, defaultHeaders: {
                apiTokenKey: apiTokenValue,
                'Content-Type': 'application/json',
                if (!SettingsService.i.token.isNullOrEmpty)
                  authTokenKey: SettingsService.i.token
              }),
              cache: GraphQLCache())),
          child: GetBuilder<AuthService>(
              init: AuthService()..init(),
              builder: (_) => GetMaterialApp(
                  // navigatorObservers: [AnalyticsService.i.observer],
                  smartManagement: SmartManagement.onlyBuilder,
                  theme: theme(context),
                  defaultTransition: Transition.rightToLeftWithFade,
                  getPages: Router.routes,
                  // home: SingleChildScrollView(
                  //     child: Column(children: [
                  //   Image(title: 'neck_1.svg'),
                  //   Image(title: 'neck_2.svg')
                  // ])),
                  initialRoute: Router.initial,
                  home: Router.home())))));
}
