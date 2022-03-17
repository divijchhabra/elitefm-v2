// ignore_for_file: prefer_const_constructors

import 'package:elite_fm2/utils/constants.dart';
import 'package:elite_fm2/utils/maintitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future onSelectNotification(String? payload) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("ALERT"),
              content: Text("CONTENT"),
            ));
  }

  List<bool> _states = [];

  showNotification(QueryDocumentSnapshot<Object?> document, String day) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    int dayNumber = day == 'Sunday'
        ? 1
        : day == 'Monday'
            ? 2
            : day == 'Tuesday'
                ? 3
                : day == 'Wednesday'
                    ? 4
                    : day == 'Thursday'
                        ? 5
                        : day == 'Friday'
                            ? 6
                            : day == 'Saturday'
                                ? 7
                                : 1;

    await flutterLocalNotificationsPlugin!.showWeeklyAtDayAndTime(
        2,
        '${document['showname']} is Live!',
        '',
        Day(dayNumber),
        Time(document['starttime'], 0, 0),
        platformChannelSpecifics);
    final snackBar = SnackBar(content: Text('Reminder Added!'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    /*
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

     */
  }

  Future<dynamic> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("f"),
        content: Text("g"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _states.addAll([false, false, false, false, false, false, false]);
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    initilise();
  }

  initilise() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('elitefmlogo');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  int? selected;
  @override
  Widget build(BuildContext context) {
    print('ff');
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(
                height: 30,
              ),
              mainTitle("Schedule", 230),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.all(0),
                            expansionCallback: (int index, bool value) {
                              setState(() {
                                for (int i = 0; i < _states.length; i++) {
                                  if (i != index) {
                                    _states[i] = false;
                                  }
                                }
                                _states[index] = !_states[index];
                              });
                            },
                            children: [
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[0],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Monday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Column(
                                  children: [
                                    Container(
                                      height: 270,
                                      // padding: EdgeInsets.only(left: 20, right: 20),
                                      color: blackColor,
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("studio")
                                              .doc("Monday")
                                              .collection("schedule")
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            return !snapshot.hasData
                                                ? Text("Sorry no show availabe")
                                                : ListView(
                                                    children: snapshot
                                                        .data!.docs
                                                        .map((document) {
                                                      return Column(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child: ListTile(
                                                                  visualDensity:
                                                                      VisualDensity(
                                                                          horizontal:
                                                                              -4,
                                                                          vertical:
                                                                              -4),
                                                                  dense: true,
                                                                  // visualDensity: ,
                                                                  minVerticalPadding:
                                                                      0,
                                                                  horizontalTitleGap:
                                                                      0,
                                                                  minLeadingWidth:
                                                                      0,
                                                                  trailing:
                                                                      SizedBox(
                                                                    width: 60,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        GestureDetector(
                                                                          child:
                                                                              Icon(
                                                                            Icons.notifications,
                                                                            color:
                                                                                redColor,
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            print('start');
                                                                            await showNotification(document,
                                                                                'Monday');
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Share.share('rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.share,
                                                                            color:
                                                                                redColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  leading:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            18.0,
                                                                        top: 3),
                                                                    child: Icon(
                                                                      Icons
                                                                          .circle,
                                                                      size: 15,
                                                                      color:
                                                                          redColor,
                                                                    ),
                                                                  ),
                                                                  title: Text(
                                                                    ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          redColor,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),

                                                                  subtitle:
                                                                      Text(
                                                                    document[
                                                                        "showname"],
                                                                    style: TextStyle(
                                                                        color:
                                                                            whiteColor,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ),
                                                              ),
                                                              document["starttime"] ==
                                                                      2
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/redline.svg',
                                                                        // height: 20,
                                                                        width:
                                                                            500,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child:
                                                                          Divider(
                                                                        // endIndent: 30,
                                                                        thickness:
                                                                            1,
                                                                        color:
                                                                            lineColor,
                                                                      )),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[1],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Tuesday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Container(
                                  height: 270,
                                  // padding: EdgeInsets.only(left: 20, right: 20),
                                  color: blackColor,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("studio")
                                          .doc("Tuesday")
                                          .collection("schedule")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return !snapshot.hasData
                                            ? Text("Sorry no show availabe")
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map((document) {
                                                  return Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              dense: true,
                                                              // visualDensity: ,
                                                              minVerticalPadding:
                                                                  0,
                                                              horizontalTitleGap:
                                                                  0,
                                                              minLeadingWidth:
                                                                  0,
                                                              trailing:
                                                                  SizedBox(
                                                                width: 60,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showNotification(
                                                                            document,
                                                                            'Tuesday');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .notifications,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Share.share(
                                                                            'rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .share,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              leading: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            18.0,
                                                                        top: 3),
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  size: 15,
                                                                  color:
                                                                      redColor,
                                                                ),
                                                              ),
                                                              title: Text(
                                                                ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      redColor,
                                                                  fontSize: 12,
                                                                ),
                                                              ),

                                                              subtitle: Text(
                                                                document[
                                                                    "showname"],
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                          document["starttime"] ==
                                                                  2
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/redline.svg',
                                                                    // height: 20,
                                                                    width: 500,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      Divider(
                                                                    // endIndent: 30,
                                                                    thickness:
                                                                        1,
                                                                    color:
                                                                        lineColor,
                                                                  )),
                                                        ],
                                                      ),
                                                      /*
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20,right: 20),
                                                    child: SvgPicture.asset(
                                                      'assets/redline.svg',
                                                      // height: 20,
                                                      width: 500,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),

                                                   */
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                      }),
                                ),
                              ),
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[2],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Wednesday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Container(
                                  height: 270,
                                  // padding: EdgeInsets.only(left: 20, right: 20),
                                  color: blackColor,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("studio")
                                          .doc("Wednesday")
                                          .collection("schedule")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return !snapshot.hasData
                                            ? Text("Sorry no show availabe")
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map((document) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 20),
                                                        child: ListTile(
                                                          visualDensity:
                                                              VisualDensity(
                                                                  horizontal:
                                                                      -4,
                                                                  vertical: -4),
                                                          dense: true,
                                                          // visualDensity: ,
                                                          minVerticalPadding: 0,
                                                          horizontalTitleGap: 0,
                                                          minLeadingWidth: 0,
                                                          trailing: SizedBox(
                                                            width: 60,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    await showNotification(
                                                                        document,
                                                                        'Wednesday');
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .notifications,
                                                                    color:
                                                                        redColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Share.share(
                                                                        'rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                  },
                                                                  child: Icon(
                                                                    Icons.share,
                                                                    color:
                                                                        redColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          leading: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 18.0,
                                                                    top: 3),
                                                            child: Icon(
                                                              Icons.circle,
                                                              size: 15,
                                                              color: redColor,
                                                            ),
                                                          ),
                                                          title: Text(
                                                            ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                            style: TextStyle(
                                                              color: redColor,
                                                              fontSize: 12,
                                                            ),
                                                          ),

                                                          subtitle: Text(
                                                            document[
                                                                "showname"],
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                      document["starttime"] == 2
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/redline.svg',
                                                                // height: 20,
                                                                width: 500,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: Divider(
                                                                // endIndent: 30,
                                                                thickness: 1,
                                                                color:
                                                                    lineColor,
                                                              )),
                                                      /*
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20,right: 20),
                                                    child: SvgPicture.asset(
                                                      'assets/redline.svg',
                                                      // height: 20,
                                                      width: 500,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
*/
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                      }),
                                ),
                              ),
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[3],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Thursday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Container(
                                  height: 270,
                                  // padding: EdgeInsets.only(left: 20, right: 20),
                                  color: blackColor,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("studio")
                                          .doc("Thursday")
                                          .collection("schedule")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return !snapshot.hasData
                                            ? Text(
                                                'Sorry no shows available',
                                                style: TextStyle(
                                                  color: redColor,
                                                  fontSize: 12,
                                                ),
                                              )
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map((document) {
                                                  return Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              dense: true,
                                                              // visualDensity: ,
                                                              minVerticalPadding:
                                                                  0,
                                                              horizontalTitleGap:
                                                                  0,
                                                              minLeadingWidth:
                                                                  0,
                                                              trailing:
                                                                  SizedBox(
                                                                width: 60,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showNotification(
                                                                            document,
                                                                            'Thursday');
                                                                        print(
                                                                            'done');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .notifications,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Share.share(
                                                                            'rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .share,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              leading: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            18.0,
                                                                        top: 3),
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  size: 15,
                                                                  color:
                                                                      redColor,
                                                                ),
                                                              ),
                                                              title: Text(
                                                                ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      redColor,
                                                                  fontSize: 12,
                                                                ),
                                                              ),

                                                              subtitle: Text(
                                                                document[
                                                                    "showname"],
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                          document["starttime"] ==
                                                                  2
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/redline.svg',
                                                                    // height: 20,
                                                                    width: 500,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      Divider(
                                                                    // endIndent: 30,
                                                                    thickness:
                                                                        1,
                                                                    color:
                                                                        lineColor,
                                                                  )),
                                                        ],
                                                      ),
                                                      /*
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20,right: 20),
                                                    child: SvgPicture.asset(
                                                      'assets/redline.svg',
                                                      // height: 20,
                                                      width: 500,
                                                      fit: BoxFit.cover,
                                                    ),


                                                  ),

                                                   */
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                      }),
                                ),
                              ),
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[4],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Friday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Container(
                                  height: 270,
                                  // padding: EdgeInsets.only(left: 20, right: 20),
                                  color: blackColor,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("studio")
                                          .doc("Friday")
                                          .collection("schedule")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return !snapshot.hasData
                                            ? Text("Sorry no show availabe")
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map((document) {
                                                  return Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              dense: true,
                                                              // visualDensity: ,
                                                              minVerticalPadding:
                                                                  0,
                                                              horizontalTitleGap:
                                                                  0,
                                                              minLeadingWidth:
                                                                  0,
                                                              trailing:
                                                                  SizedBox(
                                                                width: 60,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showNotification(
                                                                            document,
                                                                            'Friday');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .notifications,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Share.share(
                                                                            'rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .share,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              leading: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            18.0,
                                                                        top: 3),
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  size: 15,
                                                                  color:
                                                                      redColor,
                                                                ),
                                                              ),
                                                              title: Text(
                                                                ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      redColor,
                                                                  fontSize: 12,
                                                                ),
                                                              ),

                                                              subtitle: Text(
                                                                document[
                                                                    "showname"],
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                          document["starttime"] ==
                                                                  2
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/redline.svg',
                                                                    // height: 20,
                                                                    width: 500,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      Divider(
                                                                    // endIndent: 30,
                                                                    thickness:
                                                                        1,
                                                                    color:
                                                                        lineColor,
                                                                  )),
                                                        ],
                                                      ),
                                                      /*
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20,right: 20),
                                                    child: SvgPicture.asset(
                                                      'assets/redline.svg',
                                                      // height: 20,
                                                      width: 500,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),

                                                   */
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                      }),
                                ),
                              ),
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[5],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Saturday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Container(
                                  height: 270,
                                  // padding: EdgeInsets.only(left: 20, right: 20),
                                  color: blackColor,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("studio")
                                          .doc("Saturday")
                                          .collection("schedule")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return !snapshot.hasData
                                            ? Text("Sorry no show availabe")
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map((document) {
                                                  return Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              dense: true,
                                                              // visualDensity: ,
                                                              minVerticalPadding:
                                                                  0,
                                                              horizontalTitleGap:
                                                                  0,
                                                              minLeadingWidth:
                                                                  0,
                                                              trailing:
                                                                  SizedBox(
                                                                width: 60,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showNotification(
                                                                            document,
                                                                            'Saturday');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .notifications,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Share.share(
                                                                            'rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .share,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              leading: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            18.0,
                                                                        top: 3),
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  size: 15,
                                                                  color:
                                                                      redColor,
                                                                ),
                                                              ),
                                                              title: Text(
                                                                ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      redColor,
                                                                  fontSize: 12,
                                                                ),
                                                              ),

                                                              subtitle: Text(
                                                                document[
                                                                    "showname"],
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                          document["starttime"] ==
                                                                  2
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/redline.svg',
                                                                    // height: 20,
                                                                    width: 500,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      Divider(
                                                                    // endIndent: 30,
                                                                    thickness:
                                                                        1,
                                                                    color:
                                                                        lineColor,
                                                                  )),
                                                        ],
                                                      ),
                                                      /*
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20,right: 20),
                                                    child: SvgPicture.asset(
                                                      'assets/redline.svg',
                                                      // height: 20,
                                                      width: 500,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),

                                                   */
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                      }),
                                ),
                              ),
                              ExpansionPanel(
                                hasIcon: false,
                                canTapOnHeader: true,
                                backgroundColor: blackColor,
                                isExpanded: _states[6],
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) =>
                                        ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  dense: true,
                                  minVerticalPadding: 0,
                                  // lead ing: Icon(FontAwesomeIcons.bookmark),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Sunday",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: lineColor,
                                    ),
                                  ),
                                ),
                                body: Container(
                                  height: 270,
                                  // padding: EdgeInsets.only(left: 20, right: 20),
                                  color: blackColor,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("studio")
                                          .doc("Sunday")
                                          .collection("schedule")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return !snapshot.hasData
                                            ? Text("Sorry no show availabe")
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map((document) {
                                                  return Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              dense: true,
                                                              // visualDensity: ,
                                                              minVerticalPadding:
                                                                  0,
                                                              horizontalTitleGap:
                                                                  0,
                                                              minLeadingWidth:
                                                                  0,
                                                              trailing:
                                                                  SizedBox(
                                                                width: 60,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await showNotification(
                                                                            document,
                                                                            'Sunday');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .notifications,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Share.share(
                                                                            'rj name : ${document["showname"]} , timings : ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00');
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .share,
                                                                        color:
                                                                            redColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              leading: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            18.0,
                                                                        top: 3),
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  size: 15,
                                                                  color:
                                                                      redColor,
                                                                ),
                                                              ),
                                                              title: Text(
                                                                ' ${document["starttime"] > 24 ? document["starttime"] - 24 : document["starttime"]}:00 - ${document["endtime"] > 24 ? document["endtime"] - 24 : document["endtime"]}:00',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      redColor,
                                                                  fontSize: 12,
                                                                ),
                                                              ),

                                                              subtitle: Text(
                                                                document[
                                                                    "showname"],
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                          document["starttime"] ==
                                                                  2
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/redline.svg',
                                                                    // height: 20,
                                                                    width: 500,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      Divider(
                                                                    // endIndent: 30,
                                                                    thickness:
                                                                        1,
                                                                    color:
                                                                        lineColor,
                                                                  )),
                                                        ],
                                                      ),
                                                      /*
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20,right: 20),
                                                    child: SvgPicture.asset(
                                                      'assets/redline.svg',
                                                      // height: 20,
                                                      width: 500,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),

                                                   */
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
