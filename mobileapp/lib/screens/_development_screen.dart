import 'package:flutter/material.dart' hide Page, TextStyle;
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';

class _DevelopmentChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: TextSecondary(developmentText));
}

class DevelopmentScreen extends Screen {
  DevelopmentScreen({title, Widget drawer, bool shouldShowDrawer = false})
      : super(
            title: title,
            drawer: drawer,
            shouldShowDrawer: shouldShowDrawer,
            child: _DevelopmentChild());
}

class DevelopmentPage extends Page {
  DevelopmentPage() : super(child: _DevelopmentChild());
}
