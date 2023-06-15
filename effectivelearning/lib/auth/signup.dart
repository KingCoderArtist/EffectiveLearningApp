import 'package:effectivelearning/board/main.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helper.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ctrlEditName = TextEditingController();
  final ctrlEditEmail = TextEditingController();
  final ctrlEditSelPass = TextEditingController();
  bool _isEnabled = false;

  _checkEnable() {
    if (ctrlEditName.text.length > 0 &&
        ctrlEditEmail.text.length > 0 &&
        ctrlEditSelPass.text.length > 0) {
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
                  txt20B("Sign Up"),
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
              getImgMark(scrWidth * 0.7),
              sb,
              // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              // Name Input
              Container(
                width: scrWidth * 0.9,
                child: TextFormField(
                  controller: ctrlEditName,
                  textAlign: TextAlign.center,
                  style: ts18B,
                  onChanged: (text) {
                    _checkEnable();
                  },
                  decoration: getDecoration("Name"),
                ),
              ),
              sbSmall,
              // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
              // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                  decoration: getDecoration("Select Password"),
                ),
              ),
              sb,
              // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              // Sign Up Button
              ButtonTheme(
                height: 48,
                minWidth: scrWidth * 0.8,
                child: RaisedButton(
                    onPressed: _isEnabled
                        ? glob['offline'] ? null : () {
                            var map = new Map<String, dynamic>();
                            map['name'] = ctrlEditName.text;
                            map['email'] = ctrlEditEmail.text;
                            map['password'] = ctrlEditSelPass.text;
                            post('register', map).then((res) {
                              if (res['validity']) {
                                // Success
                                Fluttertoast.showToast(
                                    msg: "Sign Up Success!",
                                    backgroundColor: colBase,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                    
                                glob['user_id'] = res['data']['user_id'];
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setString('email', ctrlEditEmail.text);
                                  prefs.setString('password', ctrlEditSelPass.text);
                                });
                                retPage(context);
                                gotoPage(context, MainPage());
                              } else {
                                // There is another already exist.
                                Fluttertoast.showToast(
                                    msg: "Email Already Exists!",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            });
                          }
                        : null,
                    color: colBase,
                    textColor: Colors.white,
                    child: txt20BW("Sign Up"),
                    shape: shapeRndBorder10),
              ),
              sbSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  txt20BbD('Already have an account?'),
                  FlatButton(
                    child: txt20BbC("Log In"),
                    onPressed: () {
                      retPage(context);
                      gotoPage(context, LogInPage());
                    },
                  )
                ],
              ),
            ],
          ),
        )));
  }
}
