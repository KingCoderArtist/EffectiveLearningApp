import 'package:effectivelearning/board/main.dart';
import 'package:effectivelearning/globals.dart';
import 'package:flutter/material.dart';
import 'package:effectivelearning/helper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FilterPage extends StatefulWidget {
  const FilterPage();
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool _loadingFlag = false;
  String _selectedPrice = glob['price'];
  String _selectedLevel = glob['level'];
  String _selectedLanguage = glob['language'];
  double _rating = glob['minrating'];
  List<String> _prices = [
    'All',
    'Paid',
    'Free',
  ];
  List<String> _levels = [
    'All',
    'Beginner',
    'Advanced',
  ];
  List<String> _languages = [
    'All',
    'English',
    'Myanmar',
  ];

  dynamic question = glob['question'];
  final ctrlEditTitle = TextEditingController();
  final ctrlEditBody = TextEditingController();

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
                  FlatButton(
                    child: txt19BbC("Reset"),
                    onPressed: () {
                      glob['price'] = 'All';
                      glob['level'] = 'All';
                      glob['language'] = 'All';
                      glob['minrating'] = 0.0;
                      retPage(context);
                      retPage(context);
                      gotoPage(context, MainPage());
                    },
                  ),
                  Spacer(),
                  txt20B("Filter Courses"),
                  Spacer(),
                  FlatButton(
                    child: txt19BbC("Apply"),
                    onPressed: () {
                      glob['price'] = _selectedPrice;
                      glob['level'] = _selectedLevel;
                      glob['language'] = _selectedLanguage;
                      glob['minrating'] = _rating;
                      retPage(context);
                      retPage(context);
                      gotoPage(context, MainPage());
                    },
                  ),
                ],
              ),
              divider,
              SizedBox(
                width: scrWidth * 0.9,
                child: Row(
                  children: <Widget>[
                    txt18BbD("Price:              "),
                    Flexible(child:DropdownButton(
                      value: _selectedPrice,
                      isExpanded: true,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPrice = newValue;
                        });
                      },
                      items: _prices.map((location) {
                        return DropdownMenuItem(
                          child: txt18(location),
                          value: location,
                        );
                      }).toList(),
                    ))
                  ],
                ),
              ),
              SizedBox(
                width: scrWidth * 0.9,
                child: Row(
                  children: <Widget>[
                    txt18BbD("Level:              "),
                    Flexible(child: DropdownButton(
                      isExpanded: true,
                      value: _selectedLevel,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLevel = newValue;
                        });
                      },
                      items: _levels.map((location) {
                        return DropdownMenuItem(
                          child: txt18(location),
                          value: location,
                        );
                      }).toList(),
                    ),)
                    
                  ],
                ),
              ),
              SizedBox(
                width: scrWidth * 0.9,
                child: Row(
                  children: <Widget>[
                    txt18BbD("Language:     "),
                    Flexible(child:DropdownButton(
                      isExpanded: true,
                      value: _selectedLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                      },
                      items: _languages.map((location) {
                        return DropdownMenuItem(
                          child: txt18(location),
                          value: location,
                        );
                      }).toList(),
                    ))
                  ],
                ),
              ),
              SizedBox(
                width: scrWidth * 0.9,
                child: Row(
                  children: <Widget>[
                    txt18BbD("Minimum Rating:     "),
                    SmoothStarRating(
                        rating: glob['minrating'],
                        isReadOnly: false,
                        size: 26.0,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        color: Colors.amber,
                        onRated: (v) {
                          _rating = v;
                        },
                        borderColor: Colors.amber,
                        starCount: 5,
                        allowHalfRating: false,
                        spacing: 0.0),
                  ],
                ),
              ),
            ])));
  }
}
