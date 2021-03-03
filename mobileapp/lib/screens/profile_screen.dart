import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/screens/hub_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ProfileScreen extends StatelessWidget {
  UserData get profile => AuthService.i.profile;

  // handlers

  _editHandler() => Get.toNamed(profileFormRoute);

  // builders

  Widget _buildParameter({String value, String title}) => Column(children: [
        TextPrimaryHint(value, size: Size.font),
        TextPrimary(title, size: .9 * Size.fontTiny)
      ]);

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldHaveAppBar: false,
      leadingLeft: Size.horizontal - (Size.iconBig - Size.iconSmall) / 2,
      leadingTop: Size.vertical + Size.top, // - Size.iconBig / 2,
      leading: Clickable(
          borderRadius: Size.iconBig / 2,
          child: Container(
              width: Size.iconBig,
              height: Size.iconBig,
              child: Center(
                  child: Hero(
                      tag: 'icon-back',
                      child:
                          Icon(Icons.arrow_back_ios, size: Size.iconSmall)))),
          onPressed: Get.back),
      trailing: Clickable(
          borderRadius: Size.iconBig / 2,
          child: Container(
              width: Size.iconBig,
              height: Size.iconBig,
              child: Center(child: Icon(Icons.edit, size: .9 * Size.icon))),
          onPressed: _editHandler),
      child: Obx(() => SingleChildScrollView(
              child: Column(children: [
            ProfileHeader(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                child: Column(children: [
                  if (!profile.name.isNullOrEmpty) ...[
                    VerticalTinySpace(),
                    TextPrimaryTitle(profile.name, size: 1.2 * Size.fontBig)
                  ],
                  VerticalSpace(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildParameter(
                            value: '${profile.age}', title: ageProfileText),
                        _buildParameter(
                            value: '${profile.height}',
                            title: heightProfileText),
                        _buildParameter(
                            value: '${profile.weight}',
                            title: weightProfileText)
                      ]),
                  VerticalSpace(),
                  Button(
                      padding:
                          EdgeInsets.symmetric(vertical: Size.verticalMedium),
                      background: Colors.primary,
                      title: testingResultsProfileLabel),
                  VerticalMediumSpace(),
                  Button(
                      padding:
                          EdgeInsets.symmetric(vertical: Size.verticalMedium),
                      title: restartTestProfileLabel),
                  VerticalBigSpace(),
                  TextSecondary(progressProfileText, size: Size.fontTiny),
                  VerticalSpace(),
                  StatusBlock(),
                  VerticalSpace()
                ]))
          ]))));
}

class ProfileHeader extends StatelessWidget {
  final String avatarTitle;
  final bool showDefaultAvatar;
  final bool isAvatarLocal;

  ProfileHeader(
      {this.avatarTitle,
      this.showDefaultAvatar = true,
      this.isAvatarLocal = false});

  @override
  Widget build(BuildContext context) => SizedBox(
      height: Size.image + Size.avatar / 2,
      child: Stack(children: [
        Hero(
            tag: 'sidebar-background',
            child: Image(
                title: 'sidebar-background.png',
                width: Size.screenWidth,
                height: Size.image,
                fit: BoxFit.cover)),
        Positioned(
            bottom: 0,
            left: Size.screenWidth / 2 -
                Size.avatar / 2 -
                Size.horizontalTiny / 2,
            child: Hero(
                tag: 'avatar',
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Size.avatar / 2 + Size.horizontalTiny / 2),
                    child: Container(
                        color: Colors.background,
                        padding: Padding.tiny,
                        child: avatarTitle.isNullOrEmpty
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Size.avatar / 2),
                                child: Container(
                                    color: Colors.light.withOpacity(.25),
                                    width: Size.avatar,
                                    height: Size.avatar,
                                    child: showDefaultAvatar
                                        ? Icon(Icons.person,
                                            color: Colors.light,
                                            size: .65 * Size.avatar)
                                        : Nothing()))
                            : Avatar(
                                imageUri: avatarTitle,
                                isLink: !isAvatarLocal,
                                isAsset: isAvatarLocal,
                                size: Size.avatar)))))
      ]));
}
