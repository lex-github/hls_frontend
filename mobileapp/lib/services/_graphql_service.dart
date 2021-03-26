import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/_service.dart';
import 'package:hls/services/auth_service.dart';

class GraphqlService extends Service {
  static GraphqlService get i => Get.find<GraphqlService>();

  // messages
  GraphQLError _error;
  GraphQLError get error => _error;
  String get message => error.message;

  Future<GraphQLClient> client() async {
    // this might be a bit bold
    while (Get.context == null) await Future.delayed(defaultAnimationDuration);

    return GraphQLProvider.of(Get.context).value;
  }

  Future<Map<String, dynamic>> query(String node,
      {Map<String, dynamic> parameters, FetchPolicy fetchPolicy}) async {
    isAwaiting = true;
    final client = await this.client();
    final result = await client.query(QueryOptions(
        document: gql(node), variables: parameters, fetchPolicy: fetchPolicy));
    isAwaiting = false;

    if (isDebug)
      debugPrint('GraphqlService.query'
          '\n\tnode $node'
          '\n\tparameters $parameters'
          '\n\tresult ${result.data}');

    if (result.hasException) {
      if (result?.exception?.graphqlErrors?.isNullOrEmpty ?? false)
        return null;

      _error = result.exception?.graphqlErrors?.first;
      print('GraphqlService.query ERROR: $_error');
      //showConfirm(title: result.exception.toString());

      if (_error.status == errorNotAuthorized) {
        await AuthService.i.afterLogout();
        return null;
      }
    }

    return result.data;
  }

  Future<Map<String, dynamic>> mutation(String node,
      {Map<String, dynamic> parameters}) async {
    isAwaiting = true;
    final client = await this.client();

    try {
      final result = await client.mutate(MutationOptions(
          document: gql(node),
          variables: parameters,
          fetchPolicy: FetchPolicy.networkOnly));

      isAwaiting = false;

      if (isDebug)
        debugPrint('GraphqlService.mutation'
            '\n\tnode $node'
            '\n\tparameters $parameters'
            '\n\tresult ${result.data}');

      if (result.hasException) {
        /// TODO: write message extractor
        _error = result.exception?.graphqlErrors?.first;
        print('GraphqlService.mutation ERROR: $_error');

        // if (message.contains('User is required') && AuthService.isAuth) {
        //   await Future.delayed(defaultAnimationDuration);
        //   return mutation(node, parameters: parameters);
        // }

        if (_error.status == errorNotAuthorized) {
          await AuthService.i.afterLogout();
          return null;
        }
      }

      return result.data;
    } catch (e) {
      print('GraphqlService.mutation $e');

      _error = GraphQLError(message: e.toString());

      return null;
    }
  }
}
