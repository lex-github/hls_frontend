import 'package:flutter/material.dart';

class TabbarBody extends StatefulWidget {
  final Widget child;
  TabbarBody({this.child});

  @override
  _State createState() => _State();
}

class _State extends State<TabbarBody> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
