import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage();
  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  bool _loadingFlag = false;
  dynamic listWishes;
  dynamic listCourses;

  void loadPage() {
    setState(() {
      _loadingFlag = false;
    });
    var map = new Map<String, dynamic>();
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Category Detail
    // param: cate id
    offPost('mycourses', map).then((res) {
      listWishes = res['wishes'];
      listCourses = res['mycourses'];
      setState(() {
        _loadingFlag = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    getCourses(listCourses) {
      return _loadingFlag
          ? SizedBox(
              width: scrWidth * 0.96,
              child: GridView.count(
                  // crossAxisCount is the number of columns
                  primary: false,
                  crossAxisSpacing: cstPadSmall,
                  mainAxisSpacing: cstPadSmall,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: (scrWidth / 2 - cstPadSmall * 2) / 190,
                  // This creates two columns with two items in each column
                  children: List.generate(listCourses.length, (index) {
                    return Card(
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                            // Calling Course Page
                            // param: course id
                            glob['course_id'] = listCourses[index]['id'];
                            gotoPage(context, CoursePage()).then((val) {
                              loadPage();
                            });
                          },
                          child: Container(
                              child: Column(children: <Widget>[
                            CachedNetworkImage(
                                imageUrl: getCourseThumbnail(
                                    listCourses[index]['id']),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                width: scrWidth * 0.48,
                                height: 100,
                                fit: BoxFit.cover),
                            sbTiny,
                            // Text(getCourseThumbnail(
                            //         listCourses[index]['id']).toString()),
                            SizedBox(
                              height: 50,
                              width: scrWidth / 2.5,
                              child: txt17B(listCourses[index]['title']),
                            ),
                            sbTiny,
                            Flexible(
                                child: LinearPercentIndicator(
                                    progressColor: Colors.blue,
                                    percent: listCourses[index]['progress']
                                            .toDouble() /
                                        100)),
                            sbTiny,
                            SizedBox(
                              width: scrWidth / 2.6,
                              child: txt16BbD(listCourses[index]['progress'].toString() +
                                "% Completed"),)
                            
                          ]))),
                    );
                  })))
          : progress;
    }

    viewWishlist() {
      return Column(
        children: <Widget>[
          SizedBox(
              width: scrWidth * 0.96,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listWishes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return viewCard(context, listWishes[index]);
                  })),
        ],
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      SingleChildScrollView(
          child: Column(children: <Widget>[
        sbLarge,
        Stack(
          children: <Widget>[
            getCourses(listCourses),
            Container(
              width: scrWidth * 0.9,
              child: txt20B("  My Courses"),
            )
          ],
        ),
        sb,
        Stack(
          children: <Widget>[
            _loadingFlag ? viewWishlist() : progress,
            Container(
              width: scrWidth * 0.9,
              child: txt20B("   Wishlist"),
            )
          ],
        ),
        sbSmall,
      ]))
    ]);
  }
}
