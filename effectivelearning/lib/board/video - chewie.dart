import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage();
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  static final file = new File("/data/data/com.example.effectivelearning/files/" +
      glob['lesson']['id'] +
      ".mv4");
  static final _controller = VideoPlayerController.file(file);

  final chewieController = ChewieController(
    videoPlayerController: _controller,
    aspectRatio: 3 / 2,
    autoPlay: true,
    looping: true,
  );

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = glob['lesson']['video_url'];
    return SubRipCaptionFile(fileContents);
  }

  void checkVideo() {
    if (_controller.value.hasError) {
      zlog(":::::::::::::::: HERE ERROR GOES :::::::::::::::::::");
      var map = new Map<String, dynamic>();
      map['lesson_id'] = glob['lesson']['id'];

      post('done_lesson', map);
      retPage(context);
      retPage(context);
      gotoPage(context, CoursePage());
    }
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      zlog('video Started');
    }

    if (_controller.value.position == _controller.value.duration) {
      zlog('video Ended');

      var map = new Map<String, dynamic>();
      map['lesson_id'] = glob['lesson']['id'];

      post('done_lesson', map).then((value) {
        retPage(context);
        retPage(context);
        gotoPage(context, CoursePage());
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(checkVideo);
    _controller.setVolume(1.0);
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
          body: Container(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Chewie(controller: chewieController,),
                  ClosedCaption(text: _controller.value.caption.text),
                ],
              ),
            ))
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
