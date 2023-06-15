import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../helper.dart';

class MessagePage extends StatefulWidget {
  const MessagePage();
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool _loadingFlag = false;
  dynamic msgs;
  dynamic links;
  @override
  void initState() {
    super.initState();
    var map = new Map<String, dynamic>();
    map['action'] = 'view';
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Category Detail
    // param: cate id
    offPost('messaging', map).then((res) {
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
                      CachedNetworkImage(
                          imageUrl: avatarUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover),
                      SizedBox(
                        width: cstPadSmall,
                      ),
                      SizedBox(
                        width: scrWidth * 0.9 - 100,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                msgs[index]['sender_info'] != null
                                    ? txt20B(msgs[index]['sender_info']
                                            ['first_name'] +
                                        " " +
                                        msgs[index]['sender_info']['last_name'])
                                    : txt20B("* Unkown user"),
                                Spacer(),
                                //txt18BbD((new DateTime.fromMicrosecondsSinceEpoch(int.parse(msgs[index]['timestamp']))).toString()),
                                txt18BbD("05.05.20")
                              ],
                            ),
                            Container(
                              //child: txt18BbD((msgs[index]['message']).substring(0, min(10, msgs[index]['message'].length ))),
                              child: Text(
                                msgs[index]['message'].length > 25
                                    ? '${msgs[index]['message'].substring(0, 25)}...'
                                    : msgs[index]['message'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colBaseDisable),
                              ),
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
                        child: txt19B("Messages"),
                      ),
                      width: scrWidth - 200),
                  Container(
                      width: 100,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        color: colBase,
                        onPressed: () {
                          //gotoPage(context, page)
                        },
                      ))
                ],
              ),
              divider,
              Flexible(
                  child: SingleChildScrollView(
                child: _loadingFlag ? mainContent() : progress,
              ))
            ],
          ),
        ));
  }
}
