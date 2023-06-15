import 'package:cached_network_image/cached_network_image.dart';
import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';

class QAReplyPage extends StatefulWidget {
  const QAReplyPage();
  @override
  _QAReplyPageState createState() => _QAReplyPageState();
}

class _QAReplyPageState extends State<QAReplyPage> {
  bool _loadingFlag = false;
  dynamic question = glob['question'];
  final ctrlEditReply = TextEditingController();

  @override
  void initState() {
    super.initState();
    // var map = new Map<String, dynamic>();
    // // map['cate_id'] = glob['cate']['id'];
    // // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // // Calling API Get Category Detail
    // // param: cate id
    // post('pending_course', map).then((res) {
    //   zlog(res);
    //   setState(() {
    //     _loadingFlag = true;
    //   });
    // });
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
                  txt20B("Write Reply"),
                  Spacer(),
                  FlatButton(
                    child: txt19BbC("Send"),
                    onPressed: glob['offline'] ? null : () {
                      var map = new Map<String, dynamic>();
                      map['question_id'] = question['id'];
                      map['body'] = ctrlEditReply.text;
                      post('reply_question', map).then((res) {
                        retPage(context);
                      });
                    },
                  ),
                ],
              ),
              divider,
              SizedBox(
                  width: scrWidth * 0.9,
                  child: Column(children: <Widget>[
                    sbSmall,
                    SizedBox(
                      width: scrWidth * 0.85,
                      height: 52,
                      child: Row(children: <Widget>[
                        CachedNetworkImage(
                            imageUrl: getInstructorImg(question['user_id']),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover),
                        SizedBox(
                          width: cstPad,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: scrWidth * 0.6,
                              child: txt20B(question['first_name'] +
                                  " " +
                                  question['last_name']),
                            ),
                            SizedBox(
                              width: scrWidth * 0.6,
                              child: txt16BbD(question['created_at']),
                            )
                          ],
                        )
                      ]),
                    ),
                    sbSmall,
                    SizedBox(
                      width: scrWidth * 0.85,
                      child: txt18B(question['title']),
                    ),
                    SizedBox(
                      width: scrWidth * 0.85,
                      child: txt17(question['body']),
                    ),
                  ])),
              sbSmall,
              SizedBox(
                width: scrWidth * 0.9,
                height: 350,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: ctrlEditReply,
                  style: ts18B,
                  onChanged: (text) {},
                  decoration: InputDecoration(
                      hintText: "Write a reply",
                      contentPadding: paddingSmall,
                      border: border5),
                ),
              ),
            ])));
  }
}
