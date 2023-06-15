import 'dart:io';

import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage();
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String local_videoUrl = "";
      //   String local_videoUrl = "/data/data/com.example.effectivelearning/files/" +
      // glob['lesson']['id'] +
      // ".mv4";
  var file = new File("/data/data/com.example.effectivelearning/files/" +
      glob['lesson']['id'] +
      ".mv4");
  bool showAdvertCover = false; //
  bool file_exists = true; //

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = glob['lesson']['video_url'];
    return SubRipCaptionFile(fileContents);
  }


  void checkVideo() {
    // if (_controller.value.hasError) {
    //   zlog(":::::::::::::::: HERE ERROR GOES :::::::::::::::::::");
    //   var map = new Map<String, dynamic>();
    //   map['lesson_id'] = glob['lesson']['id'];

    //   post('done_lesson', map);
    //   retPage(context);
    //   retPage(context);
    //   gotoPage(context, CoursePage());
    // }
    // // Implement your calls inside these conditions' bodies :
    // if (_controller.value.position ==
    //     Duration(seconds: 0, minutes: 0, hours: 0)) {
    //   zlog('video Started');
    // }

    // if (_controller.value.position == _controller.value.duration) {
    //   zlog('video Ended');

    //   var map = new Map<String, dynamic>();
    //   map['lesson_id'] = glob['lesson']['id'];

    //   post('done_lesson', map).then((value) {
    //     retPage(context);
    //     retPage(context);
    //     gotoPage(context, CoursePage());
    //   });
    // }

    // setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // _controller = VideoPlayerController.file(
    //   file,
    //   closedCaptionFile: _loadCaptions(),
    // );
    // _controller.addListener(checkVideo);
    // _controller.setVolume(1.0);
    // _controller.setLooping(false);
    // _controller.initialize().then((_) => setState(() {}));
    // _controller.play();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      width: scrWidth,
      height: scrHeight,
      child: RotatedBox(
          quarterTurns: 3,
          child: FutureBuilder(
            future: getFile(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading....');
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return file_exists == true
                        ? AwsomeVideoPlayer(
                            VideoPlayerController.file(
                                file,
                                closedCaptionFile: _loadCaptions(),
                              ),
                            onended: (VideoCallback) {
                              print("video is finished");
                            },
                            oninit: (_controller) {
                              // _controller.
                              // _controller = VideoPlayerController.file(
                              //   file,
                              //   closedCaptionFile: _loadCaptions(),
                              // );
                              // _controller.setVolume(1.0);
                              // _controller.setLooping(false);
                              // _controller
                              //     .initialize()
                              //     .then((_) => setState(() {}));
                              // _controller.play();
                            },
                            playOptions: VideoPlayOptions(
                                seekSeconds: 10,
                                loop: false,
                                autoplay: true,
                                allowScrubbing: true,
                                startPosition: Duration(seconds: 0)),
                            videoStyle: VideoStyle(
                              videoControlBarStyle: VideoControlBarStyle(
                                forwardIcon: Icon(
                                  Icons.forward_10,
                                  color: Colors.white,
                                ),
                                rewindIcon: Icon(
                                  Icons.replay_10,
                                  color: Colors.white,
                                ),
                                playIcon: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                ),
                                pauseIcon: Icon(
                                  Icons.pause_circle_outline,
                                  color: Colors.white,
                                ),
                              ),
                              showPlayIcon: true,
                              videoTopBarStyle: VideoTopBarStyle(
                                show: true,
                                height: 30,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                barBackgroundColor:
                                    Color.fromRGBO(0, 0, 0, 0.5),
                                popIcon: Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                contents: [
                                  Center(
                                    child: Container(
                                      // margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Video Player',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ], //
                                actions: [
                                  GestureDetector(
                                    onTap: () {
                                      ///1.
                                      setState(() {
                                        showAdvertCover = true;
                                      });

                                      ///
                                    },
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                ], //
                                ///
                                // customBar:
                              ),
                            ),
                            onpop: (value) {
                              print("Test");
                            },
                          )
                        : Text("Error Occured, File does not exists");
              }
            },
          )),
    ));
  }

  Future<void> getFile() async {
    return true;
    if (local_videoUrl.isNotEmpty) {
      if (await File(local_videoUrl).exists()) {
        print("File exists");
        file_exists = true;
      } else {
        print("File don't exists");
        file_exists = false;
      }
    }
  }
}

// class _PlayPauseOverlay extends StatelessWidget {
//   const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

//   // final VideoPlayerController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 50),
//           reverseDuration: Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 100.0,
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//       ],
//     );
//   }
// }
