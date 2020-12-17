import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, Image, TextStyle;
import 'package:get/get.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/navigation/tabbar.dart';
import 'package:hls/screens/_development_screen.dart';
import 'package:hls/theme/styles.dart';

class TabbarScreen extends StatefulWidget {
  final int index;
  TabbarScreen({this.index = 2});

  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen>
    with TickerProviderStateMixin {
  int get index => widget.index;
  TabbarController get controller => Get.find<TabbarController>();

  final List<Widget> _tabbarBodies = <Widget>[
    DevelopmentScreen(),
    DevelopmentScreen(),
    DevelopmentScreen(),
    DevelopmentScreen()
  ];

  final List<AnimatedBottomNavigationBarItem> _tabbarItems = [
    AnimatedBottomNavigationBarItem(title: 'icons/dots'),
    AnimatedBottomNavigationBarItem(title: 'icons/cutlery'),
    AnimatedBottomNavigationBarItem(title: 'icons/list'),
    AnimatedBottomNavigationBarItem(title: 'icons/barbell'),
  ];

  Widget _buildBar({bool isSubmenuVisible = false}) => Tabbar(
      isSubmenuVisible: isSubmenuVisible,
      backgroundColor: Colors.background,
      color: Colors.primary,
      items: _tabbarItems);

  Widget _buildTabbar() =>
      TabBarView(controller: controller.tabController, children: _tabbarBodies);

  Widget _buildBody() => controller.isBarVisible
      ? Scaffold(
          primary: false,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: _buildTabbar(),
          bottomNavigationBar: _buildBar())
      : _buildTabbar();

  @override
  Widget build(BuildContext context) => GetBuilder(
      init: TabbarController(
          index: index, length: _tabbarItems.length, vsync: this),
      builder: (_) => controller.isSubmenuVisible
          ? Stack(children: [
              ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.transparent, BlendMode.saturation),
                  child: _buildBody()),
              GestureDetector(
                  onTap: () => controller.toggleSubmenu(),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: submenuBlurStrength,
                          sigmaY: submenuBlurStrength *
                              submenuBlurVerticalCoefficient),
                      child: Container(
                          color: Colors.shadow.withOpacity(.4),
                          width: Size.screenWidth,
                          height: Size.screenHeight,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                _buildBar(
                                    isSubmenuVisible:
                                        controller.isSubmenuVisible)
                              ]))))
            ])
          : _buildBody());
}
