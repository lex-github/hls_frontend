import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, Image, TextStyle;
import 'package:get/get.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/navigation/drawer.dart';
import 'package:hls/navigation/tabbar.dart';
import 'package:hls/screens/_development_screen.dart';
import 'package:hls/screens/hub_screen.dart';
import 'package:hls/screens/stats_screen.dart';
import 'package:hls/theme/styles.dart';

final tabbarScaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'tabbarKey');

class TabbarScreen extends StatefulWidget {
  final int index;
  TabbarScreen({Key key, this.index = 0}) : super(key: key);

  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen>
    with TickerProviderStateMixin {
  int get index => widget.index;
  TabbarController get controller => Get.put(
      TabbarController(index: index, length: _tabbarItems.length, vsync: this));

  final List<Widget> _tabbarBodies = <Widget>[
    HubScreen(),
    //NutritionScreen(),
    StatsScreen(),
    //DevelopmentScreen(shouldShowDrawer: true), //ScheduleScreen()
  ];

  final List<AnimatedBottomNavigationBarItem> _tabbarItems = [
    AnimatedBottomNavigationBarItem(title: 'icons/dots'),
    //AnimatedBottomNavigationBarItem(title: 'icons/cutlery'),
    AnimatedBottomNavigationBarItem(title: 'icons/list'),
    //AnimatedBottomNavigationBarItem(title: 'icons/barbell'),
  ];

  Widget _buildBar({bool isSubmenuVisible = false}) => Tabbar(
      isSubmenuVisible: isSubmenuVisible,
      backgroundColor: Colors.background,
      color: Colors.primary,
      items: _tabbarItems);

  Widget _buildTabbar() => TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: controller.tabController,
      children: _tabbarBodies);

  Widget _buildBody() => controller.isBarVisible
      ? Scaffold(
          key: tabbarScaffoldKey,
          drawer: AppDrawer(),
          drawerScrimColor: Colors.shadow.withOpacity(.4),
          primary: false,
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: false,
          body: _buildTabbar(),
          bottomNavigationBar: _buildBar())
      : _buildTabbar();

  @override
  Widget build(BuildContext context) => Obx(() => controller.isSubmenuVisible
      ? Stack(children: [
          ColorFiltered(
              colorFilter:
                  ColorFilter.mode(Colors.transparent, BlendMode.saturation),
              child: _buildBody()),
          GestureDetector(
              onTap: () => controller.toggleSubmenu(),
              child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: submenuBlurStrength,
                      sigmaY:
                          submenuBlurStrength * submenuBlurVerticalCoefficient),
                  child: Container(
                      color: Colors.shadow.withOpacity(.4),
                      width: Size.screenWidth,
                      height: Size.screenHeight,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _buildBar(
                                isSubmenuVisible: controller.isSubmenuVisible)
                          ]))))
        ])
      : _buildBody());
}
