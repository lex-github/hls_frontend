import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    hide
        AnimatedCrossFade,
        Colors,
        CrossFadeState,
        Icon,
        Image,
        Padding,
        TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:flutter/rendering.dart' hide TextStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/animated_cross_fade.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/colors.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/food_filter_model.dart';
import 'package:hls/models/food_model.dart';
import 'package:hls/theme/styles.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class CircularButton extends Button {
  CircularButton({
    Function onPressed,
    Function onLongPressed,
    double size,
    Color color = Colors.light,
    Color background = Colors.primary,
    Color borderColor,
    Widget child,
    String title,
    M.TextStyle titleStyle,
    String imageTitle,
    icon,
    iconSize,
    bool isLoading = false,
    bool isDisabled = false,
  }) : super(
            onPressed: onPressed,
            onLongPressed: onLongPressed,
            isCircular: true,
            isSwitch: isLoading,
            isSelected: isLoading,
            isLoading: isLoading,
            isDisabled: isDisabled,
            size: size ?? Size.buttonBig,
            padding: Padding.zero,
            color: color,
            background: background,
            borderColor: borderColor,
            child: child,
            title: title,
            titleStyle: titleStyle,
            imageTitle: imageTitle,
            icon: icon,
            iconSize: iconSize);
}

class Button extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final Widget image;
  final String title;
  final M.TextStyle titleStyle;
  final String imageTitle;
  final Color color;
  final Color background;
  final Color borderColor;
  final bool isSelected;
  final bool isSwitch;
  final bool isLoading;
  final bool isDisabled;
  final bool isCircular;
  final Function onPressed;
  final Function(bool) onSelected;
  final Function onLongPressed;
  final EdgeInsets padding;
  final double size;

  Button(
      {this.child,
      IconData icon,
      this.color,
      this.background,
      this.borderColor,
      this.title,
      this.titleStyle,
      this.imageTitle,
      this.isSelected = false,
      this.isSwitch = false,
      this.isLoading = false,
      this.isCircular = false,
      this.isDisabled = false,
      this.onPressed,
      this.onSelected,
      this.onLongPressed,
      EdgeInsets padding,
      double size,
      double iconSize})
      : this.size = size ?? Size.iconHuge,
        this.padding = padding ?? Padding.button,
        this.icon = icon != null
            ? Icon(icon,
                color: color ?? Colors.icon,
                size: iconSize ?? ((size ?? Size.iconHuge) * .55))
            : null,
        this.image = !imageTitle.isNullOrEmpty
            ? Image(
                title: imageTitle,
                color: color ?? Colors.icon,
                size: iconSize ?? ((size ?? Size.iconHuge) * .55))
            : null,
        assert(child != null ||
            icon != null ||
            title != null ||
            imageTitle != null);

  // builders

  Widget _buildChild() => isLoading
      ? Container(
          padding: padding,
          child: SizedBox(child: Loading(color: color ?? Colors.primary)))
      : child ??
          icon ??
          image ??
          TextPrimaryHint(title,
              align: TextAlign.center,
              style: titleStyle,
              size: titleStyle?.fontSize);

  Widget _buildButton({bool isSelected, RxBool onChanged}) => GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (onPressed != null)
                Future.delayed(defaultAnimationDuration)
                    .then((_) => onPressed());
              if (isLoading) return;
              if (isSwitch) onChanged(!isSelected);
              if (isSwitch && onSelected != null)
                Future.delayed(defaultAnimationDuration)
                    .then((_) => onSelected(!isSelected));
            },
      onTapDown: isDisabled
          ? null
          : (_) {
              if (isLoading) return;
              if (!isSwitch) onChanged(true);
            },
      onTapUp: isDisabled
          ? null
          : (_) {
              if (isLoading) return;
              if (!isSwitch)
                Future.delayed(defaultAnimationDuration)
                    .then((_) => onChanged(false));
            },
      onTapCancel: isDisabled
          ? null
          : () {
              if (isLoading) return;
              if (!isSwitch) onChanged(false);
            },
      onLongPress: onLongPressed,
      child: AnimatedCrossFade(
          duration: Platform.isIOS ? Duration.zero : defaultAnimationDuration,
          crossFadeState:
              isSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstCurve: Curves.easeInCirc,
          secondCurve: Curves.easeOutCirc,
          firstChild: ButtonInner(
              background: background,
              borderColor: borderColor,
              padding: padding,
              size: size,
              child: _buildChild(),
              isCircular: isCircular),
          secondChild: ButtonOuter(
              background: isDisabled ? Colors.disabled : background,
              borderColor: borderColor,
              padding: padding,
              size: size,
              child: _buildChild(),
              isClickable: !isDisabled,
              isCircular: isCircular)));

  @override
  Widget build(_) => ObxValue(
      (isSelected) =>
          _buildButton(isSelected: isSelected.value, onChanged: isSelected),
      isSelected.obs);
}

class ButtonInner extends StatelessWidget {
  final Color background;
  final Color borderColor;
  final Widget child;
  final double size;
  final EdgeInsets padding;
  final bool isCircular;

  ButtonInner(
      {this.background,
      this.borderColor,
      this.child,
      double size,
      this.padding,
      this.isCircular = true})
      : this.size = size ?? Size.iconHuge;

  @override
  Widget build(BuildContext context) {
    final radius = isCircular
        ? BorderRadius.all(Radius.circular(size))
        : borderRadiusCircular;
    final blurRadius = size / innerShadowBlurCoefficient;
    final offset = Offset(size / innerShadowHorizontalOffsetCoefficient,
        size / innerShadowVerticalOffsetCoefficient);

    final shouldUseBackgroundColor =
        background != null && background != Colors.transparent;
    final shadowColor = borderColor == null ||
            borderColor == Colors.transparent ||
            borderColor == Colors.disabled
        ? innerShadowColor
        : borderColor;

    final decoration = BoxDecoration(
        borderRadius: radius,
        border: Border.all(
            width: 0, //borderWidth,
            color:
                shouldUseBackgroundColor ? background.darken(.2) : shadowColor,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
              color: shouldUseBackgroundColor
                  ? background.darken(.1)
                  : shadowColor),
          BoxShadow(
              color: shouldUseBackgroundColor ? background : Colors.background,
              blurRadius: blurRadius,
              offset: offset)
        ]);

    final center = Container(
        height: isCircular ? size : null,
        width: isCircular ? size : null,
        padding: padding,
        child: Center(child: child),
        decoration: decoration);

    return ClipRRect(borderRadius: radius, child: center);
  }
}

class ButtonOuter extends StatelessWidget {
  final Color background;
  final Color borderColor;
  final Widget child;
  final double size;
  final EdgeInsets padding;
  final bool isClickable;
  final bool isCircular;

  ButtonOuter(
      {this.background,
      this.borderColor,
      this.child,
      double size,
      this.padding,
      this.isClickable = false,
      this.isCircular = true})
      : this.size = size ?? Size.iconHuge;

  @override
  Widget build(BuildContext context) {
    final radius = isCircular ? Radius.circular(size) : radiusCircular;
    final borderRadius = isCircular
        ? BorderRadius.all(Radius.circular(size))
        : borderRadiusCircular;
    // final blurRadius = size / outerShadowBlurCoefficient;
    // final offset = Offset(size / outerShadowHorizontalOffsetCoefficient,
    //     size / outerShadowVerticalOffsetCoefficient);

    final borderColorBottom = borderColor ?? background ?? Colors.primary;

    return MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
            decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [
              BoxShadow(
                  color: buttonShadowColor,
                  blurRadius: buttonShadowBlurRadius,
                  spreadRadius: buttonShadowSpreadRadius,
                  offset: buttonShadowOffset)
            ]),
            child: OutlineGradientButton(
                padding: padding,
                //elevation: 5,
                radius: radius,
                strokeWidth: borderWidth / 2,
                gradient: LinearGradient(colors: [
                  isCircular
                      ? Colors.white
                      : Color.alphaBlend(borderColorBottom.withOpacity(.3),
                          Colors.upperBorder),
                  borderColorBottom
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                backgroundColor: background ?? Colors.background,
                child: SizedBox(
                    height: isCircular ? size : null,
                    width: isCircular ? size : null,
                    child: Center(child: child)))));

    return MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
            height: isCircular ? size : null,
            width: isCircular ? size : null,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                    width: borderWidth / 2,
                    color: Colors.shadowLight.withOpacity(.01),
                    style: BorderStyle.solid)),
            child: AnimatedContainer(
                duration: inputWaitingDuration,
                curve: Curves.easeInQuint,
                child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Container(
                        padding: padding, child: Center(child: child))),
                decoration: BoxDecoration(
                    color: background ?? Colors.background,
                    borderRadius: borderRadius,
                    border: Border.all(
                        width: borderWidth / 2,
                        color: borderColor ?? background ?? Colors.primary),
                    boxShadow: [
                      // if (isClickable)
                      //   BoxShadow(
                      //       color: background != null
                      //           ? background.withOpacity(.2)
                      //           : outerShadowColor,
                      //       blurRadius: buttonShadowBlurRadius,
                      //       spreadRadius: buttonShadowSpreadRadius,
                      //       offset: -buttonShadowOffset),
                      // BoxShadow(
                      //     color: Colors.shadowLight,
                      //   blurRadius: buttonShadowBlurRadius,
                      //   spreadRadius: buttonShadowSpreadRadius,
                      //     offset: buttonShadowOffset)
                      BoxShadow(
                          color: buttonShadowColor,
                          blurRadius: buttonShadowBlurRadius,
                          spreadRadius: buttonShadowSpreadRadius,
                          offset: buttonShadowOffset)
                    ]))));
  }
}

class Clickable extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final ShapeBorder border;
  final double borderRadius;
  final Color splashColor;

  Clickable(
      {@required this.child,
      this.onPressed,
      this.border,
      this.borderRadius,
      this.splashColor});

  Widget _buildClickable() => Material(
      color: Colors.transparent,
      child: InkWell(
          splashColor: splashColor,
          highlightColor: Colors.transparent,
          child: child,
          onTap: () => Future.delayed(defaultAnimationDuration)
              .then((_) => onPressed != null ? onPressed() : null),
          customBorder: border));

  @override
  Widget build(BuildContext context) => borderRadius == null
      ? _buildClickable()
      : ClipRRect(
          borderRadius:
              BorderRadius.circular(borderRadius ?? Size.borderRadius),
          child: _buildClickable());
}

// class ListItemButton extends Button {
//   ListItemButton(
//       {@required Widget child,
//       bool isSelected = false,
//       bool isSwitch = false,
//       bool isLoading = false,
//       Function onPressed,
//       EdgeInsets padding})
//       : super(
//             child: child,
//             isSelected: isSelected,
//             isSwitch: isSwitch,
//             isLoading: isLoading,
//             isCircular: false,
//             onPressed: onPressed,
//             padding: padding);
// }

class ListItemButton extends Button {
  ListItemButton(
      {Widget child,
      String imageTitle,
      double imageSize,
      String title,
      bool isSelected = false,
      bool isSwitch = false,
      bool isLoading = false,
      Function onPressed,
      EdgeInsets padding})
      : super(
            borderColor: Colors.disabled,
            child: child ??
                Row(children: [
                  if (!imageTitle.isNullOrEmpty) ...[
                    SizedBox(
                        height: imageSize,
                        width: imageSize ?? Size.iconBig,
                        child: Center(
                          child:
                              Image(
                                  height: imageSize,
                                  width: imageSize ?? Size.iconBig,
                                  title: imageTitle)
                          //     CachedNetworkImage(
                          //   height: imageSize,
                          //   width: imageSize ?? Size.iconBig,
                          //   imageUrl: imageTitle,
                          //   // cacheManager: CacheM,
                          //   imageBuilder: (_, imageProvider) => Container(
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         image: imageProvider,
                          //         fit: BoxFit.cover,
                          //       ),
                          //     ),
                          //   ),
                          //   placeholder: (context, url) =>
                          //       const CircularProgressIndicator(),
                          //   errorWidget: (context, url, error) =>
                          //       const Icon(Icons.error),
                          // ),
                        )),
                    HorizontalSpace()
                  ],
                  Expanded(child: TextPrimaryHint(title)),
                  HorizontalSpace(),
                  Icon(FontAwesomeIcons.chevronRight,
                      color: Colors.disabled, size: Size.iconSmall)
                ]),
            isSelected: isSelected,
            isSwitch: isSwitch,
            isLoading: isLoading,
            isCircular: false,
            onPressed: onPressed,
            padding: padding) {
    //print('ListItemButton imageTitle: $imageTitle');
  }
}

class ListItemFoodButton extends ListItemButton {
  ListItemFoodButton(
      {@required FoodData item,
      List<FoodFilterData> filters,
      bool isSelected = false,
      bool isSwitch = false,
      bool isLoading = false,
      Function onPressed})
      : super(
            child: Row(children: [
              if (!item.imageUrl.isNullOrEmpty) ...[
                Image(width: Size.iconHuge, title: item.imageUrl),
                HorizontalSpace()
              ],
              Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Expanded(
                          child: TextPrimaryHint(item.title,
                              overflow: TextOverflow.visible)),
                      // HorizontalSpace(),
                      // Icon(Icons.arrow_forward_ios,
                      //     color: Colors.disabled, size: Size.iconSmall)
                    ]),
                    VerticalTinySpace(),
                    TextSecondary(item.category.title),
                    VerticalSmallSpace(),
                    //Row(children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          if (!filters.isNullOrEmpty)
                            for (int i = 0;
                                i < min(filters.length, 4);
                                i++) ...[
                              ListItemFoodIndicator(
                                  title: filters[i].title,
                                  data: item.getByKey(filters[i].key),
                                  color: Colors.disabled),
                              HorizontalSmallSpace()
                            ],
                          if (item.shouldDisplay('carbohydrates') &&
                              !filters.isNullOrEmpty &&
                              filters.length < 1) ...[
                            ListItemFoodIndicator(
                                title: foodCarbLabel,
                                data: item.carbs,
                                color: Colors.carbs),
                            HorizontalSmallSpace()
                          ],
                          if (item.shouldDisplay('fats') &&
                              !filters.isNullOrEmpty &&
                              filters.length < 1) ...[
                            ListItemFoodIndicator(
                                data: item.fats, color: Colors.fats),
                            HorizontalSmallSpace()
                          ],
                          if (item.shouldDisplay('proteins') &&
                              !filters.isNullOrEmpty &&
                              filters.length < 1) ...[
                            ListItemFoodIndicator(
                                data: item.proteins, color: Colors.proteins),
                            HorizontalSmallSpace()
                          ],
                          if (item.shouldDisplay('water') &&
                              !filters.isNullOrEmpty &&
                              filters.length < 1)
                            ListItemFoodIndicator(
                                data: item.water, color: Colors.water)
                        ]))
                  ]))
            ]),
            isSelected: isSelected,
            isSwitch: isSwitch,
            isLoading: isLoading,
            onPressed: onPressed);
}

class ListItemFoodIndicator extends StatelessWidget {
  final Color color;
  final FoodSectionData data;
  final String title;

  ListItemFoodIndicator({this.color, this.title, @required this.data});

  @override
  Widget build(BuildContext context) {
    final value = data?.quantity ?? .0;
    final valueText = value == value.roundToDouble()
        ? value.round().toString()
        : value.toString();

    return Container(
        decoration:
            BoxDecoration(color: color, borderRadius: borderRadiusCircular),
        padding: Padding.tiny,
        child: Column(children: [
          Text(valueText,
              style: TextStyle.primary.copyWith(
                  fontSize: 1.1 * Size.fontTiny, fontWeight: FontWeight.bold)),
          Text(title ?? data.title.toLowerCase(),
              style: TextStyle.secondary
                  .copyWith(fontSize: .9 * Size.fontTiny, color: Colors.light))
        ]));
  }
}
