import 'package:hls/constants/api.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  Future<void> init() async {
    // Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setAppId(oneSignalAppId);
    // OneSignal.shared.init('084ae09d-dcac-4be5-94c1-b544c2224f56', iOSSettings: {
    //   OSiOSSettings.autoPrompt: true,
    //   OSiOSSettings.inAppLaunchUrl: false
    // });

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print('PushNotificationsManager.init accepted: $accepted');
    });

    // OneSignal.shared
    //     .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      print(
          'PushNotificationsManager.init NOTIFICATION RECEIVED ${event.notification}');

      //_processNotification(result);
    });

    OneSignal.shared.setNotificationOpenedHandler((result) {
      print(
          'PushNotificationsManager.init NOTIFICATION OPENED ${result.notification}');

      _processNotification(result.notification);
    });

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    //await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  Future<void> setUserId(int id) async {
    await OneSignal.shared.setExternalUserId('$id');
  }

  _processNotification(OSNotification notification) {
    //print('PushNotificationsManager._processNotification $notification');
  }
}
