import 'package:flutter/material.dart' hide Colors, Image, Padding, TextStyle;
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/theme/styles.dart';

class SelectionScreen<Type extends GenericEnum> extends StatelessWidget {
  final List<Type> values;
  final List<Type> initialValue;
  final bool isMultiple;
  final Widget Function(SelectionLogicController<Type>, List<Type>) listBuilder;
  final Widget Function(SelectionLogicController<Type>, Type) itemBuilder;

  SelectionScreen(
      {@required this.values,
      this.initialValue,
      this.isMultiple = false,
      this.listBuilder,
      this.itemBuilder});
  // handlers

  _selectHandler(SelectionLogicController controller, Type item) {
    controller.select(item);

    if (!isMultiple) _submitHandler(controller);
  }

  _submitHandler(SelectionLogicController controller) => Get.back(
      result: isMultiple ? controller.selection : controller.selection.first);

  // builders

  Widget _defaultItemBuilder(SelectionLogicController controller, Type item) =>
      ListItemButton(
          padding: Padding.content,
          onPressed: () => _selectHandler(controller, item),
          isSwitch: true,
          isSelected: controller.isSelected(item),
          child: Row(children: [
            if (!item.imageTitle.isNullOrEmpty) ...[
              ClipRRect(
                  borderRadius: borderRadiusCircular,
                  child: Image(height: Size.iconHuge, title: item.imageTitle)),
              HLSmallSpace()
            ],
            TextPrimary(item.title)
          ]));

  Widget _defaultListBuilder(
          SelectionLogicController controller, List<Type> values) =>
      ListView.builder(
          padding: Padding.content,
          itemCount: values.length * 2 - 1,
          itemBuilder: (context, index) => index.isEven
              ? (itemBuilder ?? _defaultItemBuilder)(
                  controller, values[index ~/ 2])
              : VerticalSpace());

  @override
  Widget build(BuildContext context) => GetBuilder<SelectionLogicController>(
      init: isMultiple
          ? _MultipleLogicController<Type>(selection: initialValue)
          : _SingleLogicController<Type>(selection: initialValue?.first),
      builder: (controller) => Screen(
          padding: Padding.zero,
          title: selectionScreenTitle,
          trailing: isMultiple
              ? Button(
                  icon: Icons.error,
                  size: Size.iconBig,
                  //isDisabled: model.selection == null,
                  onPressed: () => _submitHandler(controller))
              : null,
          child: (listBuilder ?? _defaultListBuilder)(controller, values)));
}

abstract class SelectionLogicController<Type> extends GetxController {
  List<Type> get selection;
  void select(Type value);
  bool isSelected(Type selection);
}

class _SingleLogicController<Type> extends SelectionLogicController<Type> {
  Type _selection;

  _SingleLogicController({Type selection}) : _selection = selection;

  List<Type> get selection => [_selection];
  void select(value) {
    _selection = value;
    update();
  }

  bool isSelected(selection) => _selection == selection;
}

class _MultipleLogicController<Type> extends SelectionLogicController<Type> {
  List<Type> _selection;

  _MultipleLogicController({List<Type> selection})
      : _selection = selection ?? [];

  List<Type> get selection => _selection;
  void select(value) {
    if (_selection.contains(value))
      _selection.remove(value);
    else
      _selection.add(value);
    update();
  }

  bool isSelected(selection) => _selection?.contains(selection) ?? false;
}
