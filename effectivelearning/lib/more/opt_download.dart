import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadOptPage extends StatefulWidget {
  const DownloadOptPage();
  @override
  _DownloadOptPageState createState() => _DownloadOptPageState();
}

class _DownloadOptPageState extends State<DownloadOptPage> {
  bool _loadingFlag = false;
  dynamic listPurchase;
  bool _enableWifi = true;
  bool _askLarge = true;
  int pixelSize = 1;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }
  _loadOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableWifi = (prefs.getBool('_enableWifi') ?? false);
      _askLarge = (prefs.getBool('_askLarge') ?? false);
      pixelSize = (prefs.getInt('pixelSize') ?? 0);
    });
  }
  _changeWifi(newValue) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _enableWifi = newValue;
        prefs.setBool('_enableWifi', newValue);
      });
  }
  _changeAsk(newValue) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _askLarge = newValue;
        prefs.setBool('_enableWifi', newValue);
      });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    pixelOptions(text, index){
      return FlatButton(
                child: Row(children: <Widget>[
                  txt19BgC(text),
                  Spacer(),
                  pixelSize == index? Icon(Icons.check, color: colBase,) : SizedBox()
                ],),
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    pixelSize = index;
                    prefs.setInt('pixelSize', index);
                  });
                },
              );
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
                  child: Container(
                    child: txt19B("Dowload & Playback Options"),
                    width: 200,
                  ),
                  width: scrWidth - 120),
              SizedBox(width: 40),
            ],
          ),
          Flexible(
              child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  sbLarge,
                  SizedBox(
                    width: 0.8 * scrWidth,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            txt19BgC("Download over Wi-Fi only"),
                            Spacer(),
                            Switch(
                              onChanged: (newValue) {
                                _changeWifi(newValue);
                              },
                              value: _enableWifi,
                              activeColor: colBase,
                            )
                          ],
                        ),
                        sbSmall,
                        Row(
                          children: <Widget>[
                            SizedBox(
                                child: txt19BgC(
                                    "Ask before downloading large resources"),
                                height: 40,
                                width: 0.8 * scrWidth - 100),
                            Spacer(),
                            Switch(
                              onChanged: (newValue) {
                                _changeAsk(newValue);
                              },
                              value: _askLarge,
                              activeColor: colBase,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  sbLarge,
                  SizedBox(
                    height: 110,
                    width: 0.9*scrWidth,
                    child: txt19BgC(
                        "  Select your quality preference for the videos you download. if the best video quality isn't available, then you'll get the next highest level."),
                  ),
                  SizedBox(
                    width: 0.8*scrWidth,
                    child: Column(children: <Widget>[
                      pixelOptions("360p (smallest file size)", 1),                      
                      divider,
                      pixelOptions("480p", 2),
                      divider,
                      pixelOptions("720p", 3),
                      divider,
                      pixelOptions("1080p (best video quality)", 4),
                      divider,
                      pixelOptions("Auto", 5),
                    ],),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
