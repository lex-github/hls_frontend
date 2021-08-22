import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/_form_controller.dart';

class FoodAddFormController extends FormController {
  static final field = 'field';

  final void Function(int) onFieldChanged;
  FoodAddFormController({this.onFieldChanged});

  @override
  List<FormConfig> get config =>
      [FormConfig(field: field, label: foodAddValueLabel)];

  int get value => getValue(field) ?? -1;
  set value(int value) => onChanged(field, value);

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async => true;

  @override
  onSubmitResponse(_) => null;

  @override
  void onChanged(String field, value,
      {bool shouldUpdate = true, bool shouldUpdateController = true}) {
    super.onChanged(field, value,
        shouldUpdate: shouldUpdate,
        shouldUpdateController: shouldUpdateController);

    if (field != FoodAddFormController.field) return;

    if (onFieldChanged != null)
      onFieldChanged(int.tryParse(value) ?? -1);

    //Get.find<C>().search = value;
  }
}
