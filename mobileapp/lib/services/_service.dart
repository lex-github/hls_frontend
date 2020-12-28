import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';

class Service extends GetxController {
  Future init() async => this;

  final _isAwaiting = false.obs;
  bool get isAwaiting => _isAwaiting.value;
  set isAwaiting(bool value) => WidgetsBinding.instance
      .addPostFrameCallback((_) => _isAwaiting.value = value);
}
