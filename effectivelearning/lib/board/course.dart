import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:effectivelearning/board/pdfview.dart';
import 'package:effectivelearning/board/qareploy.dart';
import 'package:effectivelearning/board/question.dart';
import 'package:effectivelearning/board/quiz.dart';
import 'package:effectivelearning/board/review.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:effectivelearning/more/buy.dart';
import 'package:video_player/video_player.dart';

class CoursePage extends StatefulWidget {
  const CoursePage();
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool _loadingFlag = false;
  int _redraw = 0;
  bool _videoPlay = false;
  String _videoId = "";
  List<bool> _selTabs = List.generate(4, (_) => false);
  List<String> _locations = [
    'None',
    'At time of event',
    '15 minutes before',
    '1 hour before',
    '1 day before'
  ]; // Option 2
  String _selectedLocation = "1 hour before"; // Option 2
  int _selTab = 0;
  String _updatedTime = "";
  dynamic courseInfo;
  dynamic sections;
  dynamic lessons;
  dynamic lives;
  dynamic qas;
  dynamic ratingSum;
  dynamic ratingAvg;
  dynamic ratingCnt;
  dynamic ratings;
  dynamic ratingMarks;
  dynamic instCourseCnt;
  dynamic instReviewCnt;
  dynamic instStudentCnt;
  dynamic progress;
  dynamic wish;
  bool rated;
  int state; // display the course is pending = 2 or purchased = 3 or free = 1, not purchased = 0

  File file;
  VideoPlayerController _controller;
  ChewieController chewieController;

  void checkVideo() {
    if (_controller.value.hasError) {
      zlog(":::::::::::::::: HERE ERROR GOES :::::::::::::::::::");
      var map = new Map<String, dynamic>();
      map['lesson_id'] = glob['lesson']['id'];

      post('done_lesson', map);
      setState(() {
        _videoPlay = false;
      });
      // _controller.dispose();
      // chewieController.dispose();
    }
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      zlog('video Started');
    }

    if (_controller.value.position == _controller.value.duration) {
      zlog('video Ended');

      setState(() {
        _videoPlay = false;
      });
      var map = new Map<String, dynamic>();
      map['lesson_id'] = glob['lesson']['id'];

      post('done_lesson', map).then((value) {
        // _controller.dispose();
        // chewieController.dispose();
      });
    }
  }

  void redraw() {
    setState(() {
      _redraw += 1;
    });
  }

  // @override
  // void deactivate() {
  //   try {
  //     _controller.dispose();
  //     chewieController.dispose();
  //     super.deactivate();
  //   } catch (e) {
  //     zlog("ERROR ON DEACTIVE");
  //     zlog(e);
  //   }
  // }

  @override
  void dispose() {
    try {
      _controller.dispose();
      chewieController.dispose();
      super.dispose();
    } catch (e) {
      zlog("ERROR ON DISPOSE");
      zlog(e);
      super.dispose();
    }
  }

  Future<void> enterFull() async {
    await Future.delayed(Duration(seconds: 1));
    chewieController.enterFullScreen();
  }

  Future<void> initVideoPlayer() async {
    zlog("+++++++++= INIT VIDEO PLAYER CALLED +++++++++++++++=");
    setState(() {
      _videoPlay = false;
    });
    await Future.delayed(Duration(milliseconds: 100));
    try {
      _controller.removeListener(checkVideo);
      chewieController.pause();
      chewieController.dispose();
      _controller.dispose();
    } catch (e) {
      zlog("INIT VIDEO PLAYER TRY");
      zlog(e);
    }
    await Future.delayed(Duration(milliseconds: 300));
    file = new File(
        "/data/data/com.example.effectivelearning/files/" + _videoId + ".mv4");

    _controller = VideoPlayerController.file(file);

    _controller.addListener(checkVideo);

    chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: false,
    );

    setState(() {
      _videoPlay = true;
    });

    enterFull();
  }

  void onLoad() {
var map = new Map<String, dynamic>();
    map['course_id'] = glob['course_id'];
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Course Detail
    // param: course id
    offPost('course_detail', map).then((res) {
      courseInfo = res['course_info'];
      courseInfo['outcomes'] = jsonDecode(courseInfo['outcomes']);
      courseInfo['requirements'] = jsonDecode(courseInfo['requirements']);
      state = res['state'];
      sections = res['sections'];
      lessons = res['lessons'];
      lives = res['lives'];
      ratingSum = res['rating_sum'];
      ratingAvg = res['rating_avg'];
      ratingCnt = res['rating_cnt'];
      ratings = res['ratings'];
      ratingMarks = res['rating_marks'];
      instCourseCnt = res['inst_course_cnt'];
      instReviewCnt = res['inst_review_cnt'];
      instStudentCnt = res['inst_student_cnt'];
      progress = res['progress'];
      wish = res['wish'];
      rated = res['rated'];

      qas = res['questions'];

      glob['amount'] = courseInfo['price'];
      glob['course_name'] = courseInfo['title'];
      glob['instructor'] =
          courseInfo['first_name'] + " " + courseInfo['last_name'];

      setState(() {
        _selTabs[0] = true;
        _loadingFlag = true;
        if (courseInfo['date_added'] != null) {
          _updatedTime = getYearMonthStr(courseInfo['date_added']);
        }
        if (courseInfo['last_modified'] != null) {
          _updatedTime = getYearMonthStr(courseInfo['last_modified']);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    onRedrawCourse = redraw;
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    viewHeader() {
      return SizedBox(
        width: scrWidth * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                children: <Widget>[
                  SizedBox(
                      width: scrWidth * 0.7,
                      child: txt22B(courseInfo['title'])),
                  SizedBox(
                      width: scrWidth * 0.7,
                      child: txt17(courseInfo['first_name'] +
                          " " +
                          courseInfo['last_name']))
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  state == 3
                      ? SizedBox()
                      : IconButton(
                          icon: Icon(
                              wish ? Icons.favorite : Icons.favorite_border),
                          color: colBase,
                          onPressed: glob['offline']
                              ? null
                              : () {
                                  // ++++++++++++++++++++++++++++++++++++++++++++
                                  // On Click Like
                                  if (wish) {
                                    setState(() {
                                      wish = false;
                                    });
                                  } else {
                                    setState(() {
                                      wish = true;
                                    });
                                  }
                                  var map = new Map<String, dynamic>();
                                  map['wish'] = wish;
                                  map['course_id'] = courseInfo['id'];
                                  post('set_wish', map).then((res) {});
                                }),
                  IconButton(
                    icon: Icon(Icons.share),
                    color: colBase,
                    onPressed: () {
                      // ++++++++++++++++++++++++++++++++++++++++++++
                      // On Click Share
                      final RenderBox box = context.findRenderObject();
                      zlog(
                          "https://www.effectivelearning.institute/home/course/" +
                              titletoseo(courseInfo['title']) +
                              "/" +
                              courseInfo['id'].toString());
                      Share.share(
                          "https://www.effectivelearning.institute/home/course/" +
                              titletoseo(courseInfo['title']) +
                              "/" +
                              courseInfo['id'].toString(),
                          subject: "Please follow Us!",
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    viewStarBuy() {
      return SizedBox(
          width: scrWidth * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                star(ratingAvg.toDouble(), true, 24.0),
                txt18BbD(" " +
                    ratingAvg.toString() +
                    " (" +
                    ratingCnt.toString() +
                    ")")
              ]),
              ButtonTheme(
                height: 30,
                child: RaisedButton(
                    onPressed: glob['offline']
                        ? null
                        : () {
                            // ++++++++++++++++++++++++++++++++++++++++++++++++
                            // Course Info
                            if (state == 1) {
                              // Free Course
                              // Start
                              var map = new Map<String, dynamic>();
                              map['course_id'] = courseInfo['id'];
                              post('enrol', map).then((res) {
                                retPage(context);
                                gotoPage(context, CoursePage());
                              });
                            } else if (state == 0) {
                              // In case of not purchased
                              // Go to Payment Page
                              retPage(context);
                              gotoPage(context, BuyPage());
                            }
                          },
                    color: colBaseLight,
                    textColor: colBase,
                    child: state == 1
                        ? txt18B("Free")
                        : state == 0
                            ? txt18B('Buy | ' +
                                courseInfo['price'].toString() +
                                'ks')
                            : txt17B("PURCHASE PENDING"),
                    shape: shapeRndBorder20),
              ),
            ],
          ));
    }

    viewTab() {
      return Container(
        height: 36,
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(18),
          children: <Widget>[
            Container(
              width: scrWidth * 0.9 / 4,
              alignment: Alignment.center,
              child: txt17bC("Details"),
            ),
            Container(
              width: scrWidth * 0.9 / 4,
              alignment: Alignment.center,
              child: txt17bC("Lessons"),
            ),
            Container(
              width: scrWidth * 0.9 / 4,
              alignment: Alignment.center,
              child: txt17bC("Live"),
            ),
            Container(
              width: scrWidth * 0.9 / 4,
              alignment: Alignment.center,
              child: txt17bC("Q&A"),
            ),
          ],
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < 4; i++) {
                _selTabs[i] = false;
              }
              _selTabs[index] = true;
              _selTab = index;
              _videoPlay = false;
            });
          },
          isSelected: _selTabs,
        ),
      );
    }

    detailCourseIncludes() {
      return Container(
          color: colBaseGreyLight,
          width: scrWidth * 0.9,
          alignment: Alignment.centerLeft,
          padding: paddingSmall,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[txt20B("This Course Includes")],
            ),
            uiIconText(Icons.videocam,
                getHourMinStr(courseInfo['duration']) + " on-demand video"),
            uiIconText(
                Icons.list, lessons.length.toString() + " Support Files"),
            uiIconText(Icons.assignment, "0 Article"),
            uiIconText(Icons.done, "Full lifetime access"),
            uiIconText(Icons.desktop_windows, "Access on mobile and desktop"),
            uiIconText(Icons.toys, "Certificate of Completion"),
            uiIconText(Icons.language, "Language: " + courseInfo['language']),
            uiIconText(Icons.update, "Updated: " + _updatedTime.toString()),
            uiIconText(Icons.help_outline,
                courseInfo['quiz_cnt'].toString() + " Quizzes"),
          ]));
    }

    detailWhatLearn() {
      return Container(
          color: colBaseGreyLight,
          width: scrWidth * 0.9,
          alignment: Alignment.centerLeft,
          padding: paddingSmall,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[txt20B("What will I learn?")],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: courseInfo['outcomes'].length,
                itemBuilder: (BuildContext context, int index) {
                  return uiIconText(Icons.done, courseInfo['outcomes'][index]);
                })
          ]));
    }

    detailDescription() {
      return Container(
          color: colBaseGreyLight,
          width: scrWidth * 0.9,
          alignment: Alignment.centerLeft,
          padding: paddingSmall,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[txt20B("Description")],
            ),
            Html(
              data: courseInfo['description'],
            )
          ]));
    }

    detailAboutInstructor() {
      return Container(
          color: colBaseGreyLight,
          width: scrWidth * 0.9,
          alignment: Alignment.centerLeft,
          padding: paddingSmall,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[txt20B("About the Instructor")],
            ),
            Row(children: <Widget>[
              CachedNetworkImage(
                  imageUrl: getInstructorImg(courseInfo['user_id']),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover),
              SizedBox(
                width: cstPad,
              ),
              txt20B(courseInfo['first_name'] + " " + courseInfo['last_name'])
            ]),
            sbSmall,
            uiIconText(Icons.star, instReviewCnt.toString() + " Reviews"),
            uiIconText(Icons.people, instStudentCnt.toString() + " Students"),
            uiIconText(Icons.play_circle_filled,
                instCourseCnt.toString() + " Courses"),
          ]));
    }

    detailRequirements() {
      return Container(
          color: colBaseGreyLight,
          width: scrWidth * 0.9,
          alignment: Alignment.centerLeft,
          padding: paddingSmall,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[txt20B("Requirements")],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: courseInfo['requirements'].length,
                itemBuilder: (BuildContext context, int index) {
                  return uiIconText(
                      Icons.done, courseInfo['requirements'][index]);
                })
          ]));
    }

    detailReviews() {
      String strRate5 = (ratingCnt == 0
              ? 0
              : ((ratingMarks[5] * 100 / ratingCnt) * 10).toInt().toDouble() /
                  10)
          .toString();
      String strRate4 = (ratingCnt == 0
              ? 0
              : ((ratingMarks[4] * 100 / ratingCnt) * 10).toInt().toDouble() /
                  10)
          .toString();
      String strRate3 = (ratingCnt == 0
              ? 0
              : ((ratingMarks[3] * 100 / ratingCnt) * 10).toInt().toDouble() /
                  10)
          .toString();
      String strRate2 = (ratingCnt == 0
              ? 0
              : ((ratingMarks[2] * 100 / ratingCnt) * 10).toInt().toDouble() /
                  10)
          .toString();
      String strRate1 = (ratingCnt == 0
              ? 0
              : ((ratingMarks[1] * 100 / ratingCnt) * 10).toInt().toDouble() /
                  10)
          .toString();
      return Container(
          color: colBaseGreyLight,
          width: scrWidth * 0.9,
          alignment: Alignment.centerLeft,
          padding: paddingSmall,
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              txt20B("Reviews"),
              SizedBox(
                width: cstPad,
              ),
              star(ratingAvg.toDouble(), true, 18.0),
              Spacer(),
              txt17("  " +
                  ((ratingAvg * 10).toInt().toDouble() / 10).toString() +
                  " (" +
                  ratingCnt.toString() +
                  " Star-reviews)")
            ]),
            sbSmall,
            // ++++++++++++++++++++++++++++++++++++++++++
            // Review Chart
            Row(children: <Widget>[
              txt19B("5 "),
              Icon(Icons.star, color: Colors.amber),
              Flexible(
                  child: LinearPercentIndicator(
                progressColor: Colors.blue,
                percent: ratingCnt == 0
                    ? 0.0
                    : ratingMarks[5].toDouble() / ratingCnt,
              )),
              txt17BbD(" " * (11 - strRate5.length * 2) + strRate5 + "%")
            ]),
            Row(children: <Widget>[
              txt19B("4 "),
              Icon(Icons.star, color: Colors.amber),
              Flexible(
                  child: LinearPercentIndicator(
                progressColor: Colors.blue,
                percent: ratingCnt == 0
                    ? 0.0
                    : ratingMarks[4].toDouble() / ratingCnt,
              )),
              txt17BbD(" " * (11 - strRate4.length * 2) + strRate4 + "%")
            ]),
            Row(children: <Widget>[
              txt19B("3 "),
              Icon(Icons.star, color: Colors.amber),
              Flexible(
                  child: LinearPercentIndicator(
                progressColor: Colors.blue,
                percent: ratingCnt == 0
                    ? 0.0
                    : ratingMarks[3].toDouble() / ratingCnt,
              )),
              txt17BbD(" " * (11 - strRate3.length * 2) + strRate3 + "%")
            ]),
            Row(children: <Widget>[
              txt19B("2 "),
              Icon(Icons.star, color: Colors.amber),
              Flexible(
                  child: LinearPercentIndicator(
                progressColor: Colors.blue,
                percent: ratingCnt == 0
                    ? 0.0
                    : ratingMarks[2].toDouble() / ratingCnt,
              )),
              txt17BbD(" " * (11 - strRate2.length * 2) + strRate2 + "%")
            ]),
            Row(children: <Widget>[
              txt19B("1 "),
              Icon(Icons.star, color: Colors.amber),
              Flexible(
                  child: LinearPercentIndicator(
                progressColor: Colors.blue,
                percent: ratingCnt == 0
                    ? 0.0
                    : ratingMarks[1].toDouble() / ratingCnt,
              )),
              txt17BbD(" " * (11 - strRate1.length * 2) + strRate1 + "%")
            ]),
            divider,
            Column(
                children: List.generate(
                    ratings.length,
                    (index) => Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                txt18B(ratings[index]['first_name'] +
                                    " " +
                                    ratings[index]['last_name']),
                                Spacer(),
                                star(double.parse(ratings[index]['rating']),
                                    true, 16.0),
                                txt15BbD("  " +
                                    getDiff(ratings[index]['date_added'])),
                              ],
                            ),
                            Container(
                              width: scrWidth * 0.9,
                              child: txt18(ratings[index]['review']),
                            ),
                            divider
                          ],
                        )))
          ]));
    }

    lessonCertDownload() {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.verified_user, color: colBase),
                  txt17BbC("  Get Certificate")
                ],
              ),
              onPressed: glob['offline']
                  ? null
                  : () {
                      // var map = new Map<String, dynamic>();
                      // post('get_certificate', map).then((res) {
                      //   listWishes = res['wishes'];
                      //   listCourses = res['mycourses'];
                      //   setState(() {
                      //     _loadingFlag = true;
                      //   });
                      // });
                      if (progress.toString() == '100') {
                        var map = new Map<String, dynamic>();
                        map['course_id'] = courseInfo['id'];
                        post('get_cert_url', map).then((res) {
                          String path =
                              resUrl + "certificates/" + res['filename'];
                          GallerySaver.saveImage(path).then((rpath) {
                            if (rpath) {
                              Fluttertoast.showToast(
                                  msg: "Downloaded Certification",
                                  backgroundColor: colBase,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Download Failed",
                                  backgroundColor: Colors.purple,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                          // gotoPage(context, DownloadPage());
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Not Finished Course",
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
            ),
            FlatButton(
              onPressed: glob['offline']
                  ? null
                  : () {
                      if (state != 3) {
                        Fluttertoast.showToast(
                            msg: "Not Started Course",
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        for (var i = 0; i < sections.length; i++) {
                          for (var j = 0;
                              j < sections[i]['lessons'].length;
                              j++) {
                            var lesson = sections[i]['lessons'][j];
                            if (lesson['lesson_type'] == 'video' &&
                                videoCheck[lesson['id']] != 2 &&
                                videoCheck[lesson['id']] != 1) {
                              downloadQueueUrl.add(lesson['video_url']);
                              downloadQueueLesson.add(lesson['id']);
                              downloadQueueFlag.add(0);
                              downloadPercent.add(0.0);
                              videoCheck[lesson['id']] = 2;
                              vDownProg[lesson['id']] = 0;
                            }
                          }
                        }

                        setState(() {
                          _redraw += 1;
                        });
                      }
                    },
              child: Row(
                children: <Widget>[
                  txt17BbC("Download all  "),
                  Icon(Icons.cloud_download, color: colBase)
                ],
              ),
            )
          ]);
    }

    return Scaffold(
        backgroundColor: colBack,
        body: Stack(children: <Widget>[
          SingleChildScrollView(
              child: Center(
                  child: Column(children: <Widget>[
            sb,
            _videoPlay
                ? Chewie(
                    controller: chewieController,
                  )
                : CachedNetworkImage(
                    imageUrl: getCourseThumbnail(glob['course_id']),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: scrWidth,
                    height: scrWidth * 0.8,
                  ),
            _loadingFlag
                ? Column(
                    children: <Widget>[
                      sbSmall,
                      viewHeader(),
                      state != 3 ? viewStarBuy() : SizedBox(),
                      sbSmall,
                      viewTab(),
                      sbSmall,
                      _selTab == 0
                          // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                          // Details Tab
                          ? Container(
                              width: scrWidth * 0.9,
                              alignment: Alignment.center,
                              child: Column(children: <Widget>[
                                rated
                                    ? SizedBox()
                                    : state != 3
                                        ? SizedBox()
                                        : ButtonTheme(
                                            height: 46,
                                            minWidth: scrWidth * 0.8,
                                            child: RaisedButton(
                                                onPressed: glob['offline']
                                                    ? null
                                                    : () {
                                                        gotoPage(context,
                                                            ReviewPage());
                                                      },
                                                color: colBase,
                                                textColor: Colors.white,
                                                child:
                                                    txt20BW("Write a review"),
                                                shape: shapeRndBorder10),
                                          ),
                                detailCourseIncludes(),
                                sb,
                                detailWhatLearn(),
                                sb,
                                detailDescription(),
                                sb,
                                detailAboutInstructor(),
                                sb,
                                detailRequirements(),
                                sb,
                                detailReviews(),
                                sb,
                              ]))
                          : _selTab == 1
                              ?
                              // +++++++++++++++++++++++++++++++++++++++++++++++++++
                              // Lessons Tab
                              Container(
                                  width: scrWidth * 0.9,
                                  alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                    lessonCertDownload(),
                                    sbSmall,
                                    Column(
                                        children: List.generate(sections.length,
                                            (index) {
                                      return SizedBox(
                                          width: scrWidth * 0.9,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                width: scrWidth * 0.95,
                                                child: txt18BbD(
                                                    sections[index]['title']),
                                              ),
                                              Row(children: <Widget>[
                                                Flexible(
                                                    child: LinearPercentIndicator(
                                                        progressColor:
                                                            Colors.blue,
                                                        percent: max(
                                                            min(
                                                                sections[index][
                                                                            'progress']
                                                                        .toDouble() /
                                                                    sections[index]
                                                                            [
                                                                            'lessons']
                                                                        .length,
                                                                1.0),
                                                            0.0))),
                                                txt16BbD("   " +
                                                    (sections[index]['progress']
                                                                .toInt() *
                                                            100 /
                                                            sections[index]
                                                                    ['lessons']
                                                                .length)
                                                        .toInt()
                                                        .toString() +
                                                    "% completed")
                                              ]),
                                              divider,
                                              Column(
                                                children: List.generate(
                                                    sections[index]['lessons']
                                                        .length, (index2) {
                                                  dynamic lesson =
                                                      sections[index]['lessons']
                                                          [index2];
                                                  return Column(
                                                      children: <Widget>[
                                                        Container(
                                                            width:
                                                                scrWidth * 0.95,
                                                            child: InkWell(
                                                              child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                        child: txt20B(
                                                                            lesson['title'])),
                                                                    Spacer(),
                                                                    lesson['lesson_type'] ==
                                                                            'quiz'
                                                                        ? Icon(
                                                                            Icons
                                                                                .question_answer,
                                                                            color:
                                                                                colBase)
                                                                        : SizedBox(),
                                                                    lesson['lesson_type'] ==
                                                                            'other'
                                                                        ? Icon(
                                                                            Icons
                                                                                .attach_file,
                                                                            color:
                                                                                colBase)
                                                                        : SizedBox(),
                                                                    lesson['done'] ==
                                                                            "1"
                                                                        ? Icon(
                                                                            Icons.check_circle_outline,
                                                                            color:
                                                                                colBase,
                                                                          )
                                                                        : SizedBox(),
                                                                    lesson['lesson_type'] !=
                                                                            'video'
                                                                        ? SizedBox()
                                                                        : videoCheck[lesson['id']] ==
                                                                                2
                                                                            ? CircularPercentIndicator(
                                                                                radius: 50.0,
                                                                                lineWidth: 5.0,
                                                                                percent: min(max(0.0, vDownProg[lesson['id']]), 1.0),
                                                                                center: new Text((min(max(0.0, vDownProg[lesson['id']]), 1.0) * 100).toInt().toString() + "%"),
                                                                                progressColor: Colors.green,
                                                                              )
                                                                            : videoCheck[lesson['id']] == null
                                                                                ? IconButton(
                                                                                    icon: Icon(Icons.cloud_download),
                                                                                    color: colBase,
                                                                                    onPressed: glob['offline']
                                                                                        ? null
                                                                                        : () {
                                                                                            if (state != 3) {
                                                                                              Fluttertoast.showToast(msg: "Not Started Course", backgroundColor: Colors.purple, textColor: Colors.white, fontSize: 16.0);
                                                                                            } else {
                                                                                              // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                              // Download Button Click
                                                                                              downloadQueueUrl.add(lesson['video_url']);
                                                                                              downloadQueueLesson.add(lesson['id']);
                                                                                              downloadQueueFlag.add(0);
                                                                                              downloadPercent.add(0.0);
                                                                                              videoCheck[lesson['id']] = 2;
                                                                                              vDownProg[lesson['id']] = 0;
                                                                                              setState(() {
                                                                                                _redraw += 1;
                                                                                              });
                                                                                            }
                                                                                          },
                                                                                  )
                                                                                : IconButton(
                                                                                    icon: Icon(Icons.delete),
                                                                                    color: colBase,
                                                                                    onPressed: () {
                                                                                      // +++++++++++++ TO DO +++++++++ DELETE FILE
                                                                                      String lessonId = lesson['id'];
                                                                                      File f = new File.fromUri(Uri.file("/data/data/com.example.effectivelearning/files/" + lessonId + ".mv4"));
                                                                                      f.delete();
                                                                                      videoCheck[lessonId] = null;
                                                                                      vDownProg[lessonId] = 0;
                                                                                      vCheck.removeWhere((element) => element == lessonId);
                                                                                      redraw();
                                                                                      SharedPreferences.getInstance().then((prefs) {
                                                                                        prefs.setStringList('videoCheck', vCheck);
                                                                                      });
                                                                                    },
                                                                                  )
                                                                  ]),
                                                              onTap: () {
                                                                if (lesson[
                                                                        'lesson_type'] ==
                                                                    'video') {
                                                                  if (videoCheck[
                                                                          lesson[
                                                                              'id']] ==
                                                                      1) {
                                                                    glob['lesson'] =
                                                                        lesson;
                                                                    setState(
                                                                        () {
                                                                      _videoId =
                                                                          lesson[
                                                                              'id'];
                                                                      initVideoPlayer();
                                                                    });
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Not Downloaded Yet",
                                                                        backgroundColor:
                                                                            Colors
                                                                                .purple,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                  }
                                                                } else if (lesson[
                                                                            'lesson_type'] ==
                                                                        'other' &&
                                                                    lesson['attachment_type'] ==
                                                                        'pdf') {
                                                                  // PDF
                                                                  var map = new Map<
                                                                      String,
                                                                      dynamic>();
                                                                  map['lesson_id'] =
                                                                      lesson[
                                                                          'id'];
                                                                  if (glob[
                                                                          'offline'] ==
                                                                      false) {
                                                                    post(
                                                                        'done_lesson',
                                                                        map);
                                                                  }
                                                                  glob['attachment'] =
                                                                      lesson[
                                                                          'attachment'];
                                                                  gotoPage(
                                                                      context,
                                                                      PdfViewPage());
                                                                } else {
                                                                  // Quiz
                                                                  var map = new Map<
                                                                      String,
                                                                      dynamic>();
                                                                  map['lesson_id'] =
                                                                      lesson[
                                                                          'id'];
                                                                  if (glob[
                                                                          'offline'] ==
                                                                      false) {
                                                                    post(
                                                                        'done_lesson',
                                                                        map);
                                                                  }
                                                                  glob['quiz'] =
                                                                      lesson[
                                                                          'quiz'];
                                                                  glob['lesson'] = lesson;
                                                                  if (glob[
                                                                          'quiz'] ==
                                                                      null) {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Can't not find lesson resource",
                                                                        backgroundColor:
                                                                            Colors
                                                                                .purple,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                  } else {
                                                                    gotoPage(
                                                                        context,
                                                                        QuizPage());
                                                                  }
                                                                  // retPage(context);
                                                                  // gotoPage(context,
                                                                  //     CoursePage());

                                                                }
                                                              },
                                                            )),
                                                        divider
                                                      ]);
                                                }),
                                              ),
                                              sb,
                                            ],
                                          ));
                                    }))
                                  ]))
                              : _selTab == 2
                                  ?
                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++
                                  // Live Tab
                                  lives.length > 0
                                      ? Column(
                                          children: <Widget>[
                                            sbSmall,
                                            SizedBox(
                                              width: scrWidth * 0.9,
                                              child: txt18BbD(
                                                  "Live Lecture - " +
                                                      getPreciseTimeStr(
                                                          lives[0]['date'])),
                                            ),
                                            SizedBox(
                                              width: scrWidth * 0.9,
                                              child: Row(
                                                children: <Widget>[
                                                  txt18BbD("Notification:   "),
                                                  DropdownButton(
                                                    hint: Text(
                                                        'Please choose a location'), // Not necessary for Option 1
                                                    value: _selectedLocation,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _selectedLocation =
                                                            newValue;
                                                      });
                                                    },
                                                    items: _locations
                                                        .map((location) {
                                                      return DropdownMenuItem(
                                                        child:
                                                            txt18BbC(location),
                                                        value: location,
                                                      );
                                                    }).toList(),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: scrWidth * 0.9,
                                              child: txt18BbD(
                                                  lives[0]['note_to_students']),
                                            )
                                          ],
                                        )
                                      : txt17(
                                          "No Live Lessons for this Course at the moment!")
                                  :
                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                  // Q&A Tab
                                  state == 3
                                      ? Column(
                                          children: <Widget>[
                                            SizedBox(
                                              width: scrWidth * 0.9,
                                              child: Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  FlatButton(
                                                    onPressed: () {
                                                      gotoPage(context,
                                                          QuestionPage()).then((val) {
                                                            onLoad();
                                                          });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.local_offer,
                                                          color: colBase,
                                                          size: 18,
                                                        ),
                                                        txt17bC(
                                                            " Ask a Question")
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                                children: List.generate(
                                                    qas.length, (index) {
                                              return Card(
                                                  child: SizedBox(
                                                      width: scrWidth * 0.9,
                                                      child: Column(
                                                          children: <Widget>[
                                                            sbSmall,
                                                            SizedBox(
                                                              width: scrWidth *
                                                                  0.85,
                                                              height: 52,
                                                              child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    CachedNetworkImage(
                                                                        imageUrl: getInstructorImg(qas[
                                                                                index][
                                                                            'user_id']),
                                                                        progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(
                                                                            value: downloadProgress
                                                                                .progress),
                                                                        errorWidget: (context, url,
                                                                                error) =>
                                                                            Icon(Icons
                                                                                .error),
                                                                        width:
                                                                            52,
                                                                        height:
                                                                            52,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                    SizedBox(
                                                                      width:
                                                                          cstPad,
                                                                    ),
                                                                    Column(
                                                                      children: <
                                                                          Widget>[
                                                                        SizedBox(
                                                                          width:
                                                                              scrWidth * 0.6,
                                                                          child: txt20B(qas[index]['first_name'] +
                                                                              " " +
                                                                              qas[index]['last_name']),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              scrWidth * 0.6,
                                                                          child:
                                                                              txt16BbD(qas[index]['created_at']),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                            sbSmall,
                                                            SizedBox(
                                                              width: scrWidth *
                                                                  0.85,
                                                              child: txt18B(qas[
                                                                      index]
                                                                  ['title']),
                                                            ),
                                                            SizedBox(
                                                              width: scrWidth *
                                                                  0.85,
                                                              child: txt17("   " +
                                                                  qas[index]
                                                                      ['body']),
                                                            ),
                                                            sbSmall,
                                                            qas[index]['replies']
                                                                        .length >
                                                                    0
                                                                ? Column(
                                                                    children: List.generate(
                                                                        qas[index]['replies']
                                                                            .length,
                                                                        (j) {
                                                                    return Column(
                                                                        children: <
                                                                            Widget>[
                                                                          divider,
                                                                          sbSmall,
                                                                          SizedBox(
                                                                            width:
                                                                                scrWidth * 0.85,
                                                                            height:
                                                                                52,
                                                                            child:
                                                                                Row(children: <Widget>[
                                                                              SizedBox(
                                                                                width: scrWidth * 0.05,
                                                                              ),
                                                                              CachedNetworkImage(imageUrl: getInstructorImg(qas[index]['replies'][j]['user_id']), progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress), errorWidget: (context, url, error) => Icon(Icons.error), width: 52, height: 52, fit: BoxFit.cover),
                                                                              SizedBox(
                                                                                width: cstPad,
                                                                              ),
                                                                              Column(
                                                                                children: <Widget>[
                                                                                  SizedBox(
                                                                                    width: scrWidth * 0.6,
                                                                                    child: txt20B(qas[index]['replies'][j]['first_name'] + " " + qas[index]['replies'][j]['last_name']),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: scrWidth * 0.6,
                                                                                    child: txt16BbD(qas[index]['replies'][j]['created_at']),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ]),
                                                                          ),
                                                                          sbSmall,
                                                                          Row(
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                width: scrWidth * 0.07,
                                                                              ),
                                                                              SizedBox(
                                                                                child: txt17(qas[index]['replies'][j]['body']),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          sbSmall,
                                                                        ]);
                                                                  }))
                                                                : SizedBox(),
                                                            divider,
                                                            SizedBox(
                                                                width:
                                                                    scrWidth *
                                                                        0.85,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Spacer(),
                                                                    FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        glob['question'] =
                                                                            qas[index];
                                                                        gotoPage(
                                                                            context,
                                                                            QAReplyPage()).then((val) {
                                                                              onLoad();
                                                                            });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.edit,
                                                                            color:
                                                                                colBase,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                          txt17bC(
                                                                              " Write a Reply")
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                            sbSmall
                                                          ])));
                                            }))
                                          ],
                                        )
                                      : txt20BbD("You are not allowed")
                    ],
                  )
                : SizedBox(),
          ]))),
          new Positioned(
              left: cstPadSmall,
              top: cstPadLarge,
              child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      retPage(context);
                    },
                  )))
        ]));
  }
}
