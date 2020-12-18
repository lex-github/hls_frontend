import 'package:get/get.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends Service {
  static SettingsService get i => Get.find<SettingsService>();

  static const _tokenKey = 'token';

  SharedPreferences _preferences;

  @override
  Future init() async {
    _preferences = await SharedPreferences.getInstance();
    _token.value = _preferences.get(_tokenKey);
  }

  // token observable
  final _token = RxString();
  String get token => _token.value;
  set token(String value) {
    value.isNullOrEmpty
        ? _preferences.remove(_tokenKey)
        : _preferences.setString(_tokenKey, value);

    _token.value = value;
  }
}
