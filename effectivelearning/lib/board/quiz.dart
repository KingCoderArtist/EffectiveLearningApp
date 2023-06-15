import 'dart:convert';

import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class QuizPage extends StatefulWidget {
  const QuizPage();
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _loadingFlag = false;
  dynamic quiz = glob['quiz'];
  int _id = 1;
  int _selInd = -1;
  String correctAnswer = "0";
  int _buttonState =
      1; // 1: not enabled "Show Results" 2: enabled "Show Results" 3: "Next >"
  List<String> options = new List();
  final ctrlEditTitle = TextEditingController();
  final ctrlEditBody = TextEditingController();

  @override
  void initState() {
    super.initState();
    zlog(quiz[0]);
    dynamic tmpOpt = jsonDecode(quiz[0]['options']);
    dynamic ans = jsonDecode(quiz[0]['correct_answers']);
    correctAnswer = ans[0].toString();
    zlog(correctAnswer);
    zlog(tmpOpt);
    //options = List<String>(jsonDecode(quiz[0]['options']));
    for (int i = 0; i < tmpOpt.length; i++) {
      zlog(tmpOpt[i]);
      options.add(tmpOpt[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: colBack,
        body: Column(children: <Widget>[
          sbLarge,
          Row(
            children: <Widget>[
              const SizedBox(width: 48),
              Spacer(),
              txt20B(glob['lesson']['title']),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  retPage(context);
                },
              )
            ],
          ),
          divider,
          sbSmall,
          SizedBox(
            width: scrWidth * 0.8,
            child: txt18BbD("Questions " +
                _id.toString() +
                " of " +
                quiz.length.toString()),
          ),
          SizedBox(
            width: scrWidth * 0.8,
            child: txt24B(quiz[_id - 1]['title']),
          ),
          sbSmall,
          _buttonState == 3
              ? correctAnswer == (_selInd + 1).toString()
                  ? SizedBox(width: scrWidth * 0.7, child: txt24BR("Correct"))
                  : SizedBox(
                      width: scrWidth * 0.7, child: txt24BR("Wrong Answer"))
              : sbSmall,
          sbSmall,
          RadioButtonGroup(
            labels: options,
            onChange: (String label, int index) {
              setState(() {
                _selInd = index;
                if (_buttonState == 1) {
                  _buttonState = 2;
                }
                zlog(_selInd);
              });
            },
            onSelected: (String label) => print(label),
            itemBuilder: (Radio rb, Text txt, int i) {
              return SizedBox(
                width: scrWidth * 0.8,
                child: Row(
                  children: <Widget>[
                    rb,
                    txt,
                  ],
                ),
              );
            },
          ),
          sbLarge,
          SizedBox(
            width: scrWidth * 0.9,
            child: Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  child: _buttonState == 1
                      ? txt20BbD("Show Results")
                      : _buttonState == 2
                          ? txt20BbC("Show Results")
                          : _id == quiz.length
                              ? SizedBox()
                              : txt20BbC("Next >"),
                  onPressed: () {
                    if (_buttonState == 2) {
                      setState(() {
                        _buttonState = 3;
                      });
                    } else if (_buttonState == 3) {
                      setState(() {
                        _buttonState = 1;
                        _id += 1;

                        dynamic tmpOpt = jsonDecode(quiz[_id - 1]['options']);
                        options.clear();
                        zlog(tmpOpt);
                        //options = List<String>(jsonDecode(quiz[0]['options']));
                        for (int i = 0; i < tmpOpt.length; i++) {
                          zlog(tmpOpt[i]);
                          options.add(tmpOpt[i]);
                        }

                        dynamic ans =
                            jsonDecode(quiz[_id - 1]['correct_answers']);
                        correctAnswer = ans[0].toString();
                        zlog(correctAnswer);
                      });
                    }
                  },
                )
              ],
            ),
          )
        ]));
  }
}
