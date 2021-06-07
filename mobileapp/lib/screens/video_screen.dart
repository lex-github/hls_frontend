import 'dart:math';

import 'package:flutter/material.dart'
    hide Colors, Icon, Image, Padding, Size, TextStyle;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/food_category_controller.dart';
import 'package:hls/theme/styles.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends GetView<FoodCategoryController> {
  final String url;

  VideoScreen({this.url});

  // builders

  Widget _buildPlayer(
          VideoScreenController controller) =>
      VideoPlayer(controller.video);

      // YoutubePlayer(
      //   //width: Size.screenHeight,
      //   aspectRatio: 9 / 16,
      //   controller: controller.video,
      //   showVideoProgressIndicator: true,
      //   progressIndicatorColor: Colors.primary,
      //   progressColors: ProgressBarColors(
      //       playedColor: Colors.primary, handleColor: Colors.disabled),
      //   //onReady: () => controller.listener()
      // );

  @override
  Widget build(_) => GetBuilder<VideoScreenController>(
      init: VideoScreenController(
        url: 'https://s206vla.storage.yandex.net/rdisk/f581bfec3a33f22558708c6c60ed582aa8d9b94de4d86bcdef24bdb2e14bd9dd/60bde934/E2wW4-d6tTbo-XQFBLCdmPBdCCuDoFRfyvtySxjzH0kJb7NeQOib6Ony0ORRAPsoD3m4ntOpVvI-ovsjYXFt4g==?uid=1130000038736901&filename=%D0%A8%D0%B5%D0%B9%D0%BF%D0%B8%D0%BD%D0%B3%20%D0%9B%D0%B5%D1%82%D0%BE.mp4&disposition=attachment&hash=&limit=0&content_type=video%2Fmp4&owner_uid=1130000038736901&fsize=2372651125&hid=8fbcecd2499a17044188ce0545192c4f&media_type=video&tknv=v2&etag=6c116928f7a70d1870d74f3aa972c848&rtoken=GYQL7ttW3X22&force_default=yes&ycrid=na-852e7bdfbda894c1c3b104143059728c-downloader10h&ts=5c429cfa5b500&s=97028a89ea08ec7dc030c79389e69c9b2f43c24cd63c44ed44377df80e6c7e68&pb=U2FsdGVkX1-j3HXpUEqOU37DIxMHLYtIZR993x_fUFQrol2uDZZJArI9VgK4jzE7AqmmW0PDUivPPPZPQE9oe13kAFex6SOuQqNInPgb8bw'
        //url: url
      ),
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
                  scale: 1,//Size.screenHeight / Size.screenWidth,
                  child: Transform.rotate(
                      angle: false //controller.video.value.aspectRatio > 1
                          ? pi / 2
                          : .0,
                      child: _buildPlayer(controller))),
              Positioned(
                  top: Size.vertical,
                  right: Size.horizontal,
                  child: CircularButton(
                      child: Icon(FontAwesomeIcons.arrowLeft, size: Size.icon),
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
        //                     Icon(Icons.arrow_back, size: Size.icon))),
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
  final VideoPlayerController video;
  //final YoutubePlayerController video;

  final _isPlaying = false.obs;

  VideoScreenController({@required String url})
      :
        video = VideoPlayerController.network(url, videoPlayerOptions: VideoPlayerOptions())
        // video = YoutubePlayerController(
        //     //initialVideoId: 'iLnmTe5Q2Qw',
        //     initialVideoId: 'EXo_1J4nzO4',
        //     flags: YoutubePlayerFlags(autoPlay: true))
  {
    video.addListener(() => _isPlaying.value = video.value.isPlaying);
  }

  //void listener() => video.addListener(this);

  bool get isPlaying => _isPlaying.value;

  void toggle() => video.value.isPlaying ? pause() : play();

  void play() {
    final duration = video.value.duration;
    final position = video.value.position;
    if (duration.compareTo(position) <= 0) video.seekTo(Duration.zero);

    video.play();
  }

  void pause() => video.pause();

  @override
  void onInit() async {
    await video.initialize();
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
