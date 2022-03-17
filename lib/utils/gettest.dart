import 'package:elite_fm2/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class RssData {
  RssFeed _rssFeed = RssFeed(); // RSS Feed Object

  static List podcasts = [];
  static Duration? position = Duration();
  static AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying() {
    print(audioPlayer.playing);
    return audioPlayer.playing;
  }

  // Get the Medium RSSFeed data
  Future<RssFeed> getRSSFeedData() async {
    try {
      final client = http.Client();
      final response = await client
          .get(Uri.parse('https://anchor.fm/s/6e7667e0/podcast/rss'));
      return RssFeed.parse(response.body);
    } catch (e) {
      print(e);
    }
    return RssFeed();
  }

  play(String url) async {
    if (url != null) {
      await audioPlayer.setUrl(url);
    }
    await audioPlayer.play();
  }

  pause() async {
    await audioPlayer.pause();
    position = audioPlayer.position;
  }

  resume() async {
    await audioPlayer.seek(position);
    print(position);
    await audioPlayer.play();
  }

  seek() async {
    await audioPlayer.seek(position);
  }

  next() async {
    await audioPlayer.seekToNext();
  }
}
