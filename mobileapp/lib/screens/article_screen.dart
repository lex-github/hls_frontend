import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/food_category_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/post_model.dart';
import 'package:hls/theme/styles.dart';

class ArticleScreen extends GetView<FoodCategoryController> {
  final PostData article;

  ArticleScreen({this.article});

  // builders

  _buildHeader() => Stack(children: [
        Column(children: [
          Hero(
              tag: article.imageUrl,
              child: Image(
                  title: article.imageUrl,
                  width: Size.screenWidth,
                  height: Size.image,
                  fit: BoxFit.cover)),
          Container(
              width: Size.screenWidth,
              padding: EdgeInsets.symmetric(
                  horizontal: Padding.content.left,
                  vertical: 1.25 * Padding.content.top),
              decoration: BoxDecoration(color: Colors.background, boxShadow: [
                BoxShadow(
                    color: Colors.shadow,
                    blurRadius: panelShadowBlurRadius,
                    spreadRadius: panelShadowSpreadRadius,
                    offset: -panelShadowOffset)
              ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPrimaryTitle(article.title, size: 1.2 * Size.fontBig),
                    TextSecondary(dateToString(date: article.date))
                  ]))
        ]),
        // Positioned(
        //   right: Size.horizontal,
        //   top: Size.image - Size.buttonBig / 2,
        //   child: CircularButton(
        //       icon: Icons.favorite,
        //       size: Size.buttonBig,
        //       iconSize: .45 * Size.buttonBig,
        //       onPressed: (_) => null))
      ]);

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldHaveAppBar: false,
      leadingLeft: Size.horizontal - (Size.iconBig - Size.iconSmall) / 2,
      leadingTop: Size.vertical + Size.top, // - Size.iconBig / 2,
      leading: Clickable(
          borderRadius: Size.iconBig / 2,
          child: Container(
              width: Size.iconBig,
              height: Size.iconBig,
              child: Center(
                  child: Icon(Icons.arrow_back_ios, size: Size.iconSmall))),
          onPressed: Get.back),
      child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildHeader(),
        if (article.texts.isNullOrEmpty)
          Center(
              child: Container(
                  padding: Padding.content, child: TextSecondary(noDataText)))
        else ...[
          VerticalSpace(),
          for (final text in article.texts) ...[
            Container(
                padding: EdgeInsets.symmetric(horizontal: Padding.content.left),
                child: TextPrimaryHint(text)),
            if (text != article.texts.last) VerticalSpace()
          ],
          VerticalSpace()
        ]
      ])));
}
