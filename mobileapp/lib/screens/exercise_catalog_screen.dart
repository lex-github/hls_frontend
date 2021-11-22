import 'package:flutter/material.dart' hide Colors, Icon, Image, Padding, Page;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/exercise_catalog_controller.dart';
import 'package:hls/controllers/search_form_controller.dart';
import 'package:hls/helpers/dialog.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/exercise_category_model.dart';
import 'package:hls/models/exercise_model.dart';
import 'package:hls/screens/_form_screen.dart';
import 'package:hls/theme/styles.dart';

class ExerciseCatalogScreen<Controller extends ExerciseCatalogController>
    extends GetView<Controller> {
  ExerciseCatalogScreen() {
    Get.lazyPut(() => SearchFormController<Controller>());
  }

  /// handlers

  _categoryHandler(ExerciseCategoryData data) {
    if (data.children.length > 1 || data.exercises.length > 1)
      return Get.toNamed(exerciseCategoryRoute, arguments: data);

    Get.toNamed(
        data.exercises.first.type == ExerciseType.REALTIME
            ? exerciseRealtimeRoute
            : exerciseRoute,
        arguments: data.exercises.first);
  }

  _itemHandler(ExerciseData data) => Get.toNamed(
      data.type == ExerciseType.REALTIME
          ? exerciseRealtimeRoute
          : exerciseRoute,
      arguments: data);

  /// builders

  Widget _buildHeader() => Column(mainAxisSize: MainAxisSize.min, children: [
        VerticalSpace(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: Size.horizontal),
            child: Input<SearchFormController<Controller>>(
                field: 'search',
                leading: Icon(FontAwesomeIcons.search,
                    color: Colors.disabled, size: .9 * Size.icon)))
      ]);

  Widget _buildLatest() => Nothing();

  Widget _buildCategoryListItem(int index) => ListItemButton(
      imageTitle: controller.list[index].imageUrl,
      imageSize: Size.icon,
      title: controller.list[index].title,
      onPressed: () => _categoryHandler(controller.list[index]));

  Widget _buildListItem(item) => ListItemButton(
      imageTitle: item.imageUrl,
      imageSize: Size.icon,
      title: item.title,
      onPressed: () => _itemHandler(item));

  Widget _buildCategories() {
    int c = 0;
    final ex = List<int>.filled(controller.list.length, 0);
    for (int j = 0; j < alphabet.length; j++) {
      for (int i = 0; i < controller.list.length; i++) {
        if (controller.list[i].title.startsWith(alphabet[j])) {
          ex[c] = i;
          c++;
        }
      }
    }

    return controller.list.isNullOrEmpty
        ? EmptyPage()
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalMedium,
                Size.horizontal, Size.vertical),
            itemCount: c,
            itemBuilder: (_, i) {
              //if (i == 0) return _buildHeader();
              // if (i.isOdd) return VerticalMediumSpace();

              final index = ex[i];
              return Container(
                padding: EdgeInsets.symmetric(vertical: Size.vertical * 0.5),
                child: _buildCategoryListItem(index),
              );
            });
  }

  Widget _buildEmpty() => EmptyPage();

  Widget _buildItems() => controller.items.isNullOrEmpty
      ? _buildEmpty()
      : ListView.builder(
          padding: EdgeInsets.fromLTRB(Size.horizontal, Size.verticalMedium,
              Size.horizontal, Size.vertical),
          //itemCount: controller.foods.length * 2 - 1,
          itemBuilder: (_, i) {
            //if (i == 0) return _buildHeader();
            if (i.isOdd) return VerticalMediumSpace();

            final index = i ~/ 2;

            final data = controller.items.get(index);
            if (data != null) return _buildListItem(data);

            if (controller.hasNextPage) {
              if (controller.isAwaiting && index == controller.items.length)
                return Center(child: Loading());

              if (!controller.isAppending) {
                print('RETRIEVING INDEX $index');
                controller.retrieveItems(shouldAppend: true);
              }
            }

            return null;
          });

  Widget _buildBody() => !controller.isInit ||
          controller.isAwaiting && controller.cursor.isNullOrEmpty
      ? Center(child: Loading())
      : controller.search.isNullOrEmpty
          ? controller.isAwaiting
              ? Center(child: Loading())
              : _buildCategories()
          : _buildItems();

  @override
  Widget build(_) => Screen(
      padding: Padding.zero,
      shouldShowDrawer: true,
      title: exerciseCatalogScreenTitle,
      trailing: Clickable(
          onPressed: () => showConfirm(title: developmentText),
          child: Image(title: 'icons/question')),
      child: GetX<Controller>(
          init: ExerciseCatalogController() as Controller,
          dispose: (_) => Get.delete<SearchFormController<Controller>>(),
          builder: (_) => Column(children: [
                _buildHeader(),
                //_buildLatest(),
                Expanded(child: _buildBody())
              ])));
}
