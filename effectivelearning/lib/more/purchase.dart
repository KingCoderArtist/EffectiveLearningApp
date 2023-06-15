import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';

import 'package:effectivelearning/board/course.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage();
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
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
    offPost('purchase_history', map).then((res) {
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
                  width: 160,
                  child: Row(children: <Widget>[
                    CachedNetworkImage(
                        imageUrl: getCourseThumbnail(item['course_id']),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover),
                    SizedBox(width: cstPadSmall),
                    Column(children: <Widget>[
                      SizedBox(
                          height: 40,
                          width: scrWidth - 125,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                width: scrWidth - 180,
                                child: txt17B(item['title']),
                              ),
                              txt15(item['amount'].toString() + ' ks')
                            ],
                          )),
                      SizedBox(
                          width: scrWidth - 125,
                          child: txt15(item['instructor_name'].toString())),
                      SizedBox(
                        child: Row(
                          children: <Widget>[
                            txt15BbD("method: " + item['method'].toString()),
                            Spacer(),
                            txt15BbD(getPreciseTimeStr(item['date_added'])
                                .toString()),
                          ],
                        ),
                        width: glob['scrWidth'] - 125,
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
                    width: 100,
                  ),
                  SizedBox(
                      child: Center(
                        child: txt19B("Purchase history"),
                      ),
                      width: scrWidth - 200),
                  SizedBox(width: 100),
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
