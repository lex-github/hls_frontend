import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/food_category_controller.dart';
import 'package:hls/models/post_model.dart';
import 'package:hls/theme/styles.dart';

class StoryScreen extends GetView<FoodCategoryController> {
  final List<StoryData> stories;

  StoryScreen({this.stories});

  // builders

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
                  child: Icon(Icons.arrow_back, size: Size.icon))),
          onPressed: Get.back),
      child: DefaultTabController(
          length: stories.length,
          child: Stack(children: [
            TabBarView(children: [
              for (final story in stories)
                Image(title: story.imageUrl, fit: BoxFit.cover)
            ]),
            Container(
                color: Colors.background.withOpacity(.1),
                height: 1.5 * Size.verticalSmall,
                padding: EdgeInsets.symmetric(horizontal: Padding.content.left),
                child: TabBar(
                    labelPadding: Padding.zero,
                    indicatorColor: Colors.light,
                    indicatorWeight: 2 * Size.border,
                    indicatorPadding: EdgeInsets.symmetric(
                        horizontal: .4 * Size.horizontalTiny),
                    tabs: [
                      for (final _ in stories)
                        Stack(clipBehavior: Clip.none, children: [
                          Positioned(
                              bottom: -2 * Size.border,
                              left: .4 * Size.horizontalTiny,
                              right: .4 * Size.horizontalTiny,
                              child: Container(
                                  color: Colors.light.withOpacity(.5),
                                  height: 2 * Size.border))
                        ])
                    ]))
          ])));
}
