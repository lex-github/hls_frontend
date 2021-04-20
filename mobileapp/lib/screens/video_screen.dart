import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Size, TextStyle;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/food_category_controller.dart';
import 'package:hls/theme/styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends GetView<FoodCategoryController> {
  final String url;

  VideoScreen({this.url});

  // builders

  Widget _buildPlayer(
          VideoScreenController controller) => //VideoPlayer(controller.video)
      YoutubePlayer(
        //width: Size.screenHeight,
        controller: controller.video,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.primary,
        progressColors: ProgressBarColors(
            playedColor: Colors.primary, handleColor: Colors.disabled),
        //onReady: () => controller.listener()
      );

  @override
  Widget build(_) => GetBuilder<VideoScreenController>(
      init: VideoScreenController(url: url),
      builder: (controller) {
        // print('VideoScreen.build '
        //     'aspect: ${controller.video.value.aspectRatio}'
        //     'width: ${controller.video.value.size}');

        return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: Container(color: Colors.black)),
              Transform.scale(
                  scale: Size.screenHeight / Size.screenWidth,
                  child: Transform.rotate(
                      angle: true //controller.video.value.aspectRatio > 1
                          ? pi / 2
                          : .0,
                      child: _buildPlayer(controller))),
              Positioned(
                  top: Size.vertical,
                  right: Size.horizontal,
                  child: CircularButton(
                      child: Icon(Icons.arrow_back_ios, size: Size.iconSmall),
                      onPressed: Get.back))
            ]);

        // return Screen(
        //     padding: Padding.zero,
        //     shouldHaveAppBar: false,
        //     leadingLeft: Size.horizontal - (Size.iconBig - Size.iconSmall) / 2,
        //     leadingTop: Size.vertical + Size.top, // - Size.iconBig / 2,
        //     leading: Clickable(
        //         borderRadius: Size.iconBig / 2,
        //         child: Container(
        //             width: Size.iconBig,
        //             height: Size.iconBig,
        //             child: Center(
        //                 child:
        //                     Icon(Icons.arrow_back_ios, size: Size.iconSmall))),
        //         onPressed: Get.back),
        //     fab: controller.isInit
        //         ? CircularButton(
        //             icon: controller.isPlaying
        //                 ? Icons.pause_circle_outline
        //                 : Icons.play_circle_outline,
        //             size: Size.buttonBig,
        //             iconSize: .90 * Size.buttonBig,
        //             onPressed: () => controller.toggle())
        //         : Nothing(),
        //     child: controller.isInit
        //         ? Stack(alignment: Alignment.center, children: [
        //             Transform.scale(
        //                 scale: Size.screenHeight / Size.screenWidth,
        //                 child: Transform.rotate(
        //                     angle: controller.video.value.aspectRatio > 1
        //                         ? pi / 2
        //                         : .0,
        //                     child: SizedBox(
        //                         width: Size.screenWidth,
        //                         height: Size.screenWidth /
        //                             controller.video.value.aspectRatio,
        //                         child:
        //                         _buildPlayer(controller)
        //                     )))
        //           ])
        //         : LoadingPage());
      });
}

class VideoScreenController extends Controller {
  //final VideoPlayerController video;
  final YoutubePlayerController video;

  final _isPlaying = false.obs;

  VideoScreenController({@required String url})
      :
        //video = VideoPlayerController.network(url, videoPlayerOptions: VideoPlayerOptions())
        video = YoutubePlayerController(
            initialVideoId: 'iLnmTe5Q2Qw',
            flags: YoutubePlayerFlags(autoPlay: true)) {
    //video.addListener(() => _isPlaying.value = video.value.isPlaying);
  }

  //void listener() => video.addListener(this);

  bool get isPlaying => _isPlaying.value;

  void toggle() => video.value.isPlaying ? pause() : play();

  void play() {
    // final duration = video.value.duration;
    // final position = video.value.position;
    // if (duration.compareTo(position) <= 0) video.seekTo(Duration.zero);

    video.play();
  }

  void pause() => video.pause();

  @override
  void onInit() async {
    //await video.initialize();
    play();

    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    super.onInit();
  }

  @override
  void onClose() {
    print('VideoScreenController.onClose');

    video.pause();
    video.dispose();

    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.onClose();
  }
}
