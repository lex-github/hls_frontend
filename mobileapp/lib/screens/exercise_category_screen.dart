import 'package:flutter/material.dart' hide Colors, Icon, Image, Padding, Page;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_category_model.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/theme/styles.dart';

class ExerciseCategoryScreen extends StatefulWidget {
  @override
  _State createState() => _State(category: Get.arguments);
}

class _State extends State<ExerciseCategoryScreen> {
  final ExerciseCategoryData category;

  _State({this.category}) : super();

  List<ExerciseCategoryData> get categories => category.children;
  List<ExerciseData> get items => category.exercises;

  /// handlers

  _categoryHandler(ExerciseCategoryData data) =>
      Get.toNamed(exerciseCategoryRoute, arguments: data);

  _itemHandler(ExerciseData data) => Get.toNamed(
      data.type == ExerciseType.REALTIME
          ? exerciseRealtimeRoute
          : exerciseRoute,
      arguments: data);

  /// builders

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalMediumSpace(),
        TextPrimary(category?.title),
        VerticalSpace(),
        VerticalMediumSpace()
      ]);

  Widget _buildCategoryListItem(ExerciseCategoryData item) => ListItemButton(
      imageTitle: item.imageUrl,
      imageSize: Size.icon,
      title: item.title,
      onPressed: () => _categoryHandler(item));

  Widget _buildListItem(ExerciseData item) => ListItemButton(
      imageTitle: item.imageUrl,
      imageSize: Size.icon,
      title: item.title,
      onPressed: () => _itemHandler(item));

  Widget _buildEmpty() => EmptyPage();

  Widget _buildCategories() => ListView.builder(
      padding: EdgeInsets.fromLTRB(
          Size.horizontal, Size.verticalMedium, Size.horizontal, Size.vertical),
      itemCount: categories.length * 2 - 1,
      itemBuilder: (_, i) {
        if (i.isOdd) return VerticalMediumSpace();

        final index = i ~/ 2;

        return _buildCategoryListItem(categories[index]);
      });

  Widget _buildItems() => ListView.builder(
      padding: EdgeInsets.fromLTRB(
          Size.horizontal, Size.verticalMedium, Size.horizontal, Size.vertical),
      itemCount: items.length * 2,
      itemBuilder: (_, i) {
        if (i == 0) return _buildHeader();

        if (i.isEven) return VerticalMediumSpace();

        final index = i ~/ 2;

        return _buildListItem(items[index]);
      });

  Widget _buildBody() => category == null
      ? _buildEmpty()
      : !category.children.isNullOrEmpty
          ? _buildCategories()
          : !category.exercises.isNullOrEmpty
              ? _buildItems()
              : _buildEmpty();

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: exerciseCatalogScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Image(title: 'icons/question')),
      child: _buildBody());
}
