import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/helpers/strings.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class AppDrawer extends StatelessWidget {
  Widget _buildItem(String title, String destination) => ListTile(
      contentPadding: Padding.content,
      dense: true,
      title: TextPrimary(title),
      onTap: () => Get.offNamed(destination));

  // builders

  _buildHeader() {
    final profile = Get.find<AuthService>().profile;

    return profile == null
        ? Nothing()
        : Row(children: [
            if (!profile.avatarUri.isNullOrEmpty) ...[
              ButtonOuter(
                  child: Image(
                      title: '$siteUrl${trimLeading('/', profile.avatarUri)}',
                      fit: BoxFit.cover),
                  size: Size.iconHuge),
              HLSpace()
            ],
            TextPrimary(profile.name, color: Colors.light)
          ]);
  }

  @override
  Widget build(context) => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
            padding: Padding.content,
            child: _buildHeader(),
            decoration: BoxDecoration(color: Colors.primary)),
        //_buildItem,
        Divider(),
        ListTile(
            contentPadding: Padding.content,
            dense: true,
            title: TextPrimary(drawerLogoutLabel, color: Colors.failure),
            onTap: Get.find<AuthService>().logout)
      ]));
}
