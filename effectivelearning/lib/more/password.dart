import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage();
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  dynamic listPurchase;
  final ctrlEditOldPwd = TextEditingController();
  final ctrlEditNewPwd = TextEditingController();
  final ctrlEditConfirmPwd = TextEditingController();

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
                    child: txt19B("Change Password"),
                  ),
                  width: scrWidth - 160),
              SizedBox(width: 80),
            ],
          ),
          Flexible(
              child: SingleChildScrollView(
            child: Center(
              child: Column(children: <Widget>[
                sbLarge,
                SizedBox(width: scrWidth * 0.9, child: txt16BbD("Old Password")),
                SizedBox(
                  width: scrWidth * 0.9, 
                  child: Container(
                    width: scrWidth * 0.9,
                    child: TextFormField(
                      obscureText: true,
                      controller: ctrlEditOldPwd,
                      textAlign: TextAlign.center,
                      style: ts18B,
                      onChanged: (text) {
                        // _checkEnable();
                      },
                      decoration: getDecoration("Old password"),
                    ),
                  ),
                ),
                sbLarge,
                SizedBox(width: scrWidth * 0.9, child: txt16BbD("New Password")),
                SizedBox(
                  width: scrWidth * 0.9, 
                  child: Container(
                    width: scrWidth * 0.9,
                    child: TextFormField(
                      obscureText: true,
                      controller: ctrlEditNewPwd,
                      textAlign: TextAlign.center,
                      style: ts18B,
                      onChanged: (text) {
                        // _checkEnable();
                      },
                      decoration: getDecoration("New password"),
                    ),
                  ),
                ),
                sbLarge,
                SizedBox(width: scrWidth * 0.9, child: txt16BbD("Confirm Password")),
                SizedBox(
                  width: scrWidth * 0.9, 
                  child: Container(
                    width: scrWidth * 0.9,
                    child: TextFormField(
                      obscureText: true,
                      controller: ctrlEditConfirmPwd,
                      textAlign: TextAlign.center,
                      style: ts18B,
                      onChanged: (text) {
                        // _checkEnable();
                      },
                      decoration: getDecoration("Confirm password"),
                    ),
                  ),
                ),
                sbLarge,

                FlatButton(
                child: txt20BbC("Change Password"),
                onPressed: glob['offline']? null : (){
                  var map = new Map<String, dynamic>();
                  map['current_password'] = ctrlEditOldPwd.text;
                  map['new_password'] = ctrlEditNewPwd.text;
                  map['confirm_password'] = ctrlEditConfirmPwd.text;
                  if(map['current_password'] == '' || map['new_password'] == '' || map['confirm_password'] == ''){
                    Fluttertoast.showToast(
                      msg: "Empty field!",
                      backgroundColor: colBaseDisable,
                      textColor: Colors.white,
                      fontSize: 16.0);
                      return;
                  }
                  else if(map['confirm_password'] == map['new_password']){
                    post('change_password', map).then((res) {
                      if (res['result'] == 'ok') {
                        Fluttertoast.showToast(
                            msg: "Password Changed Successfully!",
                            backgroundColor: colBase,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Invalid Login Credentials",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  }                  
                  else{
                    Fluttertoast.showToast(
                      msg: "Confirm password!",
                      backgroundColor: colBaseDisable,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  }
                },
              )


              ]),
            ),
          ))
        ],
      ),
    ));
  }
}
