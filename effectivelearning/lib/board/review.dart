import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage();
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool _loadingFlag = false;
  dynamic question = glob['question'];
  dynamic _rating = 4.0;
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
                  txt20B("Write Review"),
                  Spacer(),
                  FlatButton(
                    child: txt19BbC("Send"),
                    onPressed: () {
                            var map = new Map<String, dynamic>();
                            map['course_id'] = glob['course_id'];
                            map['review'] = ctrlEditBody.text;
                            map['rating'] = _rating;
                            post('add_rating', map).then((res) {
                              retPage(context);
                              retPage(context);
                              gotoPage(context, CoursePage());
                            });
                          },
                  ),
                ],
              ),
              divider,
              SmoothStarRating(
                  rating: _rating,
                  isReadOnly: false,
                  size: 26.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  color: Colors.amber,
                  onRated: (v) {
                    _rating = v;
                  },
                  borderColor: Colors.amber,
                  starCount: 5,
                  allowHalfRating: false,
                  spacing: 0.0),
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
                      hintText: "Review",
                      contentPadding: paddingSmall,
                      border: border5),
                ),
              ),
            ])));
  }
}
