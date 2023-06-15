import 'package:effectivelearning/auth/signup.dart';
import 'package:effectivelearning/board/main.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final ctrlEditEmail = TextEditingController();
  final ctrlEditSelPass = TextEditingController();
  bool _isEnabled = false;

  _checkEnable() {
    if (ctrlEditEmail.text.length > 0 && ctrlEditSelPass.text.length > 0) {
      setState(() {
        _isEnabled = true;
      });
    } else {
      setState(() {
        _isEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colBack,
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: <Widget>[
              sbLarge,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 48),
                  txt20B("Log In"),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.black45,
                    onPressed: () {
                      retPage(context);
                    },
                  )
                ],
              ),
              divider,
              sb,
              getImgMark(scrWidth * 0.7),
              sbLarge,
              // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
              // Email Input
              Container(
                width: scrWidth * 0.9,
                child: TextFormField(
                  controller: ctrlEditEmail,
                  textAlign: TextAlign.center,
                  style: ts18B,
                  onChanged: (text) {
                    _checkEnable();
                  },
                  decoration: getDecoration("E-Mail Address"),
                ),
              ),
              sbSmall,
              // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              // Password Input
              Container(
                width: scrWidth * 0.9,
                child: TextFormField(
                  obscureText: true,
                  controller: ctrlEditSelPass,
                  textAlign: TextAlign.center,
                  style: ts18B,
                  onChanged: (text) {
                    _checkEnable();
                  },
                  decoration: getDecoration("Password"),
                ),
              ),
              sb,
              // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              // Log In Button
              ButtonTheme(
                height: 46,
                minWidth: scrWidth * 0.8,
                child: RaisedButton(
                    onPressed: _isEnabled
                        ? glob['offline'] ? null : () {
                            var map = new Map<String, dynamic>();
                            map['email'] = ctrlEditEmail.text;
                            map['password'] = ctrlEditSelPass.text;
                            post('login', map).then((res) {
                              if (res['result']) {
                                Fluttertoast.showToast(
                                    msg: "Log In Success!",
                                    backgroundColor: colBase,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setString('email', ctrlEditEmail.text);
                                  prefs.setString('password', ctrlEditSelPass.text);
                                });
                                glob['user_id'] = res['data']['id'];
                                retPage(context);
                                gotoPage(context, MainPage());
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Invalid Login Credentials",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            });
                          }
                        : null,
                    color: colBase,
                    textColor: Colors.white,
                    child: txt20BW("Log In"),
                    shape: shapeRndBorder10),
              ),
              sbSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  txt20BbD("Don't have an account?"),
                  FlatButton(
                    child: txt20BbC("Sign Up"),
                    onPressed: () {
                      retPage(context);
                      gotoPage(context, SignUpPage());
                    },
                  )
                ],
              ),
            ],
          ),
        )));
  }
}
