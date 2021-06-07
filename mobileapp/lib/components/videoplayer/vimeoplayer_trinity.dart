library vimeoplayer;

import 'package:flutter/material.dart' hide Icon, Colors;
import 'package:hls/components/generic.dart';
import 'package:hls/theme/styles.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'src/quality_links.dart';
import 'dart:async';
import 'src/fullscreen_player.dart';

//Класс видео плеера
class VimeoPlayer extends StatefulWidget {
  final String id;
  final bool autoPlay;
  final bool looping;
  final int position;
  // final double videoPosition;
  final Color loaderColor;
  final Color controlColor;
  final Color playedColor;
  final Color bufferedColor;

  VimeoPlayer({
    @required this.id,
    this.autoPlay = false,
    this.looping = false,
    this.position,
    // this.videoPosition,
    this.loaderColor,
    this.controlColor,
    this.playedColor,
    this.bufferedColor,
    Key key,
  }) : super(key: key);

  @override
  _VimeoPlayerState createState() => _VimeoPlayerState(id, autoPlay, looping,
      position, 0, loaderColor, controlColor, bufferedColor, playedColor);
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  String _id;
  bool autoPlay = false;
  bool looping = false;
  bool _overlay = true;
  bool fullScreen = false;
  double _videoPosition;
  Color _loaderColor;
  Color _controlColor;
  Color _playedColor;
  Color _bufferedColor;
  int position;

  _VimeoPlayerState(
      this._id,
      this.autoPlay,
      this.looping,
      this.position,
      this._videoPosition,
      this._loaderColor,
      this._controlColor,
      this._bufferedColor,
      this._playedColor);

  //Custom controller
  VideoPlayerController _controller;
  Future<void> initFuture;

  //Quality Class
  QualityLinks _quality;
  Map _qualityValues;
  var _qualityValue;

  //Переменная перемотки
  bool _seek = false;

  //Переменные видео
  double videoHeight;
  double videoWidth;
  double videoMargin;

  //Переменные под зоны дабл-тапа
  double doubleTapRMargin = 36;
  double doubleTapRWidth = 400;
  double doubleTapRHeight = 160;
  double doubleTapLMargin = 10;
  double doubleTapLWidth = 400;
  double doubleTapLHeight = 160;

  @override
  void initState() {
    //Create class
    _quality = QualityLinks(_id);

    //Инициализация контроллеров видео при получении данных из Vimeo
    _quality.getQualitiesSync().then((value) {
      _qualityValues = value;
      _qualityValue = value[value.lastKey()];
      _controller = VideoPlayerController.network(_qualityValue);
      _controller.setLooping(looping);

      _controller.addListener(_onPlay);

      if (autoPlay) _controller.play();
      initFuture = _controller.initialize();

      //Обновление состояние приложения и перерисовка
      setState(() {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      });
    });

    //На странице видео преимущество за портретной ориентацией
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.initState();
  }

  _onPlay() {
    print(
        'VimeoPlayer._onPlay position: ${_controller.value.position.inSeconds}');
  }

  //Отрисовываем элементы плеера
  @override
  Widget build(BuildContext context) {
    _videoPosition = _videoPosition == null ? 155 : _videoPosition;
    _loaderColor = _loaderColor == null ? Colors.primary : _loaderColor;
    return SizedBox(
        height: videoHeight,
        width: videoWidth,
        child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          GestureDetector(
            child: FutureBuilder(
                future: initFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //Управление шириной и высотой видео
                    double delta = MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.height *
                            _controller.value.aspectRatio;

                    //Рассчет ширины и высоты видео плеера относительно сторон
                    // и ориентации устройства
                    if (MediaQuery.of(context).orientation ==
                            Orientation.portrait ||
                        delta < 0) {
                      videoHeight = MediaQuery.of(context).size.width /
                          _controller.value.aspectRatio;
                      videoWidth = MediaQuery.of(context).size.width;
                      videoMargin = 0;
                    } else {
                      videoHeight = MediaQuery.of(context).size.height;
                      videoWidth = videoHeight * _controller.value.aspectRatio;
                      videoMargin =
                          (MediaQuery.of(context).size.width - videoWidth) / 2;
                    }

                    //Начинаем с того же места, где и остановились при смене качества
                    if (_seek && _controller.value.duration.inSeconds > 2) {
                      _controller.seekTo(Duration(seconds: position));
                      _seek = false;
                    }

                    //Отрисовка элементов плеера
                    return Stack(
                      children: <Widget>[
                        Container(
                          height: videoHeight,
                          width: videoWidth,
                          margin: EdgeInsets.only(
                              left: videoMargin, top: _videoPosition),
                          child: VideoPlayer(_controller),
                        ),
                        _videoOverlay(),
                      ],
                    );
                  } else {
                    return Center(
                        heightFactor: 6,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_loaderColor),
                        ));
                  }
                }),
            onTap: () {
              //Редактируем размер области дабл тапа при показе оверлея.
              // Сделано для открытия кнопок "Во весь экран" и "Качество"
              setState(() {
                _overlay = !_overlay;
                if (_overlay) {
                  doubleTapRHeight = videoHeight - 36;
                  doubleTapLHeight = videoHeight - 10;
                  doubleTapRMargin = 36;
                  doubleTapLMargin = 10;
                } else if (!_overlay) {
                  doubleTapRHeight = videoHeight + 36;
                  doubleTapLHeight = videoHeight + 16;
                  doubleTapRMargin = 0;
                  doubleTapLMargin = 0;
                }
              });
            },
          ),
          GestureDetector(
              //======= Перемотка назад =======//
              child: Container(
                width: doubleTapLWidth / 2 - 30,
                height: doubleTapLHeight - 46,
                margin: EdgeInsets.fromLTRB(
                    0, 10, doubleTapLWidth / 2 + 30, doubleTapLMargin + 20),
                decoration: BoxDecoration(
                    //color: Colors.red,
                    ),
              ),

              // Изменение размера блоков дабл тапа. Нужно для открытия кнопок
              // "Во весь экран" и "Качество" при включенном overlay
              onTap: () {
                setState(() {
                  _overlay = !_overlay;
                  if (_overlay) {
                    doubleTapRHeight = videoHeight - 36;
                    doubleTapLHeight = videoHeight - 10;
                    doubleTapRMargin = 36;
                    doubleTapLMargin = 10;
                  } else if (!_overlay) {
                    doubleTapRHeight = videoHeight + 36;
                    doubleTapLHeight = videoHeight + 16;
                    doubleTapRMargin = 0;
                    doubleTapLMargin = 0;
                  }
                });
              },
              onDoubleTap: () {
                setState(() {
                  _controller.seekTo(Duration(
                      seconds: _controller.value.position.inSeconds - 10));
                });
              }),
          GestureDetector(
              child: Container(
                //======= Перемотка вперед =======//
                width: doubleTapRWidth / 2 - 45,
                height: doubleTapRHeight - 60,
                margin: EdgeInsets.fromLTRB(doubleTapRWidth / 2 + 45,
                    doubleTapRMargin, 0, doubleTapRMargin + 20),
                decoration: BoxDecoration(
                    //color: Colors.red,
                    ),
              ),
              // Изменение размера блоков дабл тапа. Нужно для открытия кнопок
              // "Во весь экран" и "Качество" при включенном overlay
              onTap: () {
                setState(() {
                  _overlay = !_overlay;
                  if (_overlay) {
                    doubleTapRHeight = videoHeight - 36;
                    doubleTapLHeight = videoHeight - 10;
                    doubleTapRMargin = 36;
                    doubleTapLMargin = 10;
                  } else if (!_overlay) {
                    doubleTapRHeight = videoHeight + 36;
                    doubleTapLHeight = videoHeight + 16;
                    doubleTapRMargin = 0;
                    doubleTapLMargin = 0;
                  }
                });
              },
              onDoubleTap: () {
                setState(() {
                  _controller.seekTo(Duration(
                      seconds: _controller.value.position.inSeconds + 10));
                });
              })
        ]));
  }

  //================================ Quality ================================//
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          //Формирования списка качества
          final children = <Widget>[];
          _qualityValues.forEach((elem, value) => (children.add(ListTile(
              title:
                  TextPrimary(" ${elem.toString()} fps", size: Size.fontSmall),
              onTap: () => {
                    //Обновление состояние приложения и перерисовка
                    setState(() {
                      _controller.pause();
                      _qualityValue = value;
                      _controller =
                          VideoPlayerController.network(_qualityValue);
                      _controller.setLooping(looping);

                      _controller.addListener(_onPlay);

                      _seek = true;
                      initFuture = _controller.initialize();
                      _controller.play();
                    }),
                  }))));
          //Вывод элементов качество списком
          return Container(
            child: Wrap(
              children: children,
            ),
          );
        });
  }

  //================================ OVERLAY ================================//
  Widget _videoOverlay() {
    return _overlay
        ? Stack(
            children: <Widget>[
              GestureDetector(
                child: Center(
                  child: Container(
                    width: videoWidth,
                    height: videoHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          const Color(0x662F2C47),
                          const Color(0x662F2C47)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: IconButton(
                    padding: EdgeInsets.only(
                        top: videoHeight / 2 - 30,
                        bottom: videoHeight / 2 - 30),
                    icon: _controller.value.isPlaying
                        ? Icon(Icons.pause, size: 60.0, color: _controlColor)
                        : Icon(Icons.play_arrow,
                            size: 60.0, color: _controlColor),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: videoHeight - 70 + _videoPosition,
                    left: videoWidth + videoMargin - 50),
                child: IconButton(
                    alignment: AlignmentDirectional.center,
                    icon: Icon(Icons.fullscreen,
                        size: 30.0, color: _controlColor),
                    onPressed: () async {
                      setState(() {
                        _controller.pause();
                      });
                      //Создание новой страницы с плеером во весь экран,
                      // предача данных в плеер и возвращение позиции при
                      // возвращении обратно. Пока что мы не вернулись из
                      // фуллскрина - программа в ожидании
                      position = await Navigator.push(
                          context,
                          PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  FullscreenPlayer(
                                    id: _id,
                                    autoPlay: true,
                                    controller: _controller,
                                    position:
                                        _controller.value.position.inSeconds,
                                    initFuture: initFuture,
                                    qualityValue: _qualityValue,
                                    controlColor: _controlColor,
                                    loaderColor: _loaderColor,
                                    bufferedColor: _bufferedColor,
                                    playedColor: _playedColor,
                                  ),
                              transitionsBuilder: (___,
                                  Animation<double> animation,
                                  ____,
                                  Widget child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                      scale: animation, child: child),
                                );
                              }));
                      setState(() {
                        _controller.play();
                        _seek = true;
                      });
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: videoWidth + videoMargin - 48, top: _videoPosition),
                child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 26.0,
                      color: _controlColor,
                    ),
                    onPressed: () {
                      position = _controller.value.position.inSeconds;
                      _seek = true;
                      _settingModalBottomSheet(context);
                      setState(() {});
                    }),
              ),
              Container(
                //===== Ползунок =====//
                margin: EdgeInsets.only(
                    top: videoHeight - 26, left: videoMargin), //CHECK IT
                child: _videoOverlaySlider(),
              )
            ],
          )
        : Center(
            child: Container(
              height: 5,
              width: videoWidth,
              margin: EdgeInsets.only(top: videoHeight - 5),
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: _playedColor,
                  backgroundColor: Color(0x5515162B),
                  bufferedColor: _bufferedColor,
                ),
                padding: EdgeInsets.only(top: 2),
              ),
            ),
          );
  }

  //=================== ПОЛЗУНОК ===================//
  Widget _videoOverlaySlider() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, VideoPlayerValue value, child) {
        if (!value.hasError && value.isInitialized) {
          return Row(
            children: <Widget>[
              Container(
                width: 46,
                alignment: Alignment(0, 0),
                child: TextPrimary(
                    '${_asTwoDigits(value.position.inMinutes)}:${_asTwoDigits(value.position.inSeconds - value.position.inMinutes * 60)}',
                    size: Size.fontSmall),
              ),
              Container(
                height: 20,
                width: videoWidth - 92,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Color(0xFF22A3D2),
                    backgroundColor: Color(0x5515162B),
                    bufferedColor: _bufferedColor,
                  ),
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
              ),
              Container(
                width: 46,
                alignment: Alignment(0, 0),
                child: TextPrimary(_formatDuration(value.duration.inSeconds),
                    size: Size.fontSmall),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _asTwoDigits(int n) => n?.toString()?.padLeft(2, '0') ?? '';

  String _formatDuration(int seconds) {
    int secondsLeft = (seconds % 60).toInt();
    int minutes = (seconds / 60).toInt();
    int hours = (minutes / 60).toInt();
    int minutesLeft = minutes - (hours * 60);
    return "${_asTwoDigits(minutesLeft)}:${_asTwoDigits(secondsLeft)}";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}