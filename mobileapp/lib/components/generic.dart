import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart' hide Svg;
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/helpers/strings.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/navigation/tabbar_screen.dart';
import 'package:hls/theme/styles.dart';

class Avatar extends StatelessWidget {
  final UserData user;
  final Widget child;
  final String imageUri;
  final bool isLink;
  final double size;
  Avatar({this.user, this.child, this.imageUri, this.isLink = true, size})
      : assert(user != null || child != null || !imageUri.isNullOrEmpty),
        this.size = size ?? Size.iconBig;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Center(
                  child: child ??
                      Image(
                          title: imageUri ?? user.avatarUri,
                          isLink: isLink,
                          height: size,
                          width: size,
                          fit: BoxFit.cover)))
        ]),
      );
}

class Constraint extends StatelessWidget {
  final Widget child;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  Constraint(
      {@required this.child,
      this.minWidth = 0.0,
      this.maxWidth = double.infinity,
      this.minHeight = 0.0,
      this.maxHeight = double.infinity})
      : assert(minWidth != null),
        assert(maxWidth != null),
        assert(minHeight != null),
        assert(maxHeight != null);

  @override
  Widget build(BuildContext context) => Center(
      child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: minWidth,
              maxWidth: maxWidth,
              minHeight: minHeight,
              maxHeight: maxHeight),
          child: child));
}

class EmptyPage extends Page {
  EmptyPage({String description = noDataText})
      : super(child: Center(child: TextSecondary(description)));
}

class HorizontalTinySpace extends SizedBox {
  HorizontalTinySpace() : super(width: Size.horizontalTiny);
}

class HorizontalSmallSpace extends SizedBox {
  HorizontalSmallSpace() : super(width: Size.horizontalSmall);
}

class HorizontalMediumSpace extends SizedBox {
  HorizontalMediumSpace() : super(width: Size.horizontalMedium);
}

class HorizontalSpace extends SizedBox {
  HorizontalSpace() : super(width: Size.horizontal);
}

class HorizontalBigSpace extends SizedBox {
  HorizontalBigSpace() : super(width: Size.horizontalBig);
}

class HLTinySpace extends SizedBox {
  HLTinySpace() : super(width: Size.widthLimited(horizontalTinyPadding));
}

class HLSmallSpace extends SizedBox {
  HLSmallSpace() : super(width: Size.widthLimited(horizontalSmallPadding));
}

class HLMediumSpace extends SizedBox {
  HLMediumSpace() : super(width: Size.widthLimited(horizontalMediumPadding));
}

class HLSpace extends SizedBox {
  HLSpace() : super(width: Size.widthLimited(horizontalPadding));
}

class HLBigSpace extends SizedBox {
  HLBigSpace() : super(width: Size.widthLimited(horizontalBigPadding));
}

/// Widget which displays image
///
/// Different widgets will be used to display image based on value of [image] and [title]. Image is
/// assumed to be in [assetsDirectory].
///
/// If [image] is set or [title] does not start with 'http' or ends with '.svg' [Material.Image]
/// will be used.
///
/// If [title] starts with 'http' [CachedNetworkImage] will be used with [loadingBorder]
/// being border of container displayed during loading and [builder] called after image is
/// downloaded and cached.
///
/// If [title] ends with '.svg' [ImageSvg] is used to display image.
class Image extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Color color;
  final Alignment alignment;
  final BoxFit fit;
  final Border loadingBorder;
  final Widget Function(BuildContext, ImageProvider) builder;
  final ImageProvider image;
  final bool isLink;

  Image(
      {this.title,
      this.loadingBorder,
      double width,
      double height,
      double size,
      this.color,
      BoxFit fit,
      this.alignment = Alignment.center,
      this.builder,
      this.image,
      this.isLink = false})
      : assert(!title.isNullOrEmpty || image != null),
        this.fit = fit ??
            (width != null || height != null || size != null
                ? BoxFit.contain
                : BoxFit.scaleDown),
        this.width = width ?? size,
        this.height = height ?? size;

  // methods

  String _prepareLink(title) =>
      title.startsWith('http') ? title : '$siteUrl${trimLeading('/', title)}';

  // builders

  Widget _buildError() => Container(
      width: width,
      height: height,
      color: Colors.failure,
      child: Icon(Icons.error, color: Colors.white));

  @override
  Widget build(_) => image != null
      ? M.Image(
          image: image,
          height: height,
          width: width,
          color: color,
          fit: fit,
          alignment: alignment)
      : title.isNullOrEmpty
          ? _buildError()
          : title.startsWith('http') || isLink
              ? title.contains('.svg')
                  ? SvgPicture.network(title,
                      height: height,
                      width: width,
                      color: color,
                      fit: fit,
                      alignment: alignment)
                  : CachedNetworkImage(
                      imageUrl: _prepareLink(title),
                      height: height,
                      width: width,
                      color: color,
                      fit: fit,
                      alignment: alignment,
                      imageBuilder: builder,
                      // placeholder: (_, __) => Container(
                      //     decoration: BoxDecoration(border: loadingBorder),
                      //     width: width,
                      //     height: height,
                      //     child: Center(child: SimpleLoading())),
                      progressIndicatorBuilder: (context, url,
                              downloadProgress) =>
                          Container(
                            decoration: BoxDecoration(border: loadingBorder),
                            width: width,
                            height: height,
                            child: Center(
                                child:
                                    Loading(value: downloadProgress.progress)),
                          ),
                      errorWidget: (_, __, ___) => _buildError())
              : !(title.contains('.png') ||
                      title.contains('.jpg') ||
                      title.contains('.jpe'))
                  ? ImageSvg(
                      title: title,
                      height: height,
                      width: width,
                      color: color,
                      fit: fit,
                      alignment: alignment)
                  : M.Image(
                      image: AssetImage(
                          '$assetsDirectory/$title${title.contains('.') ? '' : '.png'}'),
                      height: height,
                      width: width,
                      color: color,
                      fit: fit,
                      alignment: alignment);
}

/// Widget which displays image
///
/// Image is assumed to be in [assetsDirectory]. In case if extension is not set '.svg' is
/// automatically prepended.
class ImageSvg extends StatelessWidget {
  final String title;
  final Color color;
  final double width;
  final double height;
  final M.Alignment alignment;
  final M.BoxFit fit;

  ImageSvg(
      {@required this.title,
      double width,
      double height,
      double size,
      this.color,
      this.fit = BoxFit.scaleDown,
      this.alignment = Alignment.center})
      : this.width = width ?? size,
        this.height = height ?? size;

  @override
  Widget build(_) => kIsWeb
      ? M.Image.network(
          '$assetsDirectory/$title${title.contains('.') ? '' : '.svg'}',
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color)
      : SvgPicture.asset(
          '$assetsDirectory/$title${title.contains('.') ? '' : '.svg'}',
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color);
}

class Nothing extends StatelessWidget {
  Nothing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox.shrink();
}

class Page extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final BoxConstraints constraints;

  Page({@required this.child, this.padding, this.color, this.constraints});

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.background,
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(hexagonOpacity), BlendMode.dstATop),
              image: Svg('assets/hexagon.svg', size: Size.hexagon))),
      constraints: constraints ?? BoxConstraints.expand(),
      padding: padding ?? Padding.content,
      child: child);
}

class Screen extends StatelessWidget {
  final Key key;
  final Widget title;
  final Widget child;
  final Widget drawer;
  final Widget leading;
  final Widget trailing;
  final Widget fab;
  final Color color;
  final bool shouldResize;
  final bool shouldHaveAppBar;
  final bool shouldShowDrawer;

  Screen(
      {this.key,
      title,
      this.drawer,
      this.leading,
      this.trailing,
      this.fab,
      this.color,
      this.shouldResize = false,
      this.shouldHaveAppBar = true,
      this.shouldShowDrawer = false,
      @required Widget child,
      Widget footer,
      EdgeInsets padding})
      : assert(title == null || title is String || title is Widget),
        this.title = title == null
            ? null
            : title is Widget
                ? title
                : TextPrimaryTitle(title.toString()),
        child = footer.isNotNull
            ? Column(children: [
                Expanded(
                    child: Page(
                        color: color,
                        child: child,
                        padding: padding ?? Padding.content)),
                footer
              ])
            : Page(
                color: color,
                child: child,
                padding: padding ?? Padding.content),
        super(key: key);

  Widget _buildLeading() => leading != null
      ? leading
      : !Get.rawRoute.isFirst
          ? Clickable(
              child: Icon(Icons.arrow_back_ios, size: Size.iconSmall),
              onPressed: Get.back)
          : drawer != null || shouldShowDrawer
              ? Clickable(
                  child: Icon(Icons.menu, size: Size.icon),
                  onPressed: tabbarScaffoldKey.currentState.openDrawer)
              : null;

  Widget _buildLeadingButton() => leading != null
      ? leading
      : !Get.rawRoute.isFirst
          ? CircularButton(
              size: Size.iconBig,
              background: Colors.transparent,
              borderColor: Colors.primary,
              icon: Icons.arrow_back_ios,
              iconSize: Size.iconTiny,
              onPressed: Get.back)
          : drawer != null || shouldShowDrawer
              ? CircularButton(
                  size: Size.iconBig,
                  background: Colors.transparent,
                  borderColor: Colors.primary,
                  icon: Icons.menu,
                  iconSize: Size.iconTiny,
                  onPressed: () => Scaffold.of(Get.context).openDrawer())
              : null;

  @override
  Widget build(_) => LayoutBuilder(builder: (_, __) {
        Size.init();
        return Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.shadow,
                  blurRadius: screenShadowBlurRadius,
                  spreadRadius: screenShadowSpreadRadius,
                  offset: screenShadowOffset)
            ]),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                    //statusBarColor: Colors.success.withOpacity(.5)
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.light),
                child: SafeArea(
                    child: Scaffold(
                        backgroundColor: Colors.transparent,
                        resizeToAvoidBottomInset: shouldResize,
                        resizeToAvoidBottomPadding: shouldResize,
                        primary: false,
                        appBar: shouldHaveAppBar
                            ? PreferredSize(
                                preferredSize: M.Size.fromHeight(
                                    Size.bar), // here the desired height
                                child: AppBar(
                                    toolbarHeight: Size.bar,
                                    title: title == null
                                        ? null
                                        : _buildLeading() != null
                                            ? title
                                            : Row(children: [
                                                if (_buildLeading() == null)
                                                  HorizontalSpace(),
                                                title
                                              ]),
                                    titleSpacing: 0,
                                    leading: _buildLeading(),
                                    actions: trailing != null
                                        ? [
                                            HorizontalSpace(),
                                            Center(child: trailing),
                                            HorizontalSpace()
                                          ]
                                        : null,
                                    leadingWidth:
                                        Size.icon + Size.horizontal * 2))
                            : null,
                        drawer: drawer,
                        body: ((leading) =>
                            fab == null && (leading == null || shouldHaveAppBar)
                                ? child
                                : Stack(children: [
                                    child,
                                    if (!shouldHaveAppBar && leading != null)
                                      Positioned(
                                          top: Size.vertical + Size.top,
                                          left: Size.horizontal,
                                          child: leading),
                                    if (fab != null)
                                      Positioned(
                                          bottom: Size.vertical,
                                          right: Size.horizontal,
                                          child: fab)
                                  ]))(_buildLeadingButton())
                        //floatingActionButton: fab,
                        //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                        ))));
      });
}

class Loading extends StatelessWidget {
  final double value;
  final Color color;
  Loading({this.value, this.color = Colors.primary});

  bool _isInLoadingRange(double value) =>
      value != null && value > .0 && value < 1.0;

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(
      backgroundColor: color.withOpacity(.5),
      value: _isInLoadingRange(value) ? value : null,
      valueColor: AlwaysStoppedAnimation<Color>(color));
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Page(child: Center(child: Loading()));
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Screen(child: Center(child: Loading()));
}

class TextAnimated extends StatelessWidget {
  final String text;
  final Duration duration;
  TextAnimated(this.text, {this.duration});

  @override
  Widget build(BuildContext context) => TyperAnimatedTextKit(
      isRepeatingAnimation: false,
      speed: duration ?? chatTyperAnimationDuration,
      text: [text],
      textStyle: TextStyle.primary.copyWith(fontSize: Size.fontSmall),
      //displayFullTextOnTap: true,
      //stopPauseOnTap: true
  );
}

class TextError extends StatelessWidget {
  final String text;

  TextError(this.text);

  @override
  Widget build(BuildContext context) => Text(text.tr, style: TextStyle.error);
}

// class TextIndicator extends StatelessWidget {
//   final String text;
//
//   TextIndicator(this.text);
//
//   @override
//   Widget build(BuildContext context) =>
//       Text(text.tr, style: TextStyle.indicator);
// }

class TextPrimary extends StatelessWidget {
  final String text;
  final M.TextStyle style;
  final double size;
  final FontWeight weight;
  final TextAlign align;
  final Color color;

  TextPrimary(this.text,
      {this.style,
      this.size,
      this.weight,
      this.align = TextAlign.left,
      this.color});

  @override
  Widget build(BuildContext context) => Text(text.tr,
      style: TextStyle.primary
          .merge(style)
          .copyWith(color: color, fontSize: size, fontWeight: weight),
      textAlign: align);
}

class TextPrimaryTitle extends TextPrimary {
  TextPrimaryTitle(String text) : super(text, style: TextStyle.title);
}

class TextPrimaryHint extends TextPrimary {
  TextPrimaryHint(String text,
      {Color color, TextAlign align = TextAlign.left, M.TextStyle style})
      : super(text,
            color: color, align: align, weight: FontWeight.w500, style: style);
}

class TextSecondary extends StatelessWidget {
  final String text;
  final M.TextStyle style;
  final double size;
  final TextAlign align;
  final Color color;

  TextSecondary(this.text,
      {this.style, this.size, this.align = TextAlign.left, this.color});

  @override
  Widget build(BuildContext context) => Text(text.tr,
      style: TextStyle.secondary
          .merge(style)
          .copyWith(color: color, fontSize: size),
      textAlign: align);
}

class TextSecondaryActive extends TextSecondary {
  TextSecondaryActive(String text) : super(text, color: Colors.primary);
}

class TextTimer extends TextPrimary {
  TextTimer(String text) : super(text, size: Size.fontTimer);
}

class VerticalTinySpace extends SizedBox {
  VerticalTinySpace() : super(height: Size.verticalTiny);
}

class VerticalSmallSpace extends SizedBox {
  VerticalSmallSpace() : super(height: Size.verticalSmall);
}

class VerticalMediumSpace extends SizedBox {
  VerticalMediumSpace() : super(height: Size.verticalMedium);
}

class VerticalSpace extends SizedBox {
  VerticalSpace() : super(height: Size.vertical);
}

class VerticalBigSpace extends SizedBox {
  VerticalBigSpace() : super(height: Size.verticalBig);
}
