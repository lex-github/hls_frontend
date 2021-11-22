import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/_form_controller.dart';

class SearchFormController<C extends SearchController> extends FormController {
  static final field = 'search';

  @override
  List<FormConfig> get config =>
      [FormConfig(field: field, label: nutritionSearchLabel)];

  String get search => getValue(field);

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

    if (field != SearchFormController.field) return;

    Get.find<C>().search = value;
  }
}
