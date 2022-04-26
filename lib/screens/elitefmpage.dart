// ignore_for_file: prefer_const_constructors
import 'package:elite_fm2/utils/gettest.dart';
import 'package:volume_watcher/volume_watcher.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibration/vibration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

bool isplay = false;
final justplayer = AudioPlayer();
double? initVolumee = 0;
double? maxVolumee = 0;
double currentVolume = 0;
bool buttonsListener = false;
String audioUrl = "http://carina.streamerr.co:8114/stream";
bool firstTime = true;

class ElitefmPage extends StatefulWidget {
  const ElitefmPage({Key? key}) : super(key: key);

  @override
  _ElitefmPageState createState() => _ElitefmPageState();
}

class _ElitefmPageState extends State<ElitefmPage> {
  String _platformVersion = 'Unknown';

  AssetImage img = AssetImage('assets/playicons.png');
// example: Image.asset('images/camera.png',)
  AssetImage playy = AssetImage(
    'assets/playicons.png',
  );
  AssetImage pausee = AssetImage(
    'assets/pauseicon.png',
  );
  late String showname = "";
  //String _platformVersion = 'Unknown';
  Future<void> initPlatformState() async {
    setState(() {
      buttonsListener = false;
    });
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      VolumeWatcher.hideVolumeView = false;
      platformVersion = await VolumeWatcher.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    double? initVolume;
    double? maxVolume;
    try {
      initVolume = await VolumeWatcher.getCurrentVolume;
      maxVolume = await VolumeWatcher.getMaxVolume;
    } on PlatformException {
      platformVersion = 'Failed to get volume.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      initVolumee = initVolume;
      currentVolume = initVolume!;
      maxVolumee = maxVolume;
    });
  }

  //int time = 9;
  volumeListener() async {
    if (!buttonsListener) {
      currentVolume = await VolumeWatcher.getCurrentVolume;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // Initial playback. Preloaded playback information
    initPlatformState();

    updateUrl();
    setSource();
    getName();
    volumeListener();

    super.initState();
  }

  _incrementValue() async {
    setState(() {
      buttonsListener = true;
    });

    if (currentVolume < 1) {
      currentVolume += 0.01;
      double vol = await VolumeWatcher.getCurrentVolume;

      await VolumeWatcher.setVolume(vol + 0.01);
      // await VolumeWatcher.setVolume(currentVolume);
    }
  }

  _decrementValue() async {
    setState(() {
      buttonsListener = true;
    });

    if (currentVolume > 0.1) {
      currentVolume -= 0.01;
      await VolumeWatcher.setVolume(currentVolume);
    }
  }

  void getName() async {
    var date = DateTime.now();
    print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
    print(DateFormat('EEEE').format(date)); // prints Tuesday
    String formattedTime = DateFormat.Hm().format(date);
    print(formattedTime);
    String timee = formattedTime.substring(0, 2);
    var time = int.parse(timee);
    assert(time is int);
    print(time);
    final studio = FirebaseFirestore.instance
        .collection('studio')
        .doc(DateFormat('EEEE').format(date))
        .collection("schedule");
    QuerySnapshot query =
        await studio.where('starttime', isLessThanOrEqualTo: time).get();
    for (var element in query.docs) {
      if ((element.data() as dynamic)["starttime"] <= time &&
          (element.data() as dynamic)["endtime"] > time) {
        setState(() {
          showname = (element.data() as dynamic)["showname"];
        });
      }
    }
  }

  updateUrl() async {
    FirebaseFirestore.instance
        .collection('liveAudio')
        .doc('audio')
        .get()
        .then((value) {
      setState(() {
        audioUrl = value.data()!['link'];
      });
    });
  }

  setSource() async {
    if (RssData.audioPlayer.playing){
      await RssData.audioPlayer.stop();
      justplayer.setUrl('http://carina.streamerr.co:8114/stream');

    }else{
      if(!justplayer.playing){

        final _playlist = ConcatenatingAudioSource(children: [
          AudioSource.uri(
            Uri.parse(audioUrl),
            tag: MediaItem(
                id: 'w2',
                album: "Live now!",
                title: "Elite FM",
                artUri: Uri.parse(
                    "https://images.unsplash.com/photo-1561909381-3d716364ad47?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1463&q=80")),
          ),
        ]);
        await justplayer.setAudioSource(_playlist);
      }

    }


    setState(() {
      firstTime = false;
    });
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    justplayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await justplayer.setAudioSource(AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  AssetImage getimage() {
    if (justplayer.playing) {
      return img = AssetImage('assets/pauseicon.png');
    } else {
      return img = AssetImage('assets/playicons.png');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // justplayer.dispose();
    super.dispose();
  }

  Text getvolume() {
    print(currentVolume);
    if (currentVolume < 0.1) {
      return Text(
        '${currentVolume * 100}'.substring(0, 1),
        style: TextStyle(color: whiteColor, fontSize: 45),
      );
    } else if (currentVolume == 1 || currentVolume > 1) {
      return Text(
        '100',
        style: TextStyle(color: whiteColor, fontSize: 45),
      );
    } else {
      return Text(
        '${currentVolume * 100}'.substring(0, 2),
        style: TextStyle(color: whiteColor, fontSize: 45),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: volumeListener(),
          builder: (context, snapshot) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // SizedBox(
                    //   height: 10,
                    // ),
                    GestureDetector(
                      onTap: () {
                        // AudioManager.instance.play();
                        print("play");
                      },
                      child: Image(
                        height: size.height / 10,
                        width: size.width / 3,
                        image: AssetImage("assets/logoelitefm.png"),
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HoldDetector(
                          onCancel: () {
                            Future.delayed(Duration(seconds: 50)).then((value) {
                              setState(() {
                                buttonsListener = false;
                              });
                            });
                          },
                          onHold: () {
                            _decrementValue();
                          },
                          child: IconButton(
                            onPressed: () {
                              _decrementValue();
                              Future.delayed(Duration(seconds: 50))
                                  .then((value) {
                                setState(() {
                                  buttonsListener = false;
                                });
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              size: 30,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            getvolume(),
                            Text(
                              "Volume",
                              style: TextStyle(color: whiteColor, fontSize: 10),
                            )
                          ],
                        ),
                        HoldDetector(
                          onCancel: () {
                            Future.delayed(Duration(seconds: 100))
                                .then((value) {
                              setState(() {
                                buttonsListener = false;
                              });
                            });
                          },
                          onHold: () {
                            _incrementValue();
                          },
                          child: IconButton(
                            onPressed: () {
                              _incrementValue();
                              Future.delayed(Duration(seconds: 100))
                                  .then((value) {
                                setState(() {
                                  buttonsListener = false;
                                });
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: 30,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                              child: VolumeWatcher(
                            child: SliderTheme(
                              data: SliderThemeData(
                                  trackHeight: 5,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 6)),
                              child: SleekCircularSlider(
                                max: 1,
                                min: 0,
                                initialValue: currentVolume,
                                //initial value
                                innerWidget: (double value) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (RssData.audioPlayer.playing) {
                                        await RssData.audioPlayer.stop();
                                        setSource();
                                      }
                                      // if (!isplay &&
                                      //     justplayer.playerState.playing) {
                                      //   setSource();
                                      // }
                                      print('Already playing $isplay');
                                      print(
                                          'Player State ${justplayer.playerState.playing}');
                                      if (justplayer.playerState.playing) {
                                        // print('Already playing $isplay');
                                        if (Platform.isAndroid)
                                          Vibration.vibrate(duration: 50);
                                        justplayer.pause();
                                        setState(() {
                                          isplay = false;
                                        });
                                      } else if (!justplayer.playing) {
                                        if (Platform.isAndroid)
                                          Vibration.vibrate(duration: 50);
                                        if (firstTime) setSource();

                                        justplayer.play();
                                        setState(() {
                                          isplay = true;
                                        });
                                      } else {
                                        justplayer.play();
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        height: 400,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: justplayer
                                                      .playerState.playing
                                                  ? AssetImage(
                                                      'assets/pauseicon.png')
                                                  : AssetImage(
                                                      'assets/playicons.png'),
                                              fit:
                                                  justplayer.playerState.playing
                                                      ? BoxFit.contain
                                                      : BoxFit.contain),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                appearance: CircularSliderAppearance(
                                  size: size.height / 2.9,
                                  startAngle: 190,
                                  angleRange: 161,
                                  customWidths: CustomSliderWidths(
                                    trackWidth: 10,
                                    progressBarWidth: 14, //progress meter width
                                    handlerSize:
                                        10, // thing we select to drag progress
                                    shadowWidth: 10,
                                  ),
                                  customColors: CustomSliderColors(
                                    progressBarColors: [
                                      Color(0xffEE1C24),
                                      Color(0xffEE1C24),
                                      Color(0xffEE1C24),
                                      Color(0xffEE1C24),
                                      Color(0xffFCDEE0),
                                      Color(0xffFCDEE0),
                                    ],
                                    trackColor: Color(0xffFCDEE0),
                                    // trackColors: [
                                    //   // Color(0xffEE1C24),
                                    //   // Color(0xffEE1C24),
                                    //   Color(0xffFCDEE0),
                                    // ],
                                    dotColor: Colors.transparent,
                                  ),
                                ),
                                onChange: (double value) async {
                                  // int roundedValue = (value).ceil().toInt();
                                  // currentVolume = roundedValue.toDouble();
                                  currentVolume = value;
                                  await VolumeWatcher.setVolume(value);
                                  setState(() {});
                                },
                              ),
                            ),
                            onVolumeChangeListener: (double volume) async {
                              currentVolume = volume;

                              // await VolumeWatcher.setVolume(currentVolume);
                              // currentVolume= await VolumeWatcher.getCurrentVolume;
                              setState(() {});
                            },
                          )),
                        ),
                        Positioned(
                          top: 135,
                          left: 5,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width / 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Min",
                                  style: TextStyle(
                                    color: redColor,
                                  ),
                                ),
                                Text(
                                  "Max",
                                  style: TextStyle(
                                    color: redColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      showname.isEmpty ? "wait" : showname,
                      style: TextStyle(color: whiteColor, fontSize: 15),
                    ),
                    // SizedBox(
                    //   height: 80,
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
