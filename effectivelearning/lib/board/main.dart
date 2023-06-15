import 'package:effectivelearning/board/discover.dart';
import 'package:effectivelearning/globals.dart';
import 'package:effectivelearning/more/more.dart';
import 'package:effectivelearning/board/mycourses.dart';
import 'package:effectivelearning/board/notifications.dart';
import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selPage = 0;

  
  @override
  void initState() {
    super.initState();
    if(glob['offline']) {
      setState(() {
        _selPage = 1;
      });
    }
  }

  static const List<Widget> _pageOptions = <Widget>[
    DiscoverPage(),
    MyCoursesPage(),
    NotificationsPage(),
    MorePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          _selPage = 0;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colBack,
        body: _pageOptions.elementAt(_selPage),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), title: Text('My Courses')),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), title: Text('Notifications')),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz), title: Text('More'))
          ],
          currentIndex: _selPage,
          selectedItemColor: colBase,
          unselectedItemColor: Colors.black38,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          onTap: _onItemTapped,
        )));
  }
}
