import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/_service.dart';

class SettingsService extends Service {
  static SettingsService get i => Get.find<SettingsService>();

  static const _tokenKey = 'token';
  static const _shouldShowWelcomeKey = 'shouldShowWelcome';
  static const _shouldSkipChatKey = 'shouldSkipChat';

  final _preferences = GetStorage();

  @override
  Future init() async {
    //_token.value = _preferences.get(_tokenKey);
    _token.value = _preferences.read<String>(_tokenKey);

    // print('SettingsService.init '
    //     '\n\tkeys: ${_preferences.getKeys()}'
    //     '\n\tvalues: ${_preferences.getValues()}');
  }

  // token observable
  final _token = RxString(null);
  String get token => _token.value;
  set token(String value) {
    print('SettingsService.setToken $value');

    value.isNullOrEmpty
        ? _preferences.remove(_tokenKey)
        // : _preferences.setString(_tokenKey, value);
        : _preferences.write(_tokenKey, value);

    _token.value = value;
  }

  // welcome slides
  bool get shouldShowWelcome =>
      // _preferences.getBool(_shouldShowWelcomeKey) ?? true;
      _preferences.read<bool>(_shouldShowWelcomeKey) ?? true;
  set shouldShowWelcome(bool value) =>
      _preferences.write(_shouldShowWelcomeKey, value);

  // chat skip
  bool get shouldSkipChat =>
      _preferences.read<bool>(_shouldSkipChatKey) ?? false;
  set shouldSkipChat(bool value) =>
      _preferences.write(_shouldSkipChatKey, value);
}
