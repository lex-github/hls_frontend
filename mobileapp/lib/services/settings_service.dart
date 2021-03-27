import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/_service.dart';

class SettingsService extends Service {
  static SettingsService get i => Get.find<SettingsService>();

  static const _tokenKey = 'token';
  static const _shouldShowWelcomeKey = 'shouldShowWelcome';

  final _preferences = GetStorage();

  @override
  Future init() async {
    //_token.value = _preferences.get(_tokenKey);
    _token.value = _preferences.read<String>(_tokenKey);
  }

  // token observable
  final _token = RxString(null);
  String get token => _token.value;
  set token(String value) {
    value.isNullOrEmpty
        ? _preferences.remove(_tokenKey)
        // : _preferences.setString(_tokenKey, value);
        : _preferences.write(_tokenKey, value);

    _token.value = value;
  }

  bool get shouldShowWelcome =>
      // _preferences.getBool(_shouldShowWelcomeKey) ?? true;
      _preferences.read<bool>(_shouldShowWelcomeKey) ?? true;
}
