import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_utils/file_utils.dart';
import 'dart:math';

class DownloadPage extends StatefulWidget {
  const DownloadPage();
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  // final imgUrl = "https://effectivelearning.institute/uploads/system/home-banner.jpg";
  final imgUrl =
      "http://10.10.10.230/downloads/2020-05-21-LBEITM_L21_050214_eclass101_video.m4v";
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  var _onPressed;
  static final Random random = Random();
  Directory externalDir;

  @override
  Future<void> initState() {
    super.initState();
    downloadFile();
    getPermissions();
  }

  Future<void> getPermissions() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.storage].request();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    String dirloc = "";
    if (Platform.isAndroid) {
      dirloc = (await getExternalStorageDirectory()).path;
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    var randid = random.nextInt(10000);

    try {
      FileUtils.mkdir([dirloc]);
      await dio.download(imgUrl, dirloc + randid.toString() + ".mv4",
          onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          downloading = true;
          progress =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progress = "Download Completed.";
      path = dirloc + randid.toString() + ".mv4";
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Downloading File: $progress',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(path),
                    MaterialButton(
                      child: Text('Request Permission Again.'),
                      onPressed: _onPressed,
                      disabledColor: Colors.blueGrey,
                      color: Colors.pink,
                      textColor: Colors.white,
                      height: 40.0,
                      minWidth: 100.0,
                    ),
                  ],
                )));
}
