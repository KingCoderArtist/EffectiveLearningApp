import 'dart:io';

import 'package:effectivelearning/board/main.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helper.dart';
import 'auth/signup.dart';
import 'auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SharedPreferences.getInstance().then((prefs) {
      // prefs.setStringList('videoCheck', new List());
      vCheck = (prefs.getStringList('videoCheck') ?? new List());
      for (int i = 0; i < vCheck.length; i++) {
        videoCheck[vCheck[i]] = 1;
      }
    });

    glob['price'] = 'All';
    glob['level'] = 'All';
    glob['language'] = 'All';
    glob['minrating'] = 0.0;
    glob['startflag'] = true;
    glob['offline'] = false;

    downloadThread();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          fontFamily: 'Calibre'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    glob['scrWidth'] = scrWidth;

    if (glob['startflag']) {
      glob['startflag'] = false;
      String email = "";
      String password = "";
      SharedPreferences.getInstance().then((prefs) {
        email = (prefs.getString('email') ?? "");
        password = (prefs.getString('password') ?? "");

        zlog("Infod");
        zlog(email);
        zlog(password);
        if (email != "" && password != "") {
          // checkNet().then((value) {
          //   if (value) {
          // Net Connected
          var map = new Map<String, dynamic>();
          map['email'] = email;
          map['password'] = password;
          post('login', map).then((res) {
            if (res['result'] == true) {
              glob['user_id'] = res['data']['id'];
              retPage(context);
              gotoPage(context, MainPage());
            } else {
              if (glob['offline'] && res['failed']) {
                // If Offline
                zlog("Real offline Mode");
                retPage(context);
                gotoPage(context, MainPage());
              }
            }
          });
          //   } else {
          //     // Not Connected
          //     // Goto MyPage
          //     glob['netmode'] = 'offline';
          //     gotoPage(context, MainPage());
          //   }
          // });
        }
      });
    }

    return WillPopScope(
      onWillPop: () {
        exit(0);
        SystemNavigator.pop();
      },
      child: Scaffold(
          backgroundColor: colBack,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getImgMark(scrWidth * 0.7),
                sb,
                // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                // Sign Up Button
                ButtonTheme(
                  height: 48,
                  minWidth: scrWidth * 0.8,
                  child: RaisedButton(
                      onPressed: () {
                        gotoPage(context, SignUpPage());
                      },
                      color: colBase,
                      textColor: Colors.white,
                      child: txt20BW("Sign Up"),
                      shape: shapeRndBorder10),
                ),
                sb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    txt20BbD('Already have an account?'),
                    FlatButton(
                      child: txt20BbC("Log In"),
                      onPressed: () {
                        gotoPage(context, LogInPage());
                      },
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
