import 'package:flutter/material.dart';
import 'package:effectivelearning/more/profile.dart';
import 'package:effectivelearning/more/message.dart';
import 'package:effectivelearning/more/purchase.dart';
import 'package:effectivelearning/more/pending.dart';
import 'package:effectivelearning/more/settings.dart';
import '../helper.dart';

class MorePage extends StatefulWidget {
  const MorePage();
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    int newMsgs = 3;
    moreItems(icon, text, page) {
      return Container(
          width: scrWidth * 0.9,
          child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 33, color: colBase),
                  Baseline(
                    baselineType: TextBaseline.alphabetic,
                    child: txt19BbC("   " + text),
                    baseline: 23.0,
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 18, color: colBase)
                ],
              ),
              onPressed: () {
                gotoPage(context, page);
              }));
    }

    return Center(
      child: Column(children: <Widget>[
        sbLarge,
        sbLarge,
        moreItems(Icons.account_circle, "Profile", ProfilePage()),
        // sbSmall,
        // moreItems(Icons.message, "Messages", MessagePage()),
        // Stack(children: <Widget>[
        //   moreItems(Icons.message, "Messages", MessagePage()),
        //   new Positioned(
        //       left: 250,
        //       top: 11,
        //       child: CircleAvatar(
        //           backgroundColor: Colors.red,
        //           radius: 13,
        //           child: Baseline(
        //             baselineType: TextBaseline.alphabetic,
        //             child: Text(newMsgs.toString(),
        //                 style: TextStyle(
        //                     fontSize: 18,
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white)),
        //             baseline: 18.0,
        //           )))
        // ]),
        sbSmall,
        moreItems(Icons.archive, "Purchase History", PurchasePage()),
        sbSmall,
        moreItems(
            Icons.access_time, "Pending purchase course", PendingCoursePage()),
        sbSmall,
        moreItems(Icons.settings_applications, "Settings", SettingsPage()),
        sbSmall,
      ]),
    );
  }
}
