// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:elite_fm2/screens/blogpage.dart';
import 'package:elite_fm2/screens/contactpage.dart';
import 'package:elite_fm2/screens/elitefmpage.dart';
import 'package:elite_fm2/screens/podplayer.dart';
import 'package:elite_fm2/screens/podslist.dart';
import 'package:elite_fm2/screens/schedulepage.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';

class MaterialNavBar extends StatefulWidget {
  const MaterialNavBar({Key? key, this.i = 2}) : super(key: key);

  @override
  _MaterialNavBarState createState() => _MaterialNavBarState();
  final int? i;
}

class _MaterialNavBarState extends State<MaterialNavBar> {
  int _selectedItem = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    ContactPage(),
    SchedulePage(),
    ElitefmPage(),
    PodsList(),
    BlogPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedItem = widget.i!;
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
        backgroundColor: blackColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[900],
          fixedColor: whiteColor,
          iconSize: 35,
          unselectedItemColor: whiteColor,
          unselectedLabelStyle: TextStyle(fontSize: 8),
          selectedLabelStyle: TextStyle(fontSize: 8),
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/phone.png'),
                color: redColor,
              ),
              label: "Contact",
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/calendar.png'),
                  color: redColor,
                ),
                label: "Schedule"),
            BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage('assets/navbarplay.png'),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/microphone.png'),
                  color: redColor,
                ),
                label: "Podcast"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/blog.png'),
                  color: redColor,
                ),
                label: "Blog"),
          ],
          onTap: (val) {
            setState(() {
              _selectedItem = val;
            });
          },
          currentIndex: 2,
        ),

        // CustomBottomNavigationBar(
        //   // ignore: prefer_const_literals_to_create_immutables
        //   buttonList: [
        //     "Contact",
        //     "Schedule",
        //     "Play",
        //     "Podcast",
        //     "Blog",
        //   ],
        //   onChange: (val) {
        //     setState(() {
        //       _selectedItem = val;
        //     });
        //   },
        //   defaultSelectedIndex: 1,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: _selectedItem != 3
        //     ? SizedBox(
        //         height: 140,
        //         width: 140,
        //         child: Padding(
        //           padding: const EdgeInsets.only(bottom: 12.0),
        //           child: AvatarGlow(
        //             glowColor: Colors.red,
        //             endRadius: 60.0,
        //             duration: Duration(milliseconds: 3000),
        //             repeat: true,
        //             showTwoGlows: true,
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   _selectedItem = 3;
        //                 });
        //               },
        //               child: Material(
        //                 // Replace this child with your own
        //                 elevation: 8.0,
        //                 // shadowColor: redColor,
        //                 shape: CircleBorder(),
        //                 child: CircleAvatar(
        //                   backgroundColor: Color(0xff171717),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       SvgPicture.asset(
        //                         'assets/live.svg',
        //                         height: 45,
        //                         width: 45,
        //                       ),
        //                       SizedBox(
        //                         height: 3,
        //                       ),
        //                       Text(
        //                         "Live",
        //                         style: TextStyle(color: redColor, fontSize: 12),
        //                       ),
        //                     ],
        //                   ),
        //                   radius: 40.0,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink(),
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
  List _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _buttonList = widget.buttonList;
    _iconList = widget.buttonList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _buttonList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_buttonList[i], i, Icons.call));
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildNavBarItem(_buttonList[0], 0, Icons.phone),
                buildNavBarItem(_buttonList[1], 1, Icons.calendar_today),
                buildNavBarItem(_buttonList[2], 2, Icons.play_arrow_rounded),
                buildNavBarItem(_buttonList[3], 3, Icons.mic),
                buildNavBarItem(_buttonList[4], 4, Icons.pages),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBarItem(String text, int index, IconData iconData) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            iconData,
            color: redColor,
            size: 30,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: TextStyle(color: whiteColor, fontSize: 10),
          )
          // Container(
          //   padding: EdgeInsets.only(left: 8, right: 8),
          //   width: MediaQuery.of(context).size.width / _buttonList.length,
          //   child: Container(
          //     height: 40,
          //     // width: 100,
          //     decoration: BoxDecoration(
          //         color: redColor, borderRadius: BorderRadius.circular(10)),
          //     child: Center(
          //       child: Text(
          //         text,
          //         style: TextStyle(color: whiteColor, fontSize: 12),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
