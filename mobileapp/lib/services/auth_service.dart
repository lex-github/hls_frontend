import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/screens/profile_screen.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/services/_graphql_service.dart';
import 'package:hls/services/analytics_service.dart';
import 'package:hls/services/settings_service.dart';
import 'package:mime/mime.dart';

class AuthService extends GraphqlService {
  static AuthService get i => Get.find<AuthService>();
  static bool get isAuth => i?.isAuthenticated ?? false;

  // getters

  String get token => SettingsService.i.token;
  Map<String, String> get headers => {'Authorization': 'Token $token'};

  // initialisation
  final _isInit = false.obs;
  bool get isInit => _isInit.value;
  set isInit(bool value) => _isInit.value = value;

  // version
  final _version = '${requestWaitingText.toLowerCase()}...'.obs;
  String get version => _version.value;
  set version(String value) => _version.value = value;

  // profile
  final _profile = Rx<UserData>(null);
  UserData get profile => _profile.value;
  Rx<UserData> get profileReactive => _profile;
  set profile(UserData value) {
    _profile.value = value;
    // TODO: why the fuck these are not updating?
    if (value != null) {
      _profile.value.imageUrl = value.imageUrl;
      _profile.value.details = value.details;
      _profile.value.progress = value.progress;
      _profile.value.daily = value.daily;
      _profile.value.trainings = value.trainings;
    }
    _profile.refresh();
  }

  // authentication
  bool get isAuthenticated => _isAuthenticated.value;
  final _isAuthenticated = false.obs;
  set isAuthenticated(bool value) => _isAuthenticated.value = value;
  RxBool get authenticationState => _isAuthenticated;

  // get x implementation

  @override
  void onInit() async {
    super.onInit();

    // hide or show auth form
    ever<bool>(_isAuthenticated, (isAuthenticated) {
      // final routes = [authRoute];
      final routes = [otpRequestRoute, otpVerifyRoute];

      // print('AuthService.onInit.ever '
      //   '\n\tprofile: $profile'
      //   '\n\tisAuthenticated: $isAuthenticated');

      if (isAuthenticated && routes.contains(Get.currentRoute))
        Get.until(
            (_) => !Get.isDialogOpen && !routes.contains(Get.currentRoute));
      //{ print('AuthService.onInit.ever'); Get.offAllNamed(homeRoute); }
      else if (isInit && !routes.contains(Get.currentRoute))
        Get.toNamed(routes.first);
    });

    print('AuthService.onInit $token');

    if (!token.isNullOrEmpty)
      await retrieve();
    else
      isAuthenticated = false;

    // retrieve api version
    final result = await Get.find<HttpService>().request(HttpRequest(
        path: siteUrl,
        headers: {apiTokenKey: apiTokenValue, authTokenKey: token}));
    version = result.data.get('version');
    print('AuthService.onInit $version');

    isInit = true;
  }

  // methods

  afterLogout() {
    SettingsService.i.token = null;
    SettingsService.i.shouldShowWelcome = true;
    SettingsService.i.shouldSkipChat = false;
    profile = null;
    isAuthenticated = false;
  }

  Future<UserData> retrieve() async {
    if (SettingsService.i.token.isNullOrEmpty) return null;

    final data =
        await query(currentUserQuery, fetchPolicy: FetchPolicy.networkOnly);

    //print('AuthService.retrieve $data');

    if (data.isNullOrEmpty) {
      await logout();
      return null;
    }

    profile = UserData.fromJson(data.get('currentUser'));
    isAuthenticated = (profile?.id ?? 0) > 0;
    return profile;
  }

  Future<bool> otpRequest({String phone}) async {
    final data =
        await mutation(authSendOtpMutation, parameters: {'phone': phone});
    print('AuthService.otpRequest phone: $phone');
    print('AuthService.otpRequest data: $data');

    return data?.get(['authSendOtp', 'status']) == 'ok';
  }

  Future<bool> otpVerify({String phone, String code}) async {
    final data = await mutation(authVerifyOtpMutation,
        parameters: {'phone': phone, 'code': code});
    print('AuthService.otpVerify phone: $phone code: $code');
    print('AuthService.otpVerify data: $data');

    final String token = data.get(['authVerifyOtp', 'authToken']);
    if (token.isNullOrEmpty) return false;

    SettingsService.i.token = token;
    print('AuthService.otpVerify $token');

    profile = UserData.fromJson(data.get(['authVerifyOtp', 'user']));
    isAuthenticated = (profile?.id ?? 0) > 0;
    return profile != null;
  }

  Future<bool> login(Map<String, dynamic> parameters) async {
    final data = await mutation(authSignInMutation, parameters: parameters);
    if (data.isNullOrEmpty) return false;

    final String token = data.get(['authSignIn', 'authToken']);
    if (token.isNullOrEmpty) return false;

    SettingsService.i.token = token;
    print('AuthService.login $token');

    profile = UserData.fromJson(data.get(['authSignIn', 'user']));
    isAuthenticated = (profile?.id ?? 0) > 0;

    if (isAuthenticated)
      AnalyticsService.i.login();

    if (profile != null)
      AnalyticsService.i.user(profile.id.toString());
    
    return profile != null;
  }

  Future<bool> logout() async {
    print('AuthService.logout');

    //final data = await mutation(authSignOutMutation);
    //print('AuthService.logout data: $data');

    await mutation(authSignOutMutation);

    afterLogout();

    return true;
  }

  Future<bool> edit(Map<String, dynamic> parameters) async {
    // retrieve data
    final data =
        await mutation(usersUpdateProfileMutation, parameters: parameters);
    if (data.isNullOrEmpty) return false;

    // parse data
    final Map userJson = data.get(['usersUpdateProfile', 'user']);
    if (userJson.isNullOrEmpty) return false;
    profile = UserData.fromJson(userJson);

    return profile.isValid;
  }

  Future<bool> toggleTraining(DayType type) async {
    final data = await mutation(usersToggleWeeklyTrainingMutation,
        parameters: {'day': type.value});
    if (data.isNullOrEmpty) return false;

    final Map userJson = data.get(['usersToggleWeeklyTraining', 'user']);
    if (userJson.isNullOrEmpty) return false;
    profile = UserData.fromJson(userJson);

    return profile.isValid;
  }

  Future<bool> avatar({@required String path}) async {
    final filename = path.split('/').last;
    final file = File(path);
    final bytes = await file.readAsBytes();
    final length = bytes.length;
    final base64 = base64Encode(bytes);
    final checksum = md5.convert(utf8.encode(base64)).toString();
    final contentType = lookupMimeType(filename);

    final directUploadInput = {
      'filename': filename,
      'byteSize': length,
      'checksum': checksum,
      'contentType': contentType
    };

    final data = await mutation(createDirectUploadMutation,
        parameters: directUploadInput);

    print('AuthService.avatar $data');

    return false;

    // final data =
    // await mutation(usersUpdateProfileMutation, parameters: parameters);
    // if (data.isNullOrEmpty) return false;
    //
    // //print('AuthService.edit $data');
    //
    // final Map userJson = data.get(['usersUpdateProfile', 'user']);
    // if (userJson.isNullOrEmpty) return false;
    //
    // print('AuthService.edit json: $userJson');
    // print('AuthService.edit profile: ${UserData.fromJson(userJson)}');
    //
    // profile = UserData.fromJson(userJson);
    //
    // print('AuthService.edit result: $profile');
    //
    // return profile.isValid;
  }
}
