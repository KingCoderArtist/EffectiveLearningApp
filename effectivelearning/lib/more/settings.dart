import 'package:effectivelearning/more/opt_download.dart';
import 'package:effectivelearning/more/opt_notification.dart';
import 'package:effectivelearning/more/about.dart';
import 'package:effectivelearning/more/password.dart';
import 'package:effectivelearning/main.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  dynamic listPurchase;
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    moreItems(icon, text, page) {
      return Container(
          width: scrWidth * 0.9,
          child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Center(child: txt19BbC("   " + text)),
                    width: scrWidth - 100,
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18, color: colBase)
                ],
              ),
              onPressed: () {
                gotoPage(context, page);
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
                        child: txt19B("Settings"),
                      ),
                      width: scrWidth - 200),
                  SizedBox(width: 100),
                ],
              ),
              divider,
              Center(
                child: Column(children: <Widget>[
                  moreItems(Icons.account_circle, "Download & Playback Options",
                      DownloadOptPage()),
                  sbSmall,
                  moreItems(
                      Icons.message, "Notification", NotificationOptPage()),
                  sbSmall,
                  moreItems(Icons.archive, "Change Password", PasswordPage()),
                  sbSmall,
                  moreItems(Icons.access_time, "About Effective Learning",
                      AboutPage()),
                  sbSmall,
                  FlatButton(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        var map = new Map<String, dynamic>();
                        // post('logout', map).then((res) {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString('email', "");
                          prefs.setString('password', "");
                        });
                        retPage(context);
                        gotoPage(context, MyHomePage());
                        //   });
                      }),
                  sbSmall,
                ]),
              )
            ],
          ),
        ));
  }
}
