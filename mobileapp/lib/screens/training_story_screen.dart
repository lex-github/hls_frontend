import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/theme/styles.dart';

class TrainingStoryScreen extends StatelessWidget {
  // builders

  @override
  Widget build(_) => Screen(
      shouldHaveAppBar: false,
      // leadingLeft: Size.horizontal - (Size.iconBig - Size.iconSmall) / 2,
      // leadingTop: Size.vertical + Size.top, // - Size.iconBig / 2,
      // leading: Clickable(
      //     borderRadius: Size.iconBig / 2,
      //     child: Container(
      //         width: Size.iconBig,
      //         height: Size.iconBig,
      //         child: Center(
      //             child: Icon(Icons.arrow_back, size: Size.icon))),
      //     onPressed: Get.back),
      leading: Nothing(),
      trailingRight: Size.horizontal - (Size.iconBig - Size.iconSmall) / 2,
      trailingTop: Size.vertical + Size.top,
      trailing: Clickable(
          borderRadius: Size.iconBig / 2,
          child: Container(
              width: Size.iconBig,
              height: Size.iconBig,
              child: Center(
                  child: Transform.rotate(
                      angle: pi / 4,
                      child: Icon(FontAwesomeIcons.plusCircle,
                          size: .8 * Size.icon)))),
          onPressed: Get.back),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        TextPrimaryHint(trainingStoryText),
        //VerticalSpace(),
        Image(
            title: 'training-story',
            width: Size.screenWidth - Size.horizontal * 2)
      ]));
}
