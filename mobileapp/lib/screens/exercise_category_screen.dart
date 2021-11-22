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

  Widget _buildCategoryListItem(int index) => ListItemButton(
      imageTitle: categories[index].imageUrl,
      imageSize: Size.icon,
      title: categories[index].title,
      onPressed: () => _categoryHandler(categories[index]));

  Widget _buildListItem(int index) => ListItemButton(
      imageTitle: items[index].imageUrl,
      imageSize: Size.icon,
      title: items[index].title,
      onPressed: () => _itemHandler(items[index]));

  Widget _buildEmpty() => EmptyPage();

  Widget _buildCategories() {

    int c = 0;
    final ex = List<int>.filled(categories.length, 0);
    for (int j = 0; j < alphabet.length; j++) {
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].title.startsWith(alphabet[j])) {
          ex[c] = i;
          c++;
        }
      }
    }

    return ListView.builder(
        padding: EdgeInsets.fromLTRB(
            Size.horizontal, Size.verticalMedium, Size.horizontal, Size.vertical),
        itemCount: c,
        itemBuilder: (_, i) {

          final index = ex[i];

          return _buildCategoryListItem(index);
        });
  }

  Widget _buildItems() {

    int c = 0;
    final ex = List<int>.filled(items.length, 0);
    for (int j = 0; j < alphabet.length; j++) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].title.startsWith(alphabet[j])) {
          ex[c] = i;
          c++;
        }
      }
    }

    return ListView.builder(
        padding: EdgeInsets.fromLTRB(
            Size.horizontal, Size.verticalMedium, Size.horizontal, Size.vertical),
        itemCount: c,
        itemBuilder: (_, i) {
          if (i == 0) return _buildHeader();


          final index = ex[i];

          return Container(
            padding: EdgeInsets.symmetric(vertical: Size.vertical * 0.5),
            child: _buildListItem(index),
          );
        });
  }

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
