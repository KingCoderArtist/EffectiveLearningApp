import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:effectivelearning/board/course.dart';
import 'package:effectivelearning/globals.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:requests/requests.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const debugFlag = true;
const double cstPadTiny = 5;
const double cstPadSmall = 10;
const double cstPad = 20;
const double cstPadLarge = 30;
const SizedBox sbTiny = SizedBox(
  height: cstPadTiny,
);
const SizedBox sbSmall = SizedBox(
  height: cstPadSmall,
);
const SizedBox sb = SizedBox(
  height: cstPad,
);
const SizedBox sbLarge = SizedBox(
  height: cstPadLarge,
);
const Color colBase = Color(0xFF4A83B8);
const Color colBaseDisable = Color(0xFFA2A2A2);
const Color colBaseLight = Color(0xFFD3E6F8);
const Color colBaseGrey = Color(0xFFE6E6E6);
const Color colBaseGreyLight = Color(0xFFF5F5F5);
const Color colBack = Color(0xFFF4F4F4);
const Color colRed = Color(0xFFEF3232);

const divider = Divider(
  color: colBaseDisable,
);

// const baseUrl = 'http://10.10.10.230/app/';
// const resUrl = 'http://10.10.10.230/uploads/';
// const baseUrl = 'https://www.effectivelearning.institute/app/';
// const resUrl = 'https://www.effectivelearning.institute/uploads/';
const baseUrl = 'http://13.228.18.219/app/';
const resUrl = 'http://13.228.18.219/uploads/';
const avatarUrl = resUrl + 'user_image/placeholder.png';

const downloadRoute = "/data/data/com.example.effectivelearning/files/";

const months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "June",
  "July",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];

titletoseo(title) {
  String res =title;
  res = res.replaceAll(' ', '-');
  res = res.toLowerCase();
  return res;
}

Future<void> getPermissions() async {
  Map<Permission, PermissionStatus> permissions =
      await [Permission.storage].request();
}

Future<void> downloadThread() async {
  Dio dio = Dio();
  int cnt = 0;
  var map = new Map<String, dynamic>();
  while (true) {
    cnt += 1;
    if (cnt == 10) {
      cnt = 0;
      // Check Online or Offline
      post('test', map);
    }
    if (downloadQueueUrl.length > downloadPos) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/data/data/com.example.effectivelearning/files/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      FileUtils.mkdir([dirloc]);

      try {
        String lessonId = downloadQueueLesson[downloadPos];
        await dio
            .download(downloadQueueUrl[downloadPos], dirloc + lessonId + ".mv4",
                onReceiveProgress: (receivedBytes, totalBytes) {
          // zlog("++++++++++++++++++= received: " +
          //     receivedBytes.toString() +
          //     "   total: " +
          //     totalBytes.toString());
          downloadQueueFlag[downloadPos] = 1;
          downloadPercent[downloadPos] = receivedBytes.toDouble() / totalBytes;
          vDownProg[lessonId] = downloadPercent[downloadPos];
          onRedrawCourse();
        });
        downloadQueueFlag[downloadPos] = 2;
        downloadPercent[downloadPos] = 1.0;

        videoCheck[lessonId] = 1;
        vDownProg[lessonId] = 0;
        onRedrawCourse();

        vCheck.add(lessonId);
        SharedPreferences.getInstance().then((prefs) {
          prefs.setStringList('videoCheck', vCheck);
        });
      } catch (e) {
        print(e);
      }

      downloadPos += 1;
    }
    await Future.delayed(Duration(seconds: 3));
  }
}

Future<File> downloadFile(String url, String filename) async {
  http.Client client = new http.Client();
  var req = await client.get(Uri.parse(url));
  var bytes = req.bodyBytes;
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

setOffInfo(id, val) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.setString(id, jsonEncode(val));
  });
}

Future<dynamic> getOffInfo(id) async {
  var prefs = await SharedPreferences.getInstance();
  var str = prefs.getString(id);
  if (str == null) {
    Fluttertoast.showToast(
        msg: "Can not find Offline Cache.",
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 16.0);
    return null;
  }
  var res = jsonDecode(str);
  res = jsonDecode(res);
  return res;
}

Future<dynamic> offPost(url, map) async {
  if (glob['offline']) {
    var ss = url + map.toString();
    return await getOffInfo(ss);
  } else {
    return await post(url, map);
  }
}

Future<dynamic> post(url, map) async {
  var ss = url + map.toString();
  try {
    final response = await Requests.post(baseUrl + url,
        body: map, bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    response.raiseForStatus();
    if (glob['offline'] == true) {
      Fluttertoast.showToast(
          msg: "Internet Connected",
          backgroundColor: colBase,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    glob['offline'] = false;
    var res = response.json();
    var ss = url + map.toString();
    setOffInfo(ss, jsonEncode(res));
    return res;
  } catch (e) {
    zlog("HTTP ERROR -------------");
    zlog(e);
    if (glob['offline'] == false && url != 'test') {
      Fluttertoast.showToast(
          msg: "No Internet Connection. Change to Offline Mode",
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if(url == 'test') {
      return null;
    }
    glob['offline'] = true;

      var prefs = await SharedPreferences.getInstance();
      var str = prefs.getString(ss);
      if (str == null) {
        return null;
      }
      var res = jsonDecode(str);
      res = jsonDecode(res);
      return res;
  }
}

checkCourse(course) {
  if (glob['price'] == 'Paid') {
    if (course['price'].toString() == '0') {
      return false;
    }
  }
  if (glob['price'] == 'Free') {
    if (course['price'].toString() != '0') {
      return false;
    }
  }
  if (glob['level'] == 'Beginner') {
    if (course['level'] == 'advanced') {
      return false;
    }
  }
  if (glob['level'] == 'Advanced') {
    if (course['level'] == 'beginner') {
      return false;
    }
  }
  if (glob['language'] == 'English') {
    if (course['language'] == 'myanmar') {
      return false;
    }
  }
  if (glob['language'] == 'Myanmar') {
    if (course['language'] == 'english') {
      return false;
    }
  }
  if (glob['minrating'] > course['rating']) {
    return false;
  }
  return true;
}

getHourMinStr(sec) {
  return (sec / 3600).floor().toString() +
      " hours, " +
      ((sec / 60).floor() % 60).toString() +
      "minutes";
}

getYearMonthStr(timestamp) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return "" + months[date.month - 1] + ". " + date.year.toString();
}

getPreciseTimeStr(timestamp) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return "" +
      date.day.toString() +
      ". " +
      months[date.month - 1] +
      " " +
      date.year.toString() +
      ", " +
      date.hour.toString() +
      ":" +
      date.minute.toString();
}

star(rating, isReadOnly, size) {
  return SmoothStarRating(
      rating: rating,
      isReadOnly: isReadOnly,
      size: size,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border,
      color: Colors.amber,
      borderColor: Colors.amber,
      starCount: 5,
      allowHalfRating: true,
      spacing: 0.0);
}

zlog(txt) {
  if (debugFlag) {
    debugPrint(txt.toString());
  }
}

getImgNet(url) {
  return NetworkImage(url);
}

getImgMark(size) {
  return Image(width: size, image: AssetImage('assets/mark.png'));
}

getDecoration(text) {
  return InputDecoration(
      contentPadding: paddingNone,
      border: border5,
      filled: true,
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(color: Colors.white, width: 0.0),
      ),
      fillColor: Colors.white,
      hintText: text);
}

gotoPage(context, page) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

retPage(context) {
  Navigator.pop(context);
}

getDiff(timestamp) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  var moment = Moment.now();
  var fr = moment.from(date);
  zlog(fr);
  return fr;
}

Future<bool> checkNet() async {
  try {
    final result = await InternetAddress.lookup('10.10.10.230');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }

  return false;
}

var shapeRndBorder10 =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));

var shapeRndBorder20 =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));

var paddingNone = EdgeInsets.all(0);
var paddingSmall = EdgeInsets.all(cstPadSmall);

var border5 = OutlineInputBorder(borderRadius: BorderRadius.circular(5.0));

const ts14BbD =
    TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colBaseDisable);
txt14BbD(text) {
  return Text(text, style: ts14BbD);
}

const ts15 = TextStyle(fontSize: 12);
txt15(text) {
  return Text(text, style: ts15);
}

const ts15W = TextStyle(fontSize: 12, color: Colors.white);
txt15W(text) {
  return Text(text, style: ts15W);
}

const ts15BbD =
    TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colBaseDisable);
txt15BbD(text) {
  return Text(text, style: ts15BbD);
}

const ts16BbD =
    TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colBaseDisable);
txt16BbD(text) {
  return Text(text, style: ts16BbD);
}

const ts16BW =
    TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white);
txt16BW(text) {
  return Text(text, style: ts16BW);
}

const ts17 = TextStyle(fontSize: 14, color: Colors.black);
txt17(text) {
  return Text(text, style: ts17);
}

const ts17bC = TextStyle(fontSize: 14, color: colBase);
txt17bC(text) {
  return Text(text, style: ts17bC);
}

const ts17B =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
txt17B(text) {
  return Text(text, style: ts17B);
}

const ts17BW =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
txt17BW(text) {
  return Text(text, style: ts17BW);
}

const ts17BbC =
    TextStyle(fontSize: 14, color: colBase, fontWeight: FontWeight.bold);
txt17BbC(text) {
  return Text(text, style: ts17BbC);
}

const ts17BbD =
    TextStyle(fontSize: 14, color: colBaseDisable, fontWeight: FontWeight.bold);
txt17BbD(text) {
  return Text(text, style: ts17BbD);
}

const ts18 = TextStyle(fontSize: 15, color: Colors.black);
txt18(text) {
  return Text(text, style: ts18);
}

const ts18B =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
txt18B(text) {
  return Text(text, style: ts18B);
}

const ts18BbC =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colBase);
txt18BbC(text) {
  return Text(text, style: ts18BbC);
}

const ts18BbD =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colBaseDisable);
txt18BbD(text) {
  return Text(text, style: ts18BbD);
}

const ts19B =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
txt19B(text) {
  return Text(text, style: ts19B);
}

const ts19BbC =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colBase);
txt19BbC(text) {
  return Text(text, style: ts19BbC);
}

const ts19BgC = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF425765));
txt19BgC(text) {
  return Text(text, style: ts19BgC);
}

const ts20 = TextStyle(fontSize: 17, color: Colors.black);
txt20(text) {
  return Text(text, style: ts20);
}

const ts20B =
    TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black);
txt20B(text) {
  return Text(text, style: ts20B);
}

const ts20BbC =
    TextStyle(fontSize: 17, color: colBase, fontWeight: FontWeight.bold);
txt20BbC(text) {
  return Text(text, style: ts20BbC);
}

const ts20BbD =
    TextStyle(color: colBaseDisable, fontSize: 17, fontWeight: FontWeight.bold);
txt20BbD(text) {
  return Text(text, style: ts20BbD);
}

const ts20BW =
    TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);
txt20BW(text) {
  return Text(text, style: ts20BW);
}

const ts22B =
    TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);
txt22B(text) {
  return Text(text, style: ts22B);
}

const ts24B =
    TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold);
txt24B(text) {
  return Text(text, style: ts24B);
}

const ts24BR =
    TextStyle(fontSize: 19, color: colRed, fontWeight: FontWeight.bold);
txt24BR(text) {
  return Text(text, style: ts24BR);
}


getCourseThumbnail(id) {
  return resUrl +
      "thumbnails/course_thumbnails/course_thumbnail_default_" +
      id.toString() +
      ".jpg";
  // return resUrl + "thumbnails/course_thumbnails/course-thumbnail.png";
}

getCateThumbnail(thumb) {
  return resUrl + "thumbnails/category_thumbnails/" + thumb.toString();
}

getInstructorImg(thumb) {
  return resUrl + "user_image/placeholder.png";
}

uiIconText(icon, text) {
  return Row(
      children: <Widget>[Icon(icon, color: colBase), txt18("  " + text)]);
}

var progress = Container(
    child: new Stack(children: <Widget>[
  Container(
      alignment: AlignmentDirectional.center,
      decoration: new BoxDecoration(
        color: Colors.white70,
      ),
      child: new Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(10.0)),
          width: 300.0,
          height: 120.0,
          alignment: AlignmentDirectional.center,
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: new CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                        child: new Text(
                      "",
                      style: new TextStyle(fontSize: 24, color: colBase),
                    )))
              ])))
]));

viewCard(context, item) {
  return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // Calling Course Page
            // param: course id
            glob['course_id'] = item['id'];
            gotoPage(context, CoursePage());
          },
          child: Container(
              width: 160,
              child: Row(children: <Widget>[
                CachedNetworkImage(
                    imageUrl: getCourseThumbnail(item['id']),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover),
                SizedBox(width: cstPadSmall),
                Column(children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: glob['scrWidth'] - 125,
                    child: txt17B(item['title']),
                  ),
                  SizedBox(
                      width: glob['scrWidth'] - 125,
                      child: txt15(item['first_name'].toString() +
                          ' ' +
                          item['last_name'].toString())),
                  SizedBox(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            star(item['rating'].toDouble(), true, 18.0),
                            txt15BbD("   0 (0)")
                          ]),
                          txt17B(item['price'].toString() == '0'
                              ? 'Free'
                              : item['price'].toString() + 'ks')
                        ]),
                    width: glob['scrWidth'] - 125,
                  )
                ])
              ]))));
}

/*
const ts14BbD =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colBaseDisable);
txt14BbD(text) {
  return Text(text, style: ts14BbD);
}

const ts15 = TextStyle(fontSize: 15);
txt15(text) {
  return Text(text, style: ts15);
}

const ts15W = TextStyle(fontSize: 15, color: Colors.white);
txt15W(text) {
  return Text(text, style: ts15W);
}

const ts15BbD =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colBaseDisable);
txt15BbD(text) {
  return Text(text, style: ts15BbD);
}

const ts16BbD =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colBaseDisable);
txt16BbD(text) {
  return Text(text, style: ts16BbD);
}

const ts17 = TextStyle(fontSize: 17, color: Colors.black);
txt17(text) {
  return Text(text, style: ts17);
}

const ts17bC = TextStyle(fontSize: 17, color: colBase);
txt17bC(text) {
  return Text(text, style: ts17bC);
}

const ts17B =
    TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black);
txt17B(text) {
  return Text(text, style: ts17B);
}

const ts17BW =
    TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white);
txt17BW(text) {
  return Text(text, style: ts17BW);
}

const ts17BbC =
    TextStyle(fontSize: 17, color: colBase, fontWeight: FontWeight.bold);
txt17BbC(text) {
  return Text(text, style: ts17BbC);
}

const ts17BbD =
    TextStyle(fontSize: 17, color: colBaseDisable, fontWeight: FontWeight.bold);
txt17BbD(text) {
  return Text(text, style: ts17BbD);
}

const ts18 = TextStyle(fontSize: 18, color: Colors.black);
txt18(text) {
  return Text(text, style: ts18);
}

const ts18B =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
txt18B(text) {
  return Text(text, style: ts18B);
}

const ts18BbC =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colBase);
txt18BbC(text) {
  return Text(text, style: ts18BbC);
}

const ts18BbD =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colBaseDisable);
txt18BbD(text) {
  return Text(text, style: ts18BbD);
}

const ts19B =
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black);
txt19B(text) {
  return Text(text, style: ts19B);
}

const ts19BbC =
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: colBase);
txt19BbC(text) {
  return Text(text, style: ts19BbC);
}

const ts19BgC =
    TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Color(0xFF425765));
txt19BgC(text) {
  return Text(text, style: ts19BgC);
}

const ts20 = TextStyle(fontSize: 20, color: Colors.black);
txt20(text) {
  return Text(text, style: ts20);
}

const ts20B =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
txt20B(text) {
  return Text(text, style: ts20B);
}

const ts20BbC =
    TextStyle(fontSize: 20, color: colBase, fontWeight: FontWeight.bold);
txt20BbC(text) {
  return Text(text, style: ts20BbC);
}

const ts20BbD =
    TextStyle(color: colBaseDisable, fontSize: 20, fontWeight: FontWeight.bold);
txt20BbD(text) {
  return Text(text, style: ts20BbD);
}

const ts20BW =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
txt20BW(text) {
  return Text(text, style: ts20BW);
}

const ts22B =
    TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold);
txt22B(text) {
  return Text(text, style: ts22B);
}
*/
