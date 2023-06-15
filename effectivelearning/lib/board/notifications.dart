import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import '../helper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage();
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _loadingFlag = false;
  dynamic msgs;
  dynamic links;
  @override
  void initState() {
    super.initState();
    var map = new Map<String, dynamic>();
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Category Detail
    // param: cate id
    offPost('get_notifications', map).then((res) {
      if(res != null)
        msgs = res;
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
          children: new List.generate(msgs.length, (index) {
        return Column(
          children: <Widget>[
            Container(
                width: scrWidth,
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: cstPadSmall),
                      SizedBox(
                        width: scrWidth * 0.9 - 36,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                msgs[index]['sender_name'] != null
                                    ? txt20B(msgs[index]['sender_name'])
                                    : txt20B("Someone"),
                                txt18BbD(" send you a message")
                              ],
                            ),
                            Container(
                              //child: txt18BbD((msgs[index]['message']).substring(0, min(10, msgs[index]['message'].length ))),
                              child: Text(
                                msgs[index]['content'].length > 25
                                    ? '${msgs[index]['message'].substring(0, 25)}...'
                                    : msgs[index]['content'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: colBaseDisable),
                              ),
                              width: scrWidth,
                            ),
                            Container(
                              //child: txt18BbD((msgs[index]['message']).substring(0, min(10, msgs[index]['message'].length ))),
                              child: txt16BbD(msgs[index]['timestamp']),
                              width: scrWidth,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: cstPadSmall),
                      Icon(Icons.arrow_forward_ios, size: 18, color: colBase),
                    ],
                  ),
                  onPressed: () {},
                )),
            Container(
              child: divider,
              width: scrWidth * 0.9,
            )
          ],
        );
      }));
    }

    return Column(
      children: <Widget>[
        sbLarge,
        txt19B("Notifications"),
        divider,
        _loadingFlag ? mainContent() : progress,
      ],
    );
  }
}
