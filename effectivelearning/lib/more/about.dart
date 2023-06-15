import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';

class AboutPage extends StatefulWidget {
  const AboutPage();
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
            child: Column(children: <Widget>[
              sbLarge,
              Row(
                children: <Widget>[
                  SizedBox(
                    child: FlatButton(
                        padding: EdgeInsets.only(left: 3),
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
                    width: 75,
                  ),
                  SizedBox(
                      child: Center(
                        child: txt20B("About Effective Learning"),
                      ),
                      width: scrWidth - 150),
                  SizedBox(width: 75),
                ],
              ),
              sbLarge,
              Flexible(
                  child: SingleChildScrollView(
                child: Center(
                    child: SizedBox(
                  width: scrWidth * 0.8,
                  child: txt18(
                      "  Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
                )),
              ))
            ])));
  }
}
