import 'package:cached_network_image/cached_network_image.dart';
import 'package:effectivelearning/board/category.dart';
import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/board/filter.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage();
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  bool _loadingFlag = false;
  List latestCourses;
  List topCourses;
  List categories;
  List courses;
  String _search = "";

  final ctrlEditSearch = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void loadPage() {
    setState(() {
      _loadingFlag = false;
    });
    var map = new Map<String, dynamic>();

    offPost('discover', map).then((res) {
      latestCourses = res['latest_courses'];
      topCourses = res['top_courses'];
      categories = res['categories'];
      courses = res['courses'];
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
              height: 230,
              width: scrWidth * 0.96,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: listCourses.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                width: 160,
                                child: Column(children: <Widget>[
                                  CachedNetworkImage(
                                      imageUrl: getCourseThumbnail(
                                          listCourses[index]['id']),
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 160,
                                      height: 100,
                                      fit: BoxFit.cover),
                                  // Text(getCourseThumbnail(
                                  //         listCourses[index]['id']).toString()),
                                  sbTiny,
                                  SizedBox(
                                    height: 70,
                                    width: 140,
                                    child: txt17B(listCourses[index]['title']),
                                  ),
                                  SizedBox(
                                      width: 140,
                                      child: txt15(listCourses[index]
                                                  ['first_name']
                                              .toString() +
                                          ' ' +
                                          listCourses[index]['last_name']
                                              .toString())),
                                  SizedBox(
                                      width: 144,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            star(
                                                listCourses[index]['rating']
                                                    .toDouble(),
                                                true,
                                                14.0),
                                            txt17B(listCourses[index]['price']
                                                        .toString() !=
                                                    '0'
                                                ? listCourses[index]['price']
                                                        .toString() +
                                                    'ks'
                                                : 'Free')
                                          ]))
                                ]))));
                  }))
          : progress;
    }

    getSearch() {
      List<dynamic> crs = new List();
      for (var i = 0; i < courses.length; i++) {
        if (courses[i]['title'].toUpperCase().contains(_search.toUpperCase())) {
          if (checkCourse(courses[i])) crs.add(courses[i]);
        }
      }
      return Column(
        children: <Widget>[
          sb,
          SizedBox(
            width: scrWidth * 0.9,
            child: txt18BbD(crs.length.toString() + " Courses"),
          ),
          Column(
            children: List.generate(
                crs.length,
                (index) => SizedBox(
                    width: scrWidth * 0.96,
                    child: viewCard(context, crs[index]))),
          ),
        ],
      );
    }

    getNoSearch() {
      List<dynamic> lCourses = new List();
      if (_loadingFlag) {
        int cnt = 0;
        for (var i = courses.length - 1; i >= 0; i--) {
          if (checkCourse(courses[i])) {
            lCourses.add(courses[i]);
            cnt += 1;
            if (cnt == 10) {
              break;
            }
          }
        }
      }

      List<dynamic> tCourses = new List();
      if (_loadingFlag) {
        for (var i = 0; i < topCourses.length; i++) {
          if (checkCourse(topCourses[i])) {
            tCourses.add(topCourses[i]);
          }
        }
      }
      return Column(
        children: <Widget>[
          sbSmall,
          Container(
            width: scrWidth * 0.9,
            child: txt20B("Latest Courses"),
          ),
          getCourses(lCourses),
          sbSmall,
          Container(
            width: scrWidth * 0.9,
            child: txt20B("Top Courses"),
          ),
          getCourses(tCourses),
          sbSmall,
          _loadingFlag
              ? Container(
                  width: scrWidth * 0.96,
                  child: Stack(
                    children: <Widget>[
                      GridView.count(
                          // crossAxisCount is the number of columns
                          primary: false,
                          crossAxisSpacing: cstPadSmall,
                          mainAxisSpacing: cstPadSmall,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          // This creates two columns with two items in each column
                          children: List.generate(categories.length, (index) {
                            return Padding(
                                padding: paddingNone,
                                child: new InkWell(
                                    onTap: () {
                                      // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                      // Category Select
                                      glob['cate'] = categories[index];
                                      gotoPage(context, CategoryPage())
                                          .then((val) {
                                        loadPage();
                                      });
                                    },
                                    child: new Container(
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                          color: Colors.lightGreen,
                                          boxShadow: [
                                            new BoxShadow(
                                                color:
                                                    Colors.black.withAlpha(70),
                                                offset: const Offset(3.0, 10.0),
                                                blurRadius: 15.0)
                                          ],
                                          image: new DecorationImage(
                                            image: getImgNet(getCateThumbnail(
                                                categories[index]
                                                    ['thumbnail'])),
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        //                                    height: 200.0,
                                        width: 200.0,
                                        child: new Stack(children: <Widget>[
                                          new Align(
                                            alignment: Alignment.bottomCenter,
                                            child: new Container(
                                                decoration: new BoxDecoration(
                                                    color:
                                                        const Color(0xFF273A48),
                                                    borderRadius: new BorderRadius
                                                            .only(
                                                        bottomLeft:
                                                            new Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            new Radius.circular(
                                                                10.0))),
                                                height: 42.0,
                                                width: 200,
                                                child: new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                        height: 20,
                                                        width: scrWidth / 2 -
                                                            cstPadLarge,
                                                        child: txt16BW(
                                                            categories[index]
                                                                ['name'])),
                                                    SizedBox(
                                                        width: scrWidth / 2 -
                                                            cstPadLarge,
                                                        child: txt15W(categories[
                                                                        index][
                                                                    'course_cnt']
                                                                .toString() +
                                                            " Courses"))
                                                  ],
                                                )),
                                          )
                                        ]))));
                          })),
                      Container(
                          width: scrWidth * 0.9,
                          child: txt20B("   Categories")),
                    ],
                  ))
              : progress,
          sbSmall
        ],
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Column(children: <Widget>[
        sbLarge,
        getImgMark(scrWidth * 0.5),
        sbSmall,
        Container(
            width: scrWidth * 0.95,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: scrWidth * 0.8,
                    height: 40,
                    child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: ctrlEditSearch,
                          style: TextStyle(fontSize: 18),
                          onChanged: (text) {
                            setState(() {
                              _search = text;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              enabledBorder: const OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: colBack, width: 0.0),
                              ),
                              border: border5,
                              filled: true,
                              hintText: 'Search'),
                        )),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    color: colBase,
                    onPressed: () {
                      gotoPage(context, FilterPage()).then((val) {
                        loadPage();
                      });
                    },
                  )
                ])),
        Flexible(
            child: SingleChildScrollView(
          child: _search == "" ? getNoSearch() : getSearch(),
        )),
        sbSmall,
      ])
    ]);
  }
}
