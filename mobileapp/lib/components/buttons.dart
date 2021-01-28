import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:flutter/rendering.dart';
import 'package:get/state_manager.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/colors.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/theme/styles.dart';

class CircularButton extends Button {
  CircularButton(
      {Function onPressed,
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
      iconSize})
      : super(
            onPressed: onPressed,
            onLongPressed: onLongPressed,
            isCircular: true,
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
                size: iconSize ?? ((size ?? Size.iconHuge) * .5))
            : null,
        this.image = !imageTitle.isNullOrEmpty
            ? Image(
                title: imageTitle,
                color: color ?? Colors.icon,
                size: iconSize ?? ((size ?? Size.iconHuge) * .5))
            : null,
        assert(child != null ||
            icon != null ||
            title != null ||
            imageTitle != null);

  // builders

  Widget _buildChild() => isLoading
      ? Container(
          padding: padding, child: Loading(color: color ?? Colors.primary))
      : child ??
          icon ??
          image ??
          TextPrimaryHint(title, align: TextAlign.center, style: titleStyle);

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
      child: isSelected
          ? ButtonInner(
              background: background,
              borderColor: borderColor,
              padding: padding,
              size: size,
              child: _buildChild(),
              isCircular: isCircular)
          : ButtonOuter(
              background: background ?? (isDisabled ? Colors.disabled : null),
              borderColor: borderColor,
              padding: padding,
              size: size,
              child: _buildChild(),
              isClickable: !isDisabled,
              isCircular: isCircular));

  @override
  Widget build(_) => ObxValue(
      (isSelected) => _buildButton(
            isSelected: isSelected.value,
            onChanged:
                isSelected, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
          ),
      isSelected.obs);
}

class StrokedButtonWidget extends StatelessWidget {
  final String title;
  final Color borderColor;
  final M.TextStyle titleStyle;
  final EdgeInsetsGeometry padding;

  StrokedButtonWidget({this.title, this.borderColor, this.titleStyle, this.padding});

  @override
  Widget build(BuildContext context) {
    return Button(
      padding: EdgeInsets.symmetric(vertical: Padding.button.top),
      title: title,
      borderColor: borderColor,
      titleStyle: M.TextStyle(fontSize: Size.fontTiny),
    );
  }
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

    final decoration = BoxDecoration(
        borderRadius: radius,
        border: Border.all(
            width: borderWidth,
            color: ((background != null && background != Colors.transparent)
                ? background.darken(.2)
                : borderColor ?? innerShadowColor),
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
              color: (background != null && background != Colors.transparent)
                  ? background.darken(.1)
                  : borderColor ?? innerShadowColor),
          BoxShadow(
              color: (background != null && background != Colors.transparent)
                  ? background
                  : Colors.background,
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
    final radius = isCircular
        ? BorderRadius.all(Radius.circular(size))
        : borderRadiusCircular;
    // final blurRadius = size / outerShadowBlurCoefficient;
    // final offset = Offset(size / outerShadowHorizontalOffsetCoefficient,
    //     size / outerShadowVerticalOffsetCoefficient);

    return MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
            height: isCircular ? size : null,
            width: isCircular ? size : null,
            decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                    width: borderWidth / 2,
                    color: Colors.shadowLight.withOpacity(.01),
                    style: BorderStyle.solid)),
            child: Container(
                child: ClipRRect(
                    borderRadius: radius,
                    child: Container(
                        padding: padding, child: Center(child: child))),
                decoration: BoxDecoration(
                  color: background ?? Colors.background,
                  borderRadius: radius,
                  border: Border.all(
                      width: borderWidth / 2,
                      color: borderColor ?? background ?? Colors.primary),
                  // boxShadow: [
                  //   if (isClickable)
                  //     BoxShadow(
                  //         color: background != null
                  //             ? background.withOpacity(.2)
                  //             : outerShadowColor,
                  //         blurRadius: blurRadius,
                  //         offset: -offset),
                  //   BoxShadow(
                  //       color: Colors.shadowLight,
                  //       blurRadius: blurRadius,
                  //       offset: offset)
                  // ]
                ))));
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
      : ClipRRect(borderRadius: borderRadiusCircular, child: _buildClickable());
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
                  Image(width: Size.iconBig, title: imageTitle),
                  HorizontalSpace(),
                  TextPrimaryHint(title),
                  Expanded(child: HorizontalSpace()),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.disabled, size: Size.iconSmall)
                ]),
            isSelected: isSelected,
            isSwitch: isSwitch,
            isLoading: isLoading,
            isCircular: false,
            onPressed: onPressed,
            padding: padding);
}
