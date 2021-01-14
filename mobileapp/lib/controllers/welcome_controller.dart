import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/services/auth_service.dart';

class WelcomeController extends GetxController {
  final _slides = <SlideData>[
    SlideData(imageTitle: 'slider/workout', text: slide1Text),
    SlideData(imageTitle: 'slider/healthy_options', text: slide2Text),
    SlideData(imageTitle: 'slider/healthy_lifestyle', text: slide3Text),
    SlideData(imageTitle: 'slider/activity_tracker', text: slide4Text),
    SlideData(imageTitle: 'slider/shopping_app', text: slide5Text),
    SlideData(imageTitle: 'slider/questions', text: slide6Text),
    SlideData(imageTitle: 'slider/energizer', text: slide7Text)
  ];

  // current index
  final _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index(value);

  int get length => _slides.length;
  SlideData get slide => _slides[index];

  next() => index < _slides.length - 1
      ? index += 1
      : (AuthService.isAuth ? Get.back() : Get.offNamed(otpRequestRoute));
}

class SlideData {
  final String imageTitle;
  final String text;

  SlideData({@required this.imageTitle, @required this.text});
}
