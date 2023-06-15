import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage();
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool _loadingFlag = false;
  dynamic question = glob['question'];
  final ctrlEditTitle = TextEditingController();
  final ctrlEditBody = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: colBack,
        body: RotatedBox(
            quarterTurns: 0,
            child: Column(children: <Widget>[
              sbLarge,
              Row(
                children: <Widget>[
                  FlatButton(
                    child: txt19BbC("Cancel"),
                    onPressed: () {
                      retPage(context);
                    },
                  ),
                  Spacer(),
                  txt20B("Ask a Question"),
                  Spacer(),
                  FlatButton(
                    child: txt19BbC("Ask"),
                    onPressed: glob['offline'] ? null : () {
                      var map = new Map<String, dynamic>();
                      map['course_id'] = glob['course_id'];
                      map['title'] = ctrlEditTitle.text;
                      map['body'] = ctrlEditBody.text;
                      post('ask_question', map).then((res) {
                        retPage(context);
                      });
                    },
                  ),
                ],
              ),
              divider,
              SizedBox(
                width: scrWidth * 0.9,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: ctrlEditTitle,
                  style: ts18B,
                  onChanged: (text) {},
                  decoration: InputDecoration(
                      hintText: "Title",
                      contentPadding: paddingSmall,
                      border: border5),
                ),
              ),
              sbSmall,
              SizedBox(
                width: scrWidth * 0.9,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: ctrlEditBody,
                  style: ts18B,
                  onChanged: (text) {},
                  decoration: InputDecoration(
                      hintText: "Content",
                      contentPadding: paddingSmall,
                      border: border5),
                ),
              ),
            ])));
  }
}
