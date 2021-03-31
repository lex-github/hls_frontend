import 'package:hls/constants/api.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/controllers/_form_controller.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormController extends FormController {
  UserData get profile => AuthService.i.profile;

  @override
  List<FormConfig> get config => [
        FormConfig(field: 'name', label: nameProfileLabel, value: profile.name),
        FormConfig(
            field: 'birthDate',
            label: dateProfileLabel,
            value: profile.birthDate,
            type: FieldType.DATE_PICKER,
            toRepresentation: (date) => dateToString(date: date)),
        FormConfig(
            field: 'height', label: heightProfileLabel, value: profile.height),
        FormConfig(
            field: 'weight', label: weightProfileLabel, value: profile.weight),
        FormConfig(field: 'email', label: emailProfileLabel, value: profile.email)
      ];

  // form controller implementation

  @override
  Future<bool> onSubmitRequest() async {
    // avatar upload
    final pickedFile = getValue<PickedFile>('avatar');
    // if (pickedFile != null) if (!await AuthService.i
    //     .avatar(path: pickedFile.path)) return false;
    if (pickedFile != null) {
      // prepare request
      final request = new http.MultipartRequest(
          'POST', Uri.parse('${siteUrl}api/$avatarUploadPath'));
      request.headers[apiTokenKey] = apiTokenValue;
      request.headers[authTokenKey] = AuthService.i.token;
      request.files.add(await http.MultipartFile.fromPath(
          'photo', pickedFile.path,
          contentType: MediaType('multipart', 'form-data')
      ));

      // perform upload
      final result = await request.send();
      // print('ProfileFormController.updateUser '
      //     '\n\tcode: ${result.statusCode}'
      //     '\n\treason: ${result.reasonPhrase}');

      // check for errors
      if (result.statusCode != 200) {
        error =
            'File upload error: code ${result.statusCode}; reason: ${result.reasonPhrase}';

        return false;
      }
    }

    if (!await AuthService.i.edit({
      'name': getValue('name'),
      'birthDate':
      dateToString(date: getValue('birthDate'), output: dateInternalFormat),
      'height': toInt(getValue('height')),
      'weight': toInt(getValue('weight'))
    })) {
      error = AuthService.i.message;

      return false;
    }

    return true;
  }

  @override
  onSubmitResponse(bool isSuccess) => null;
}
