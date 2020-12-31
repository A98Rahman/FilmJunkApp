import 'package:filmjunk_app/views/soundboard_home.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/util/style.dart';
import 'views/podcast_feed/PatreonUrlForm.dart';
import 'views/podcast_feed/podcast_feed.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(context) => PodcastFeed(),
      '/soundboard': (context) => SoundboardHome(),
      '/PatreonForm':(context) => PatreonUrlForm()
    },
    // home: PodcastFeed(),
    theme: basicTheme(),
  ));
}
