import 'dart:ui';

import 'package:hls/theme/styles.dart';

const isDebug = false;

// config
const assetsDirectory = 'assets';

// lists
const defaultItemsPerPage = 20;

// time
const timeoutDuration = Duration(seconds: 5);
const inputWaitingDuration = Duration(milliseconds: 300);
const defaultAnimationDuration = Duration(milliseconds: 150);

// forms
const defaultErrorMaxLines = 3;
const minPasswordLength = 8;

// routes
const authRoute = 'auth';
const resetRoute = 'reset';
const homeRoute = 'home';

// styles related
const elevation = 5.0;

const hexagonWidth = 14.0 * hexagonSize;
const hexagonHeight = 18.0 * hexagonSize;
const hexagonSize = 1.5; // 0-n
const hexagonOpacity = .1; // 0-1

const dividerWidth = .5;
const borderWidth = 1.0;
const borderRadiusSize = 4.0;

const fontTinySize = 12.0;
const fontSmallSize = 14.0;
const fontSize = 16.0;
const fontBigSize = 20.0;
const fontHugeSize = 28.0;

const iconTinySize = 10.0;
const iconSmallSize = 15.0;
const iconSize = 25.0;
const iconBigSize = 35.0;
const iconHugeSize = 45.0;
const avatarSize = 150.0;
const fabSize = 56.0;

const horizontalTinyPadding = 5.0;
const horizontalSmallPadding = 10.0;
const horizontalMediumPadding = 15.0;
const horizontalPadding = 20.0;
const horizontalBigPadding = 25.0;

const verticalTinyPadding = 5.0;
const verticalSmallPadding = 10.0;
const verticalMediumPadding = 15.0;
const verticalPadding = 20.0;
const verticalBigPadding = 35.0;

const screenShadowSpreadRadius = 5.0;
const screenShadowBlurRadius = 7.0;
const screenShadowOffset = const Offset(-5, 0);

final innerShadowColor = Colors.primary.withOpacity(.6);
const innerShadowBlurCoefficient = 8.0;
const innerShadowHorizontalOffsetCoefficient = 20.0;
const innerShadowVerticalOffsetCoefficient = 15.0;

final outerShadowColor = Colors.primary.withOpacity(.6);
const outerShadowBlurCoefficient = 8.0;
const outerShadowHorizontalOffsetCoefficient = 30.0;
const outerShadowVerticalOffsetCoefficient = 30.0;