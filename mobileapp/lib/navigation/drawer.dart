import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class AppDrawer extends StatelessWidget {
  Widget _buildItem(String title, String destination) => ListTile(
      //contentPadding: Padding.content,
      dense: true,
      title: TextPrimary(title),
      onTap: () => Get.offNamed(destination));

  // builders

  _buildHeader() {
    final profile = AuthService.i.profile;

    return profile == null
        ? Nothing()
        : Row(children: [
            // if (!profile.avatarUri.isNullOrEmpty) ...[
            //   ButtonOuter(
            //       child: Image(
            //           title: '$siteUrl${trimLeading('/', profile.avatarUri)}',
            //           fit: BoxFit.cover),
            //       size: Size.iconHuge),
            //   HLSpace()
            // ],
            // TextPrimary(profile.name, color: Colors.light)
          ]);
  }

  @override
  Widget build(_) => BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: submenuBlurStrength,
          sigmaY: submenuBlurStrength * submenuBlurVerticalCoefficient),
      child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
            padding: Padding.zero,
            margin: Padding.zero,
            child: _buildHeader(),
            decoration: BoxDecoration(color: Colors.primary)),
        //_buildItem,
        //Divider(),
        Clickable(
            splashColor: Colors.shadowLight,
            onPressed: () {
              Get.back();
              Get.find<AuthService>().logout();
            },
            child: Container(
                padding: Padding.content,
                child: Row(children: [
                  Icon(Icons.logout,
                      size: Size.iconSmall, color: Colors.failure),
                  HorizontalSmallSpace(),
                  TextPrimaryHint(drawerLogoutLabel, color: Colors.failure)
                ])))
      ])));
}
