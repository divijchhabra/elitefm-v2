import 'package:elite_fm2/screens/podplayer.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'package:elite_fm2/utils/gettest.dart';
import 'package:elite_fm2/utils/maintitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webfeed/webfeed.dart';

class PodsList extends StatefulWidget {
  const PodsList({Key? key}) : super(key: key);

  @override
  State<PodsList> createState() => _PodsListState();
}

class _PodsListState extends State<PodsList> {
  updateFeed(feed) {
    setState(() {
      _rssFeed = feed;
      RssData.podcasts = _rssFeed.items!;
    });
  }

  RssFeed _rssFeed = RssFeed(); // RSS Feed Object

  String url = '';
  Duration? _duration = Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RssData.podcasts.clear();

    RssData().getRSSFeedData().then((feed) {
      // Update the _feed variable
      updateFeed(feed);

      // print feed Metadata
      print('FEED METADATA');
      print('------------------');
      print(feed.title);
      print('Link: ${feed.link}');
      print('Description: ${feed.items![0].title}');
      print('Last build data: ${feed.lastBuildDate}');
      print(
          'Duration: ${feed.items![0].itunes!.duration!.inSeconds.toString()}');

      url = feed.items![0].enclosure!.url.toString();
      _duration = feed.items![0].itunes!.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: blackColor,
      ),
      backgroundColor: blackColor,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            color: blackColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'BackStage with Elite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 23,
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: Divider(
                      thickness: 4,
                      color: redColor,
                      // indent: 30,
                      // endIndent: 90,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, ind) => PodTile(
                imgUrl: RssData.podcasts[ind].itunes!.image.href.toString(),
                title: RssData.podcasts[ind].title,
                desc: RssData.podcasts[ind].description,
                url: RssData.podcasts[ind].enclosure!.url.toString(),
                duration: RssData.podcasts[ind].itunes!.duration,
                season: RssData.podcasts[ind].itunes!.season.toString(),
                episode: RssData.podcasts[ind].itunes!.episode.toString(),
              ),
              itemExtent: 130,
              shrinkWrap: true,
              itemCount: RssData.podcasts.length,
            ),
          )
        ],
      ),
    );
  }
}

class PodTile extends StatelessWidget {
  String url;
  Duration? duration;
  String title;
  String season;
  String episode;
  String desc;
  String imgUrl;
  PodTile(
      {this.url = '',
      this.imgUrl = '',
      this.desc = '',
      this.duration,
      this.title = '',
      this.episode = '',
      this.season = ''});

  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PodPlayer(
                    url: url,
                    desc: desc,
                    title: title,
                    duration: duration,
                    season: season,
                    episode: episode,
                    imgUrl: imgUrl,
                  ))),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 10),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minVerticalPadding: 20,
                tileColor: Colors.grey[800],
                leading: Container(
                  width: 90,
                  height: 100,
                ),
                title: Container(
                  height: 90,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toString(),
                        style: TextStyle(color: whiteColor, fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Text(
                      //   'Hip Hop',
                      //   style: TextStyle(color: whiteColor, fontSize: 10),
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'Ariana Grande',
                      //   style: TextStyle(color: whiteColor, fontSize: 9),
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Text(
                        desc.toString().replaceAll(exp, '').substring(0, 100) +
                            '...',
                        style: TextStyle(color: whiteColor, fontSize: 6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  // image: DecorationImage(
                  //   fit: BoxFit.cover,
                  //   image: NetworkImage(imgUrl != ''
                  //       ? imgUrl
                  //       : 'https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/18432536/18432536-1633461141401-54e40a1b59ce9.jpg'),
                  // ),
                  borderRadius: BorderRadius.circular(10)),
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: SpinKitRipple(
                      color: Colors.white,
                      size: 50.0,
                    ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
