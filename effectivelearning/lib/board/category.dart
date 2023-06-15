import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage();
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _loadingFlag = false;
  dynamic listCourses;

  @override
  void initState() {
    super.initState();
    var map = new Map<String, dynamic>();
    map['cate_id'] = glob['cate']['id'];
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Category Detail
    // param: cate id
    offPost('cate_detail', map).then((res) {
      listCourses = res['courses'];
      setState(() {
        _loadingFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    

    mainContent() {
      return Column(
        children: <Widget>[
          SizedBox(
              width: scrWidth * 0.96,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listCourses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return viewCard(context, listCourses[index]);
                  })),
        ],
      );
    }

    return Scaffold(
        backgroundColor: colBack,
        body: Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                sbLarge,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.black45,
                      onPressed: () {
                        retPage(context);
                      },
                    ),
                    Column(children: <Widget>[
                      txt20B(glob['cate']['name']),
                      txt14BbD(
                          glob['cate']['course_cnt'].toString() + " Courses"),
                    ]),
                    // IconButton(
                    //   icon: Icon(Icons.filter_list),
                    //   color: Colors.black45,
                    //   onPressed: () {
                    //     retPage(context);
                    //   },
                    // )
                    SizedBox(width: 32,)
                  ],
                ),
                _loadingFlag ? mainContent() : progress,
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
