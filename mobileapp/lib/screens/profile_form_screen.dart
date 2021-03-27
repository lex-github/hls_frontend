import 'package:flutter/material.dart' hide Colors, Image, Padding;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart' hide Button;
import 'package:hls/components/common_dialog.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/profile_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/screens/profile_screen.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/theme/styles.dart';

class ProfileFormScreen<T extends ProfileFormController> extends FormScreen<T>
    with CommonDialog {
  static final _key = GlobalKey(debugLabel: 'profileForm');

  //final _picker = ImagePicker();

  bool get tapOutsideToDismiss => false;
  bool get displayArrows => true;

  @override
  List<String> get nodes => super
      .nodes
      .where((field) => field != 'birthDate')
      .toList(growable: false);

  // handlers

  _avatarHandler() async {
    return showConfirm(title: developmentText);

    // final source = await showSwitch<ImageSource>(
    //     left: Icon(Icons.camera),
    //     right: Icon(Icons.list),
    //     onLeft: () => ImageSource.camera,
    //     onRight: () => ImageSource.gallery);
    // if (source == null) return;
    //
    // final pickedFile = await _picker.getImage(source: source);
    //
    // if (pickedFile != null) controller.onChanged('avatar', pickedFile);
  }

  // builders

  @override
  Widget buildForm(_) => Obx(() {
        final isKeyboardVisible = controller.isKeyboardVisible;
        final pickedFile = null;//controller.getValue<PickedFile>('avatar');
        final avatarUrl = pickedFile?.path ?? AuthService.i.profile.avatarUrl;

        return Column(
            mainAxisAlignment: isKeyboardVisible
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (!isKeyboardVisible)
                Stack(children: [
                  ProfileHeader(
                      avatarUrl: avatarUrl,
                      isAvatarLocal: !avatarUrl.isNullOrEmpty,
                      showDefaultAvatar: false),
                  Positioned(
                      bottom: Size.verticalTiny,
                      left: Size.screenWidth / 2 -
                          Size.avatar / 2 +
                          Size.horizontalTiny / 2,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(Size.avatar / 2),
                          child: Clickable(
                              onPressed: _avatarHandler,
                              child: Container(
                                  color: Colors.background.withOpacity(.45),
                                  width: Size.avatar,
                                  height: Size.avatar,
                                  child: Center(
                                      child: Image(
                                          title: 'icons/camera',
                                          size: Size.iconHuge))))))
                ])
              else
                VerticalBigSpace(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
                  child: Column(key: _key, children: [
                    VerticalMediumSpace(),
                    Input<T>(field: 'name'),
                    VerticalMediumSpace(),
                    DatePicker<T>(field: 'birthDate'),
                    VerticalMediumSpace(),
                    Input<T>(field: 'height'),
                    VerticalMediumSpace(),
                    Input<T>(field: 'weight'),
                    // VerticalMediumSpace(),
                    // Input<T>(field: 'email'),
                    VerticalBigSpace()
                  ]))
            ]);
      });

  @override
  Widget buildScreen({Widget child}) => Screen(
      fab: Button<T>(),
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
      child: child);

  @override
  T get initController => ProfileFormController() as T;
}
