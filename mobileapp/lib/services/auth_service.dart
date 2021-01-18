import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/graphql_service.dart';
import 'package:hls/services/settings_service.dart';

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

  // profile
  // final _profile = Rx<UserData>(null);
  // UserData get profile => _profile.value;
  // Rx<UserData> get profileReactive => _profile;
  // set profile(UserData value) => _profile.value = value;
  UserData profile;

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

    if (!token.isNullOrEmpty) await retrieve();
    else isAuthenticated = false;

    isInit = true;
  }

  // methods

  Future<UserData> retrieve() async {
    if (SettingsService.i.token.isNullOrEmpty) return null;

    final data = await query(currentUserQuery);
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
    return profile != null;
  }

  Future<bool> logout() async {
    final data = await mutation(authSignOutMutation);
    print('AuthService.logout $data');

    SettingsService.i.token = null;
    profile = null;
    isAuthenticated = false;

    return true;
  }
}
