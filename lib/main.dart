import 'package:elite_fm2/screens/splash_screen.dart';
import 'package:elite_fm2/utils/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:elite_fm2/screens/elitefmpage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'screens/blogpage.dart';
import 'utils/bottomnavbar.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool goToBlog = false;
void main() async {
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await Firebase.initializeApp();
  try {
    final messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    var token = await messaging.getToken();
    print('token $token');
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.title);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!${message.data}');

      // if (message.data["key"] == "blog") {

      Navigator.pushReplacement(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => MaterialNavBar(
                    i: 2,
                  )));
      // }
    });

    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    print('User granted permission: ${settings.authorizationStatus}');
  } catch (e) {}
  if (Platform.isAndroid)
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  runApp(MyApp(
    goToBlog: goToBlog,
  ));
  WidgetsBinding.instance!.addObserver(new _Handler());
}

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      justplayer.dispose();
      exit(0);
    } else {}
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class MyApp extends StatefulWidget {
  final bool goToBlog;
  MyApp({this.goToBlog = false});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    justplayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Elite FM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Azonix',
      ),
      home: SplashScreen(),
    );
  }
}
