import 'package:flutter/material.dart' hide Padding;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ChatScreen extends GetWidget {
  final DialogType type;
  ChatScreen({Key key, @required this.type}) : super(key: key);

  // handlers

  _logoutHandler() => AuthService.i.logout();

  // builders

  @override
  Widget build(_) => Screen(
    padding: Padding.zero,
    leading: Clickable(
      child: Icon(Icons.logout, size: Size.iconSmall),
      onPressed: _logoutHandler),
    title: type.title,
    child: Nothing());
}
