import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationOptPage extends StatefulWidget {
  const NotificationOptPage();
  @override
  _NotificationOptPageState createState() => _NotificationOptPageState();
}

class _NotificationOptPageState extends State<NotificationOptPage> {
  bool _loadingFlag = false;
  dynamic listPurchase;
  bool _enableNewMessages = true;
  bool _enableLiveLectures = true;
  bool _enableQAReplies = true;
  bool _enablePromotion = true;
  int pixelSize = 1;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  _loadOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableNewMessages = (prefs.getBool('_enableNewMessages') ?? false);
      _enableLiveLectures = (prefs.getBool('_enableLiveLectures') ?? false);
      _enableQAReplies = (prefs.getBool('_enableQAReplies') ?? false);
      _enablePromotion = (prefs.getBool('_enablePromotion') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

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
                    padding: EdgeInsets.only(left: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.arrow_back_ios, size: 24, color: colBase),
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
                width: 80,
              ),
              SizedBox(
                  child: Center(
                    child: txt19B("Notifications"),
                  ),
                  width: scrWidth - 160),
              SizedBox(width: 80),
            ],
          ),
          Flexible(
              child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  sbLarge,
                  SizedBox(
                    width: 0.75 * scrWidth,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            txt19BgC("New Messages"),
                            Spacer(),
                            Switch(
                              onChanged: (newValue) async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  _enableNewMessages = newValue;
                                  prefs.setBool('_enableNewMessages', newValue);
                                });
                              },
                              value: _enableNewMessages,
                              activeColor: colBase,
                            )
                          ],
                        ),                        
                        sbSmall,
                        Row(
                          children: <Widget>[
                            txt19BgC("Live Lectures"),
                            Spacer(),
                            Switch(
                              onChanged: (newValue) async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  _enableLiveLectures = newValue;
                                  prefs.setBool('_enableLiveLectures', newValue);
                                });
                              },
                              value: _enableLiveLectures,
                              activeColor: colBase,
                            )
                          ],
                        ),
                        sbSmall,
                        Row(
                          children: <Widget>[
                            txt19BgC("Q&A Replies"),
                            Spacer(),
                            Switch(
                              onChanged: (newValue) async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  _enableQAReplies = newValue;
                                  prefs.setBool('_enableQAReplies', newValue);
                                });
                              },
                              value: _enableQAReplies,
                              activeColor: colBase,
                            )
                          ],
                        ),
                        sbSmall,
                        Row(
                          children: <Widget>[
                            txt19BgC("Promotional Information"),
                            Spacer(),
                            Switch(
                              onChanged: (newValue) async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  _enablePromotion = newValue;
                                  prefs.setBool('_enablePromotion', newValue);
                                });
                              },
                              value: _enablePromotion,
                              activeColor: colBase,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
