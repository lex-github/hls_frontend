import 'package:flutter/material.dart' as M;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls/constants/values.dart';

// sizes adjusted to screen
class Size {
  static MediaQueryData _mediaQueryData;
  static double top = 0;
  static double screenWidth = targetWidth;
  static double screenHeight = targetHeight;

  static double percentWidth = screenWidth / 100;
  static double percentHeight = screenHeight / 100;

  static double widthRatio = 1;
  static double heightRatio = 1;

  static const double targetWidth = 360;
  static const double targetHeight = 640;
  static const double widthMinRatio = .5;
  static const double widthMaxRatio = 1.5;
  static const double heightMinRatio = .5;
  static const double heightMaxRatio = 1.5;

  Size.init() {
    _mediaQueryData = Get.mediaQuery;

    top = _mediaQueryData.padding.top;

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    percentWidth = screenWidth / 100;
    percentHeight = screenHeight / 100;

    widthRatio = screenWidth / targetWidth;
    heightRatio = screenHeight / targetHeight;
  }

  //static double ratio(size) => (size ?? 0) * widthRatio;
  static double ratio(size) =>
      screenWidth > screenHeight ? height(size) : width(size);

  static double width(width) => (width ?? 0) * widthRatio;
  static double height(height) => (height ?? 0) * heightRatio;

  static double widthLimited(width) =>
      width * widthRatio.clamp(widthMinRatio, widthMaxRatio);
  static double heightLimited(height) =>
      height * heightRatio.clamp(heightMinRatio, heightMaxRatio);

  // common sizes
  static double get divider => ratio(dividerWidth);
  static double get border => ratio(borderWidth);
  static double get borderRadius => ratio(borderRadiusSize);

  static double get fontTiny => ratio(fontTinySize);
  static double get fontSmall => ratio(fontSmallSize);
  static double get font => ratio(fontSize);
  static double get fontBig => ratio(fontBigSize);
  static double get fontHuge => ratio(fontHugeSize);
  static double get fontTimer => ratio(fontTimerSize);
  static double get fontPercent => ratio(fontPercentSize);

  static double get iconTiny => ratio(iconTinySize);
  static double get iconSmall => ratio(iconSmallSize);
  static double get icon => ratio(iconSize);
  static double get iconBig => ratio(iconBigSize);
  static double get iconHuge => ratio(iconHugeSize);
  static double get tabbarIcon => ratio(tabbarIconSize);

  static double get bar => ratio(barHeight);
  static double get chatBar => ratio(chatBarHeight);
  static double get avatar => ratio(avatarSize);
  static double get graph => ratio(graphHeight);
  static double get thumbnail => ratio(thumbnailHeight);
  static double get image => ratio(imageHeight);
  static double get bottomSheet => ratio(bottomSheetSize);
  static double get picker => ratio(pickerSize);
  static double get cupertinoPicker => ratio(cupertinoPickerSize);
  static double get button => ratio(buttonSize);
  static double get buttonBig => ratio(buttonBigSize);
  static double get buttonHuge => ratio(buttonHugeSize);
  static double get buttonHeight => ratio(buttonHeightSize);

  static double get horizontalTiny => width(horizontalTinyPadding);
  static double get horizontalSmall => width(horizontalSmallPadding);
  static double get horizontalMedium => width(horizontalMediumPadding);
  static double get horizontal => width(horizontalPadding);
  static double get horizontalBig => width(horizontalBigPadding);

  static double get verticalTiny => height(verticalTinyPadding);
  static double get verticalSmall => height(verticalSmallPadding);
  static double get verticalMedium => height(verticalMediumPadding);
  static double get vertical => height(verticalPadding);
  static double get verticalBig => height(verticalBigPadding);

  static M.Size get hexagon =>
      M.Size(ratio(hexagonWidth), ratio(hexagonHeight));
}

// colors
class Colors {
  // component
  //static const background = M.Color(0xFF1F191A);
  static const background = M.Color(0xFF1D1C1D);
  static const primary = M.Color(0xFF347CFF);
  static const success = M.Color(0xFF92E300);
  static const failure = M.Color(0xFFD9134C);
  static const disabled = M.Color(0xFF404040);
  static const light = Colors.white;
  static const upperBorder = M.Color(0xFF888888);

  static const transparent = M.Colors.transparent;
  static const black = M.Colors.black;
  static const white = M.Colors.white;

  //static const shadow = M.Color(0xFF000000);
  static const shadow = M.Color(0x66121212);
  //static const shadowLight = M.Color(0x662f2d3e);
  static const shadowLight = shadow;
  static const icon = Colors.light;

  // text
  static const primaryText = Colors.light;
  static const secondaryText = M.Color(0xFF707070);
  static const darkText = M.Color(0xFF333333);

  // project specific
  static const champion = M.Color(0xFFF2994A);

  //static const schedule = M.Color(0xFF8416FF);
  static const schedule = M.Color(0xFF8416FF);
  // static const nutrition = M.Color(0xFF99E600);
  static const nutrition = M.Color(0xFF66D600);
  static const exercise = M.Color(0xFFD70010);

  static const scheduleNight = M.Color(0xFFC53DFF);
  static const scheduleDay = M.Color(0xFFECFF1F);
  static const scheduleMainFood = M.Color(0xFFFF9900);
  //static const scheduleProteinFood = M.Color(0xFFFFF0F5);
  static const scheduleAdditionalFood = M.Color(0xFF1982C4);

  static const water = M.Color(0xFF017CD0);
  static const carbs = M.Color(0xFF00A632);
  static const fats = M.Color(0xFFE38D00);
  static const proteins = M.Color(0xFFA50800);

  static const macroHLS = M.Color(0xFFD70010);
  static const macroNoHLS = M.Color(0xFF8E8D8E);
  static const macroStatistical = M.Color(0xFF347CFF);

  static const heartRate = M.Color(0xAAE1667E);
  // static const heartbeatMaximum = M.Color(0xFF8416FF);
  // static const heartbeatHeavy = M.Color(0xFFD70010);
  // static const heartbeatMedium = M.Color(0xFFFF6600);
  // static const heartbeatLight = M.Color(0xFFCDA800);
  // static const heartbeatMinimum = M.Color(0x8899E600);
}

// padding
class Padding {
  static const zero = M.EdgeInsets.zero;

  static get screen => M.EdgeInsets.only(
      left: Size.horizontal,
      top: Size.top + Size.vertical,
      right: Size.horizontal,
      bottom: Size.vertical);
  static get content => M.EdgeInsets.symmetric(
      horizontal: Size.horizontal, vertical: Size.vertical);
  static get button => M.EdgeInsets.symmetric(
      horizontal: Size.horizontal, vertical: Size.verticalSmall);
  static get chatButton =>
      M.EdgeInsets.symmetric(horizontal: 0, vertical: Size.verticalSmall);

  static get tiny => M.EdgeInsets.symmetric(
      horizontal: Size.horizontalTiny, vertical: Size.horizontalTiny);
  static get small => M.EdgeInsets.symmetric(
      horizontal: Size.horizontalSmall, vertical: Size.verticalSmall);
  static get medium => M.EdgeInsets.symmetric(
      horizontal: Size.horizontalMedium, vertical: Size.verticalMedium);
}

// styles
class TextStyle {
  static get primary =>
      M.TextStyle(fontSize: Size.font, color: Colors.primaryText);
  static get secondary =>
      M.TextStyle(fontSize: Size.fontSmall, color: Colors.secondaryText);
  static get secondaryImportant => M.TextStyle(
      fontSize: Size.fontSmall,
      color: Colors.primaryText,
      fontWeight: FontWeight.bold);
  static get title => M.TextStyle(
      fontSize: Size.fontBig,
      fontWeight: FontWeight.w500,
      color: Colors.primaryText);
  static get indicator => M.TextStyle(
      fontSize: Size.fontHuge,
      fontWeight: FontWeight.bold,
      color: Colors.secondaryText);

  static get buttonChat => M.TextStyle(
      fontSize: Size.fontSmall,
      fontWeight: FontWeight.w400,
      color: Colors.primaryText);
  static get buttonTimer => M.TextStyle(
      fontSize: Size.fontBig,
      fontWeight: FontWeight.w400,
      color: Colors.primaryText);

  static get error =>
      M.TextStyle(fontSize: Size.fontTiny, color: Colors.failure);
  static get version =>
      M.TextStyle(fontSize: Size.fontTiny, color: Colors.light);
}

final borderRadiusCircular = BorderRadius.circular(Size.borderRadius);
final radiusCircular = Radius.circular(Size.borderRadius);
