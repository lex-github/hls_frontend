import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/models/user_model.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/services/_service.dart';
import 'package:hls/services/settings_service.dart';

class AuthService extends Service {
  static AuthService get i => Get.find<AuthService>();
  static bool get isAuth => i?.isAuthenticated ?? false;

  // fields

  final _isInit = false.obs;

  // getters

  String get token => Get.find<SettingsService>()?.token;
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

  Future<HttpResponse> login(Map<String, String> parameters) async {
    return null;
    // final HttpService service = Get.find();
    // final response = await service.request(HttpRequest(
    //     path: authEndpoint,
    //     method: RequestMethod.POST,
    //     parameters: parameters));
    // return response;
  }

  Future<UserData> retrieve() async {
    if (SettingsService.i.token.isNullOrEmpty) return null;

    // this might be a bit bold
    while (Get.context == null) await Future.delayed(defaultAnimationDuration);

    GraphQLClient client = GraphQLProvider.of(Get.context).value;
    final result =
        await client.query(QueryOptions(documentNode: gql(currentUserQuery)));

    // print('AuthService.retrieve '
    //     '\n\t${result.exception}'
    //     '\n\t${result.data}');

    if (!(result.data as Map).isNullOrEmpty)
      _profile.value =
          UserData.fromJson((result.data as Map).get('currentUser'));

    return profile;
  }

  Future<bool> logout() async {
    /// TODO: sign out mutation?
    // GraphQLClient client = GraphQLProvider.of(Get.context).value;
    // final result =
    //     await client.mutate(MutationOptions(documentNode: gql(currentUserQuery)));

    SettingsService.i.token = null;
    _profile.value = null;

    return true;
  }
}
