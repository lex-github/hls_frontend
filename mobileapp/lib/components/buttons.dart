import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:flutter/rendering.dart';
import 'package:get/state_manager.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/theme/styles.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final String title;
  final Color color;
  final Color background;
  final bool isSelected;
  final bool isSwitch;
  final bool isLoading;
  final bool isDisabled;
  final bool isCircular;
  final Function onPressed;
  final EdgeInsets padding;
  final double size;
  final double iconSize;

  Button(
      {this.child,
      IconData icon,
      this.color,
      this.background,
      this.title,
      this.isSelected = false,
      this.isSwitch = false,
      this.isLoading = false,
      this.isCircular = false,
      this.isDisabled = false,
      this.onPressed,
      EdgeInsets padding,
      double size,
      double iconSize})
      : this.size = size ?? Size.iconHuge,
        this.iconSize = iconSize ?? ((size ?? Size.iconHuge) * .5),
        this.padding = padding ?? Padding.button,
        this.icon = icon != null
            ? Icon(icon, color: color ?? Colors.icon, size: iconSize)
            : null,
        assert(child != null || icon != null || title != null);

  // builders

  Widget _buildChild() => isLoading
      ? Container(padding: padding, child: Loading())
      : child ?? icon ?? TextPrimary(title);

  Widget _buildButton({bool isSelected, RxBool onChanged}) => GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (onPressed != null) onPressed();
              if (isLoading) return;
              if (isSwitch) onChanged(!isSelected);
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
              if (!isSwitch) onChanged(false);
            },
      onTapCancel: isDisabled
          ? null
          : () {
              if (isLoading) return;
              if (!isSwitch) onChanged(false);
            },
      child: isSelected
          ? ButtonInner(
              padding: padding,
              size: size,
              child: _buildChild(),
              isCircular: isCircular)
          : ButtonOuter(
              background: background ?? (isDisabled ? Colors.disabled : null),
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

class ButtonInner extends StatelessWidget {
  final Widget child;
  final double size;
  final EdgeInsets padding;
  final bool isCircular;

  ButtonInner({this.child, double size, this.padding, this.isCircular = true})
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
            color: innerShadowColor,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(color: innerShadowColor),
          BoxShadow(
              color: Colors.background, blurRadius: blurRadius, offset: offset)
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
  final Widget child;
  final double size;
  final EdgeInsets padding;
  final bool isClickable;
  final bool isCircular;

  ButtonOuter(
      {this.background,
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
    final blurRadius = size / outerShadowBlurCoefficient;
    final offset = Offset(size / outerShadowHorizontalOffsetCoefficient,
        size / outerShadowVerticalOffsetCoefficient);

    return MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
            height: isCircular ? size : null,
            width: isCircular ? size : null,
            decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                    width: borderWidth / 2,
                    color: Colors.shadow.withOpacity(.01),
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
                        width: borderWidth / 2, color: Colors.transparent),
                    boxShadow: [
                      if (isClickable)
                        BoxShadow(
                            color: outerShadowColor,
                            blurRadius: blurRadius,
                            offset: -offset),
                      BoxShadow(
                          color: Colors.shadow,
                          blurRadius: blurRadius,
                          offset: offset)
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
          onTap: onPressed,
          customBorder: border));

  @override
  Widget build(BuildContext context) => borderRadius == null
      ? _buildClickable()
      : ClipRRect(borderRadius: borderRadiusCircular, child: _buildClickable());
}

class ListItemButton extends Button {
  ListItemButton(
      {@required Widget child,
      bool isSelected = false,
      bool isSwitch = false,
      bool isLoading = false,
      Function onPressed,
      EdgeInsets padding})
      : super(
            child: child,
            isSelected: isSelected,
            isSwitch: isSwitch,
            isLoading: isLoading,
            isCircular: false,
            onPressed: onPressed,
            padding: padding);
}
