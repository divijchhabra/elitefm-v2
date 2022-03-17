import 'package:elite_fm2/screens/elitefmpage.dart';
import 'package:elite_fm2/screens/podslist.dart';
import 'package:elite_fm2/utils/bottomnavbar.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'package:elite_fm2/utils/gettest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webfeed/webfeed.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class PodPlayer extends StatefulWidget {
  final String url;
  String season;
  String episode;
  String title;
  String desc;
  Duration? duration;
  String imgUrl;

  PodPlayer(
      {this.url = '',
      this.imgUrl = '',
      this.desc = '',
      this.duration,
      this.title = '',
      this.episode = '',
      this.season = ''});

  @override
  State<PodPlayer> createState() => _PodPlayerState();
}

class _PodPlayerState extends State<PodPlayer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RssData.audioPlayer.positionStream.listen((pos) {
      setState(() {
        RssData.position = pos;
      });
    });
    print(justplayer.playing);
    if (justplayer.playing) {
      justplayer.stop().then((a) {
        RssData().play(widget.url);
        setState(() {
          firstTime = true;
        });
      });
    } else {
      RssData().play(widget.url);
    }
  }

  String centerbtn = 'pauseicon.png';
  bool isRepeat = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MaterialNavBar(
                          i: val,
                        )));
          });
        },
        currentIndex: 2,
      ),
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/18432536/18432536-1633461141401-54e40a1b59ce9.jpg'),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.desc.toString().split('</p>')[0].substring(3),
                        // 'Lorem ipsum  gyutuit tyuitiu sit lot dior lot fyyityu tyuityui diorsit lot dior. Lorem ipsum  gyutuit tyuitiu sit lot dior lot fyyityu tyuityui diorsit lot dior.',
                        style: TextStyle(color: whiteColor, fontSize: 8),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 65,
                      ),
                      Text(
                        widget.title.toString(),
                        style: TextStyle(color: redColor, fontSize: 13),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Season ' + widget.season,
                        style: TextStyle(color: redColor, fontSize: 11),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Episode ' + widget.episode,
                        style: TextStyle(color: redColor, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark,
                  color: whiteColor,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: whiteColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  widget.title.toString(),
                  style: TextStyle(color: whiteColor),
                ),
              ),
              Slider(
                min: 0,
                max: widget.duration!.inSeconds.toDouble(),
                value: RssData.position == null
                    ? 0
                    : RssData.position!.inSeconds.toDouble(),
                onChanged: (val) async {
                  setState(() {
                    RssData.position = Duration(seconds: val.toInt());
                    RssData().seek();
                  });
                },
                activeColor: redColor,
                inactiveColor: Colors.grey[800],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      RssData.position.toString().split('.')[0],
                      style: TextStyle(color: whiteColor, fontSize: 12),
                    ),
                    Text(
                      widget.duration.toString().split('.')[0],
                      style: TextStyle(color: whiteColor, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PodsList()));
                  },
                  icon: ImageIcon(
                    AssetImage('assets/radio-button.png'),
                    color: whiteColor,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () async {
                    print('hello');
                    if (RssData.position!.inSeconds >= 10) {
                      RssData.position =
                          RssData.position! - Duration(seconds: 10);
                    } else {
                      RssData.position = Duration(seconds: 0);
                    }
                    await RssData().seek();
                  },
                  icon: ImageIcon(
                    AssetImage('assets/previous.png'),
                    color: whiteColor,
                    size: 30,
                  )),
              IconButton(
                  iconSize: 100,
                  onPressed: () async {
                    RssData().isPlaying();
                    if (RssData().isPlaying()) {
                      RssData().pause();
                      setState(() {
                        centerbtn = 'playicons.png';
                      });
                    } else {
                      RssData().resume();
                      setState(() {
                        centerbtn = 'pauseicon.png';
                      });
                    }
                  },
                  icon: Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/$centerbtn'),
                  )),
              IconButton(
                  onPressed: () async {
                    print('hello');
                    if (RssData.position!.inSeconds <=
                        widget.duration!.inSeconds - 10) {
                      RssData.position =
                          RssData.position! + Duration(seconds: 10);
                    } else {
                      RssData.position =
                          Duration(seconds: widget.duration!.inSeconds);
                    }
                    await RssData().seek();
                  },
                  icon: ImageIcon(
                    AssetImage('assets/next.png'),
                    color: whiteColor,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () async {
                    if (isRepeat)
                      await RssData.audioPlayer.setLoopMode(LoopMode.off);
                    else
                      await RssData.audioPlayer.setLoopMode(LoopMode.one);
                    setState(() {
                      isRepeat = !isRepeat;
                    });
                  },
                  icon: ImageIcon(
                    AssetImage('assets/repeat.png'),
                    color: isRepeat ? redColor : whiteColor,
                    size: 30,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
