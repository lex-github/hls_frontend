/// {@category screens}
/// Screen to display image.
///
/// See [ImageScreen].
library image_screen;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart'
    hide Colors, Image, Padding, Title, TextStyle;
import 'package:hls/components/generic.dart';
import 'package:hls/theme/styles.dart';
import 'package:photo_view/photo_view.dart';

/// Screen to display image.
///
/// [Image] with [imageUrl] is presented fullscreen with ability to navigate using [PhotoView].
class ImageScreen extends StatelessWidget {
  /// [Screen] title
  final String title;

  /// Can be local asset name or remote url
  final String imageUrl;

  ImageScreen({@required this.imageUrl, this.title});

  Future<String> getImagePath() async {
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    final path = file.path;

    //print('ImageScreen.getImagePath $path');

    return path;
  }

  @override
  Widget build(_) => Screen(
      shouldHaveAppBar: false,
      title: title,
      padding: EdgeInsets.zero,
      child: Container(
          padding: Padding.content,
          //color: Colors.failure,
          child: Hero(
              tag: imageUrl,
              child: Image(
                  fit: BoxFit.contain,
                  title: imageUrl,
                  builder: (_, provider) => PhotoView(
                      backgroundDecoration:
                          BoxDecoration(color: Colors.transparent),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 6.0,
                      initialScale: PhotoViewComputedScale.contained,
                      imageProvider: provider)))));
}
