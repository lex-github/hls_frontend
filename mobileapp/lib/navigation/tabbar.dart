import 'package:flutter/material.dart' hide Colors, Image, Padding;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/theme/styles.dart';
import 'package:vector_math/vector_math.dart' hide Colors, Matrix4;

class Tabbar extends StatefulWidget {
  final List<AnimatedBottomNavigationBarItem> items;
  final bool isSubmenuVisible;
  final Color backgroundColor;
  final Color color;
  final Duration animationDuration;

  Tabbar(
      {@required this.items,
      this.isSubmenuVisible,
      this.backgroundColor,
      this.color,
      this.animationDuration = defaultAnimationDuration});

  @override
  _State createState() => _State();
}

class _State extends State<Tabbar> with TickerProviderStateMixin {
  AnimationController _tabController;
  AnimationController _submenuController;
  Animation _degOneTranslationAnimation;
  Animation _degTwoTranslationAnimation;
  Animation _degThreeTranslationAnimation;
  Animation _rotationAnimation;
  Animation _centralRotationAnimation;

  final _controller = Get.find<TabbarController>();
  bool isSubmenuVisible;

  @override
  void initState() {
    super.initState();

    _tabController = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
        upperBound: .25,
        lowerBound: .0)
      ..addListener(() => setState(() => null));
    _submenuController = AnimationController(
      vsync: this,
      duration: submenuAnimationDuration,
    )..addListener(() => setState(() => null));
    _degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: .0, end: 1.4), weight: 70.0),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 30.0),
    ]).animate(_submenuController);
    _degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: .0, end: 1.3), weight: 60.0),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 40.0),
    ]).animate(_submenuController);
    _degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: .0, end: 1.2), weight: 50.0),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50.0),
    ]).animate(_submenuController);
    _rotationAnimation = Tween(begin: 180.0, end: .0).animate(
        CurvedAnimation(parent: _submenuController, curve: Curves.easeInOut));
    _centralRotationAnimation = Tween(begin: -180.0, end: 45.0).animate(
        CurvedAnimation(parent: _submenuController, curve: Curves.easeInOut));

    isSubmenuVisible = widget.isSubmenuVisible;
    if (isSubmenuVisible) _submenuController.forward();
  }

  @override
  dispose() {
    _tabController.dispose();
    _submenuController.dispose(); // you need this
    super.dispose();
  }

  // builders

  Widget _buildCentralGroupOffset(
          {double degrees, Widget child, @required Animation animation}) =>
      Transform.translate(
          offset: Offset.fromDirection(-radians(degrees),
              Size.height(animation.value * submenuDistance)),
          child: Transform(
              transform: Matrix4.rotationZ(radians(_rotationAnimation.value))
                ..scale(animation.value),
              alignment: Alignment.center,
              child: child));

  Widget _buildCentralGroup({Widget child}) => isSubmenuVisible
      ? Container(
          height: Size.height(submenuDistance + buttonCentralSize),
          child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            _buildCentralGroupOffset(
                degrees: 120,
                animation: _degOneTranslationAnimation,
                child: CircularButton(
                    imageTitle: 'icons/time',
                    background: Colors.schedule,
                    size: 1.2 * Size.fab,
                    iconSize: .5 * Size.fab,
                    onPressed: (_) => null)),
            _buildCentralGroupOffset(
                degrees: 90,
                animation: _degTwoTranslationAnimation,
                child: CircularButton(
                    imageTitle: 'icons/cutlery',
                    background: Colors.nutrition,
                    size: 1.2 * Size.fab,
                    iconSize: .4 * Size.fab,
                    onPressed: (_) => null)),
            _buildCentralGroupOffset(
                degrees: 60,
                animation: _degThreeTranslationAnimation,
                child: CircularButton(
                    imageTitle: 'icons/running',
                    background: Colors.exercise,
                    size: 1.2 * Size.fab,
                    iconSize: .45 * Size.fab,
                    onPressed: (_) => null)),
            Container(height: Size.bar, child: Center(child: child))
          ]))
      : Container(
          padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
          child: child);

  Widget _buildCentralItem() => _buildCentralGroup(
      child: CircularButton(
          onPressed: _controller.toggleSubmenu,
          //onLongPressed: _controller.toggleSubmenu,
          child: Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.rotationZ(radians(_centralRotationAnimation.value)),
              child:
                  Icon(Icons.add, color: Colors.icon, size: Size.fab * .5))));

  Widget _buildItem(int index, bool isSelected) {
    final item = widget.items[index];
    final color = isSelected ? widget.color : Colors.icon;
    final isCentral = index * 2 == widget.items.length - 1;
    final child = Transform.scale(
        scale: isSelected ? 1 - _tabController.value : 1,
        child: Image(
            title: item.title,
            color: color,
            width: Size.tabbarIcon,
            height: Size.tabbarIcon,
            fit: BoxFit.contain));

    return GestureDetector(
        onTap: () => Future.delayed(
            Duration(
                milliseconds:
                    (widget.animationDuration.inMilliseconds / 2).round()),
            () => _tabController.reverse()),
        onTapDown: (_) => _controller.index = index,
        onTapUp: (_) => _tabController.forward(),
        onLongPress: () => isCentral ? _controller.toggleSubmenu() : null,
        child: Container(
            color: Colors.transparent, // not clickable without color?
            padding: Padding.content,
            child: isCentral ? _buildCentralGroup(child: child) : child));
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: isSubmenuVisible
          ? _buildCentralItem()
          : Container(
              decoration: BoxDecoration(color: Colors.background, boxShadow: [
                BoxShadow(
                    color: panelShadowColor,
                    blurRadius: panelShadowBlurRadius,
                    offset: Offset(panelShadowHorizontalOffset,
                        -panelShadowVerticalOffset))
              ]),
              padding: EdgeInsets.symmetric(horizontal: Size.horizontalSmall),
              height: Size.bar,
              child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int index = 0;
                            index < widget.items.length;
                            index++) ...[
                          _buildItem(index, _controller.index == index),
                          if (index == 1) _buildCentralItem()
                        ]
                      ]))));
}

class AnimatedBottomNavigationBarItem {
  final String title;

  AnimatedBottomNavigationBarItem({@required this.title});
}

class TabbarController extends GetxController {
  TabbarController({int index, int length, TickerProvider vsync})
      : _controller =
            TabController(initialIndex: index, vsync: vsync, length: length) {
    this.index = index;
  }

  @override
  void onInit() {
    super.onInit();

    ever(_index, (index) => _controller.index = index);
  }

  // visibility
  final _isBarVisible = true.obs;
  bool get isBarVisible => _isBarVisible.value;
  set isBarVisible(bool value) => _isBarVisible.value = value;

  // submenu
  final _isSubmenuVisible = false.obs;
  toggleSubmenu() => _isSubmenuVisible.toggle();

  bool get isSubmenuVisible => _isSubmenuVisible.value;

  // tabbar selected index
  final _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index.value = value;

  // tabController
  final TabController _controller;
  TabController get tabController => _controller;
}
