import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/services/_service.dart';

class GraphqlService extends Service {
  static GraphqlService get i => Get.find<GraphqlService>();

  Future<GraphQLClient> client() async {
    // this might be a bit bold
    while (Get.context == null) await Future.delayed(defaultAnimationDuration);

    return GraphQLProvider.of(Get.context).value;
  }

  Future<Map<String, dynamic>> query(String node,
      {Map<String, dynamic> parameters}) async {
    isAwaiting = true;
    final client = await this.client();
    final result = await client
        .query(QueryOptions(documentNode: gql(node), variables: parameters));
    isAwaiting = false;
    return result.data;
  }

  Future<Map<String, dynamic>> mutation(String node,
      {Map<String, dynamic> parameters}) async {
    isAwaiting = true;
    final client = await this.client();
    final result = await client.mutate(
        MutationOptions(documentNode: gql(node), variables: parameters));
    isAwaiting = false;
    return result.data;
  }
}
