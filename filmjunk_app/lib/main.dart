import 'package:flutter/material.dart';
import 'package:filmjunk_app/util/style.dart';
import 'views/podcast_feed/podcast_feed.dart';

void main() {
  runApp(MaterialApp(
    home: PodcastFeed(),
    theme: basicTheme(),
  ));
}
