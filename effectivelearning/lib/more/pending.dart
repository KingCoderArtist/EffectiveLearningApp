import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';

import 'package:effectivelearning/board/course.dart';

class PendingCoursePage extends StatefulWidget {
  const PendingCoursePage();
  @override
  _PendingCoursePageState createState() => _PendingCoursePageState();
}

class _PendingCoursePageState extends State<PendingCoursePage> {
  bool _loadingFlag = false;
  dynamic listPurchase;

  @override
  void initState() {
    super.initState();
    var map = new Map<String, dynamic>();
    // map['cate_id'] = glob['cate']['id'];
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Category Detail
    // param: cate id
    offPost('pending_course', map).then((res) {
      listPurchase = res;
      setState(() {
        _loadingFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    viewPurchase(context, item) {
      return Card(
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                // Calling Course Page
                // param: course id
                glob['course_id'] = item['course_id'];
                gotoPage(context, CoursePage());
              },
              child: Container(
                  child: Row(children: <Widget>[
                Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                        imageUrl: getCourseThumbnail(item['course_id']),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 90,
                        height: 80,
                        fit: BoxFit.cover),
                    new Positioned(
                      left: 9,
                      top: 28,
                      child: Container(
                          child: Text(
                            'PENDING',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey.withOpacity(0.8)),
                          height: 23,
                          width: 70,
                          alignment: Alignment(0.1,
                              0.9)), //Text('PENDING', style: TextStyle(fontSize:15, backgroundColor: Colors.grey, color: Colors.white),)
                    )
                  ],
                ),
                SizedBox(width: cstPadSmall),
                Column(children: <Widget>[
                  SizedBox(
                      height: 40,
                      width: scrWidth - 130,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                            width: scrWidth - 210,
                            child: txt17B(item['title']),
                          ),
                          txt15(item['amount'].toString() + ' ks')
                        ],
                      )),
                  SizedBox(
                      width: scrWidth - 130,
                      child: txt15(item['instructor_name'].toString())),
                  SizedBox(
                    child: Row(
                      children: <Widget>[
                        txt15BbD("method: offline"),
                        Spacer(),
                        txt15BbD(
                            getPreciseTimeStr(item['date_added']).toString()),
                      ],
                    ),
                    width: glob['scrWidth'] - 130,
                  )
                ])
              ]))));
    }

    mainContent() {
      return Column(
        children: <Widget>[
          SizedBox(
              width: scrWidth * 0.96,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listPurchase.length,
                  itemBuilder: (BuildContext context, int index) {
                    return viewPurchase(context, listPurchase[index]);
                  })),
        ],
      );
    }

    return Scaffold(
        backgroundColor: colBack,
        body: RotatedBox(
          quarterTurns: 0,
          child: Column(
            children: <Widget>[
              sbLarge,
              Row(
                children: <Widget>[
                  SizedBox(
                    child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios,
                                size: 24, color: colBase),
                            Baseline(
                              baselineType: TextBaseline.alphabetic,
                              child: txt19BbC(" More"),
                              baseline: 20.0,
                            ),
                          ],
                        ),
                        onPressed: () {
                          retPage(context);
                        }),
                    width: 95,
                  ),
                  SizedBox(
                      child: Center(
                        child: txt19B("Pending purchase course"),
                      ),
                      width: scrWidth - 180),
                  SizedBox(width: 80),
                ],
              ),
              Flexible(
                  child: SingleChildScrollView(
                child: _loadingFlag ? mainContent() : progress,
              ))
            ],
          ),
        ));
  }
}
