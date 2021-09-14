// import 'dart:io';
//
// // import 'package:firebase_analytics/firebase_analytics.dart';
// // import 'package:firebase_analytics/observer.dart';
// import 'package:get/get.dart';
// import 'package:hls/helpers/null_awareness.dart';
// import 'package:hls/services/_service.dart';
// import 'package:pretty_json/pretty_json.dart';
//
// class AnalyticsService extends Service {
//   static AnalyticsService get i => Get.find<AnalyticsService>();
//
//   // FirebaseAnalytics _analytics;
//   // FirebaseAnalyticsObserver _observer;
//
//   @override
//   Future init() async {
//     // _analytics = FirebaseAnalytics();
//     // _observer = FirebaseAnalyticsObserver(analytics: _analytics);
//
//     open();
//   }
//
//   // FirebaseAnalyticsObserver get observer => _observer;
//
//   Future<void> log(String title, {Map<String, dynamic> parameters}) =>
//       Platform.isWindows || Platform.isMacOS
//           ? null
//           : _analytics.logEvent(name: title, parameters: parameters);
//   Future<void> open() =>
//       // Platform.isWindows || Platform.isMacOS ? null : _analytics.logAppOpen();
//   Future<void> login() =>
//       // Platform.isWindows || Platform.isMacOS ? null : _analytics.logLogin();
//   Future<void> user(String userId) => Platform.isWindows || Platform.isMacOS
//       ? null
//       : _analytics.setUserId(userId);
//
//   Future<void> queryStart(String node, {Map<String, dynamic> parameters}) =>
//       log('graphqlQueryStart', parameters: {
//         'node': node,
//         if (!parameters.isNullOrEmpty) 'parameters': prettyJson(parameters)
//       });
//   Future<void> queryEnd(String node, {Map<String, dynamic> data}) =>
//       log('graphqlQueryEnd', parameters: {
//         'node': node,
//         if (!data.isNullOrEmpty) 'data': prettyJson(data)
//       });
//   Future<void> mutationStart(String node, {Map<String, dynamic> parameters}) =>
//       log('graphqlMutationStart', parameters: {
//         'node': node,
//         if (!parameters.isNullOrEmpty) 'parameters': prettyJson(parameters)
//       });
//   Future<void> mutationEnd(String node, {Map<String, dynamic> data}) =>
//       log('graphqlMutationEnd', parameters: {
//         'node': node,
//         if (!data.isNullOrEmpty) 'data': prettyJson(data)
//       });
// }
