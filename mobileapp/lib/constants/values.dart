import 'dart:ui';

import 'package:hls/theme/styles.dart';

const isDebug = true;
const version = '0.1.1.1';

// logic
//const maxTrainings = 3;

// config
const assetsDirectory = 'assets';

// lists
const defaultItemsPerPage = 20;

// time
const chatTyperAnimationDuration = Duration(milliseconds: 20);
const defaultAnimationDuration = Duration(milliseconds: 150);
const inputWaitingDuration = Duration(milliseconds: 300);
const navigationTransitionDuration = Duration(milliseconds: 300);
const rotationAnimationDuration = Duration(seconds: 60);
const searchDelayDuration = Duration(seconds: 2);
const submenuAnimationDuration = Duration(milliseconds: 300);
const timeoutDuration = Duration(seconds: 10);
const timerDuration = Duration(seconds: 1);
const tooltipDelay = 5;

// forms
const defaultErrorMaxLines = 3;
const minPasswordLength = 8;

// routes
const authRoute = '/auth';
const resetRoute = '/reset';
const otpRequestRoute = '/otp-request';
const otpVerifyRoute = '/otp-verify';
const chatRoute = '/chat';
const chatResultsRoute = '/chat-results';
const timerRoute = '/timer';
const welcomeRoute = '/welcome';
const profileRoute = '/profile';
const profileFormRoute = '/profile-form';
const trainingStoryRoute = '/training-story';
const homeRoute = '/home';
const articleRoute = '/article';
const storyRoute = '/story';
const videoRoute = '/video';
const foodFilterRoute = '/food-filter';
const foodCategoryRoute = '/food-category';
const foodRoute = '/food';

// styles related
const elevation = 5.0;

const sliderIndicatorHeightCoefficient = .75;
const sliderIndicatorWidthCoefficient = 5;

const hexagonWidth = 14.0 * hexagonSize;
const hexagonHeight = 18.0 * hexagonSize;
const hexagonSize = 1.5; // 0-n
const hexagonOpacity = .3; // 0-1

const welcomeClipRadius = 500;

const dividerWidth = .5;
const borderWidth = 1.0;
const borderRadiusSize = 6.0;

const defaultColumns = 2;

const fontTinySize = 12.0;
const fontSmallSize = 14.0;
const fontSize = 16.0;
const fontBigSize = 20.0;
const fontHugeSize = 28.0;
const fontTimerSize = 100.0;
const fontPercentSize = 48.0;

const iconTinySize = 10.0;
const iconSmallSize = 15.0;
const iconSize = 25.0;
const iconBigSize = 35.0;
const iconHugeSize = 45.0;
const tabbarIconSize = 20.0;

const barHeight = 75.0;
const chatBarHeight = 40.0;
const avatarSize = 120.0;
const graphHeight = 156.0;
const thumbnailHeight = 180.0;
const imageHeight = 265.0;
const pickerSize = 35.0;
const bottomSheetSize = 250.0;
const buttonSize = 39.0;
const buttonBigSize = 56.0;
const buttonHugeSize = 115.0;
const buttonHeightSize = 48.0;

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

const screenShadowBlurRadius = 10.0;
const screenShadowSpreadRadius = .0;
const screenShadowOffset = const Offset(-2, -2);

final innerShadowColor = Colors.primary.withOpacity(.75);
const innerShadowBlurCoefficient = 8.0;
const innerShadowHorizontalOffsetCoefficient = 20.0;
const innerShadowVerticalOffsetCoefficient = 15.0;

final outerShadowColor = Colors.primary.withOpacity(.2);
const outerShadowBlurCoefficient = 12.0;
const outerShadowHorizontalOffsetCoefficient = 15.0;
const outerShadowVerticalOffsetCoefficient = 15.0;

const panelShadowColor = Colors.shadow;
const panelShadowBlurRadius = 1.5;
const panelShadowSpreadRadius = 4.5;
const panelShadowHorizontalOffset = -2.0;
const panelShadowVerticalOffset = -2.0;
const panelShadowOffset =
    const Offset(panelShadowHorizontalOffset, panelShadowVerticalOffset);

const submenuBlurStrength = 6.0;
const submenuBlurVerticalCoefficient = 2;
const submenuDistance = 200;

// desktop window size
const desktopWindowWidth = 540.0;
const desktopWindowHeight = 960.0;
