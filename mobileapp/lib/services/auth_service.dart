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

  // fields

  final _isInit = false.obs;

  // getters

  String get token => SettingsService.i.token;
  Map<String, String> get headers => {'Authorization': 'Token $token'};

  bool get isInit => _isInit.value;
  bool get isAuthenticated => (profile?.id ?? 0) > 0;

  // profile

  final _profile = Rx<UserData>(null);
  UserData get profile => _profile.value;
  Rx<UserData> get profileReactive => _profile;
  set profile(UserData value) => _profile.value = value;

  // get x implementation

  @override
  void onInit() async {
    super.onInit();

    // hide or show auth form
    ever(_profile, (profile) {
      // print('AuthService.onInit.ever '
      //   '\n\tprofile: $profile'
      //   '\n\tisAuthenticated: $isAuthenticated');

      if (isAuthenticated && Get.currentRoute == authRoute)
        Get.back(canPop: true, closeOverlays: true);
      else if (isInit && Get.currentRoute != authRoute) Get.toNamed(authRoute);
    });

    if (!token.isNullOrEmpty) await retrieve();

    _isInit.value = true;
  }

  // methods

  Future<bool> login(Map<String, dynamic> parameters) async {
    final data = await mutation(authSignInMutation, parameters: parameters);
    if (data.isNullOrEmpty) return null;

    final String token = data.get(['authSignIn', 'authToken']);
    if (token.isNullOrEmpty) return false;

    SettingsService.i.token = token;

    profile = UserData.fromJson(data.get(['authSignIn', 'user']));
    return profile != null;
  }

  Future<UserData> retrieve() async {
    if (SettingsService.i.token.isNullOrEmpty) return null;

    final data = await query(currentUserQuery);
    if (data.isNullOrEmpty) return null;

    profile = UserData.fromJson(data.get('currentUser'));
    return profile;
  }

  Future<bool> logout() async {
    /// TODO: sign out mutation?
    // GraphQLClient client = GraphQLProvider.of(Get.context).value;
    // final result =
    //     await client.mutate(MutationOptions(documentNode: gql(currentUserQuery)));

    SettingsService.i.token = null;
    profile = null;

    return true;
  }
}
