import 'dart:ui';

import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class AppDrawer extends StatelessWidget {
  // handlers

  _profileHandler() => Get.toNamed(profileRoute);

  _devHandler() => showConfirm(title: developmentText);

  // builders

  _buildHeader() {
    final profile = AuthService.i.profile;

    return profile == null
        ? Nothing()
        : Container(
            decoration: BoxDecoration(
                color: Colors.light,
                image: DecorationImage(
                    image:
                        AssetImage('$assetsDirectory/sidebar-background.png'),
                    fit: BoxFit.cover)),
            height: Size.thumbnail,
            child: Stack(children: [
              Hero(
                  tag: 'sidebar-background',
                  child: Image(
                      title: 'sidebar-background.png',
                      width: Size.screenWidth,
                      height: Size.thumbnail,
                      fit: BoxFit.cover)),
              Clickable(
                  splashColor: Colors.shadowLight,
                  onPressed: _profileHandler,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        HorizontalSpace(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSpace(),
                              VerticalSpace(),
                              Hero(
                                  tag: 'avatar',
                                  child: profile.avatarUrl.isNullOrEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Size.avatar / 2),
                                          child: Container(
                                              color:
                                                  Colors.light.withOpacity(.25),
                                              width: 1.15 * Size.buttonBig,
                                              height: 1.15 * Size.buttonBig,
                                              child: Center(
                                                  child: Icon(
                                                      FontAwesomeIcons.user,
                                                      color: Colors.light,
                                                      size: .65 *
                                                          1.15 *
                                                          Size.buttonBig))))
                                      : Avatar(
                                          imageUrl: profile.avatarUrl,
                                          isLink: false,
                                          size: 1.15 * Size.buttonBig)),
                              Expanded(child: Nothing()),
                              TextPrimaryHint(
                                  profile.email ?? profile.name ?? ''),
                              VerticalSpace()
                            ]),
                        Expanded(child: Nothing()),
                        Container(
                            padding: EdgeInsets.only(
                                right: Size.horizontal, bottom: Size.vertical),
                            child: Hero(
                                tag: 'icon-back',
                                child: Icon(FontAwesomeIcons.arrowRight,
                                    size: Size.icon, color: Colors.light)))
                      ]))
            ]));
  }

  Widget _buildItem(
          {@required dynamic icon,
          @required String title,
          Color color,
          Function onPressed}) =>
      Clickable(
          splashColor: Colors.shadowLight,
          onPressed: onPressed,
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Size.horizontal, vertical: .9 * Size.vertical),
              child: Row(children: [
                if (icon is IconData)
                  Icon(icon, size: .8 * Size.icon, color: color ?? Colors.light)
                else
                  Image(
                      title: icon,
                      size: .7 * Size.icon,
                      color: color ?? Colors.light),
                SizedBox(width: 1.75 * Size.horizontal),
                TextPrimaryHint(title, color: color ?? Colors.light)
              ])));

  @override
  Widget build(_) => BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: submenuBlurStrength,
          sigmaY: submenuBlurStrength * submenuBlurVerticalCoefficient),
      child: Container(
          width: Size.screenWidth - Size.horizontalBig * 2,
          child: Drawer(
              child: Container(
            color: Colors.background,
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              _buildHeader(),
              _buildItem(
                  icon: FontAwesomeIcons.heart,
                  title: drawerFavouriteLabel,
                  onPressed: _devHandler),
              _buildItem(
                  icon: FontAwesomeIcons.chartBar,
                  title: drawerStatisticsLabel,
                  onPressed: () => Get.toNamed(statsRoute)),
              _buildItem(
                  icon: FontAwesomeIcons.camera,
                  title: drawerMeasuresLabel,
                  onPressed: _devHandler),
              _buildItem(
                  icon: FontAwesomeIcons.tools,
                  title: drawerInstrumentsLabel,
                  onPressed: _devHandler),
              _buildItem(
                  icon: FontAwesomeIcons.cog,
                  title: drawerSettingsLabel,
                  onPressed: _devHandler),
              _buildItem(
                  icon: FontAwesomeIcons.signOutAlt,
                  title: drawerLogoutLabel,
                  color: Colors.failure,
                  onPressed: () {
                    Get.back();
                    Get.find<AuthService>().logout();
                  })
            ]),
          ))));
}
