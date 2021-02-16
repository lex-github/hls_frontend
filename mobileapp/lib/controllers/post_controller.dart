import 'dart:async';

import 'package:get/get.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/models/post_model.dart';

class PostController extends Controller {
  final list = RxList<PostData>();

  @override
  void onInit() async {
    await retrieve();
    super.onInit();
  }

  Future retrieve() async {
    final result = await query(postsQuery);
    print('PostController.retrieve result: $result');

    list.assignAll(
        PaginationData.fromJson(result?.get('posts') ?? {})?.list ?? []);
    update();
  }
}
