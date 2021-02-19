import 'package:flutter/material.dart' hide Image, Router;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/navigation/router.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/services/settings_service.dart';
import 'package:hls/theme/theme_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => initServices().then((_) => runApp(HLS()));

Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(null, null);
  await Get.put(SettingsService()).init();
  await Get.put(HttpService()).init();
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
              cache: InMemoryCache(),
              link: HttpLink(uri: apiUri, headers: {
                'Client-Token': apiTokenValue,
                'Content-Type': 'application/json',
                if (!SettingsService.i.token.isNullOrEmpty)
                  'Auth-Token': SettingsService.i.token
              }))),
          child: GetBuilder<AuthService>(
              init: AuthService()..init(),
              builder: (_) => GetMaterialApp(
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
                    home: Router.home()
                  )))));
}
