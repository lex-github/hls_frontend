import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends Service {
  static const _tokenKey = 'token';

  SharedPreferences _preferences;

  @override
  Future init() async => _preferences = await SharedPreferences.getInstance();

  String get token => _preferences.getString(_tokenKey);
  set token(String value) => value.isNullOrEmpty
      ? _preferences.remove(_tokenKey)
      : _preferences.setString(_tokenKey, value);
}
