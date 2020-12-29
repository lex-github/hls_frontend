import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hls/services/auth_service.dart';

class Controller extends GetxController {
  // initialisation
  final _isInit = false.obs;
  bool get isInit => _isInit.value;
  set isInit(bool value) => _isInit.value = value;

  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
    isInit = true;
  }

  bool get isAwaiting => AuthService.isAuth;

  Future<Map<String, dynamic>> query(String node,
          {Map<String, dynamic> parameters}) =>
      AuthService.i.query(node, parameters: parameters);

  Future<Map<String, dynamic>> mutation(String node,
          {Map<String, dynamic> parameters}) =>
      AuthService.i.mutation(node, parameters: parameters);
}
