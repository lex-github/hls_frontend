import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormController extends FormController {
  bool get isAwaiting => AuthService.i.isAwaiting;
  UserData get profile => AuthService.i.profile;

  @override
  List<FormConfig> get config => [
        FormConfig(field: 'name', label: nameProfileLabel, value: profile.name),
        //FormConfig(field: 'date', label: dateProfileLabel),
        FormConfig(
            field: 'height', label: heightProfileLabel, value: profile.height),
        FormConfig(
            field: 'weight', label: weightProfileLabel, value: profile.weight),
        //FormConfig(field: 'email', label: emailProfileLabel, value: profile.email)
      ];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    if (!await updateUser()) {
      error = AuthService.i.message;

      return false;
    }

    return true;
  }

  @override
  onSubmitResponse(bool isSuccess) => null;

  // methods
  Future<bool> updateUser() async {
    if (!await AuthService.i.edit({
      'name': getValue('name'),
      'height': toInt(getValue('height')),
      'weight': toInt(getValue('weight'))
    })) return false;

    // avatar upload
    final pickedFile = getValue<PickedFile>('avatar');
    if (pickedFile != null) if (!await AuthService.i
        .avatar(path: pickedFile.path)) return false;

    return true;
  }
}
