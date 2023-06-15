import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loadingFlag = false;
  dynamic userInfo;
  dynamic links;
  @override
  void initState() {
    super.initState();
    var map = new Map<String, dynamic>();
    //map['cate_id'] = glob['cate']['id'];
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Calling API Get Category Detail
    // param: cate id
    offPost('get_profile', map).then((res) {
      userInfo = res['user_details'];
      if (userInfo.length != 0) {
        links = jsonDecode(userInfo['social_links']);
      }

      setState(() {
        _loadingFlag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    mainContent() {
      if (userInfo.length == 0) {
        return txt17BbC("Please login");
      } else {
        return Column(
          children: <Widget>[
            CachedNetworkImage(
                imageUrl: avatarUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 100,
                height: 100,
                fit: BoxFit.cover),
            txt18B(userInfo['first_name'] + ' ' + userInfo['last_name']),
            sbLarge,
            txt18B(userInfo['email']),
            sbLarge,
            // txt18B("1908092385039485"),
            // sbLarge,
            // links['facebook'] == ''
            //     ? Text('No link yet')
            //     : txt18B(links['facebook']),
            // sbLarge,
            // links['twitter'] == ''
            //     ? Text('No link yet')
            //     : txt18B(links['twitter']),
            // sbSmall,
            // FlatButton(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Icon(
            //         Icons.add_circle,
            //         color: colBase,
            //       ),
            //       Baseline(
            //         baselineType: TextBaseline.alphabetic,
            //         child: txt18BbC(" New Link"),
            //         baseline: 20.0,
            //       ),
            //     ],
            //   ),
            //   onPressed: () {},
            // ),
            // Container(
            //   child: txt18BbD("About me"),
            //   width: scrWidth * 0.9,
            // )
          ],
        );
      }
    }

    return Scaffold(
        backgroundColor: colBack,
        body: SingleChildScrollView(
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
                        child: txt19B("Profile"),
                      ),
                      width: scrWidth - 200),
                  SizedBox(width: 100),
                ],
              ),
              sbSmall,
              _loadingFlag ? mainContent() : progress,
            ],
          ),
        ));
  }
}
