// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:elite_fm2/screens/blogpage.dart';
import 'package:elite_fm2/screens/contactpage.dart';
import 'package:elite_fm2/screens/elitefmpage.dart';
import 'package:elite_fm2/screens/schedulepage.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';

class MaterialNavBar extends StatefulWidget {
  const MaterialNavBar({Key? key, this.i=3}) : super(key: key);

  @override
  _MaterialNavBarState createState() => _MaterialNavBarState();
  final int? i;
}

class _MaterialNavBarState extends State<MaterialNavBar> {
  int _selectedItem = 3;
  static const List<Widget> _widgetOptions = <Widget>[
    ContactPage(),
    SchedulePage(),
    BlogPage(),
    ElitefmPage(),
    // ProfilePage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedItem=widget.i!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: CustomBottomNavigationBar(
          // ignore: prefer_const_literals_to_create_immutables
          buttonList: [
            "Contact",
            "Schedule",
            "Blog",
          ],
          onChange: (val) {
            setState(() {
              _selectedItem = val;
            });
          },
          defaultSelectedIndex: 1,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _selectedItem != 3
            ? SizedBox(
                height: 140,
                width: 140,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: AvatarGlow(
                    glowColor: Colors.red,
                    endRadius: 60.0,
                    duration: Duration(milliseconds: 3000),
                    repeat: true,
                    showTwoGlows: true,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 3;
                        });
                      },
                      child: Material(
                        // Replace this child with your own
                        elevation: 8.0,
                        // shadowColor: redColor,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Color(0xff171717),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/live.svg',
                                height: 45,
                                width: 45,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Live",
                                style: TextStyle(color: redColor, fontSize: 12),
                              ),
                            ],
                          ),
                          radius: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
        body: _widgetOptions.elementAt(_selectedItem),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<String> buttonList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      required this.buttonList,
      required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List _buttonList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _buttonList = widget.buttonList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _buttonList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_buttonList[i], i));
    }

    return Container(
      color: Color(0xff1E1E1E),
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
          ),
          Container(
            // height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildNavBarItem(_buttonList[0], 0),
                buildNavBarItem(_buttonList[1], 1),
                buildNavBarItem(_buttonList[2], 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBarItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        width: MediaQuery.of(context).size.width / _buttonList.length,
        child: Container(
          height: 40,
          // width: 100,
          decoration: BoxDecoration(
              color: redColor, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: whiteColor, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
