import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';

class SearchFormController extends FormController {
  static final field = 'search';

  @override
  List<FormConfig> get config =>
      [FormConfig(field: field, label: nutritionSearchLabel)];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async => null;

  @override
  onSubmitResponse(_) => null;
}
