import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/services/auth_service.dart';

class Controller extends GetxController {
  // initialisation
  final _isInit = false.obs;
  bool get isInit => _isInit.value;
  set isInit(bool value) => _isInit.value = value;

  @override
  @mustCallSuper
  void onInit() {
    isInit = true;

    super.onInit();
  }

  bool get isAwaiting => AuthService.i.isAwaiting;
  GraphQLError get error => AuthService.i.error;
  String get message => AuthService.i.message;

  Future<Map<String, dynamic>> query(String node,
          {Map<String, dynamic> parameters}) =>
      AuthService.i.query(node, parameters: parameters);

  Future<Map<String, dynamic>> mutation(String node,
          {Map<String, dynamic> parameters}) =>
      AuthService.i.mutation(node, parameters: parameters);
}

extension GraphQLErrorExtension on GraphQLError {
  int get code => extensions.get('status');
  String get status => extensions.get('exception');
}
