import 'package:filmjunk_app/views/podcast_feed/feed_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'rss_data.dart';
import 'package:xml/xml.dart';
import 'package:webfeed/webfeed.dart';

class FeedData {
  final String guid;
  final String title;
  final String url;
  final DateTime datetime;
  // final List<LocationFact> facts;

  FeedData(this.guid, this.title, this.url,this.datetime);

  static FeedData ParseFeedRSS(RssItem item) {
    String title = item.title.toString();
    String url = item.link.toString();
    String guid = item.guid.toString();
    DateTime datetime = item.pubDate;
    return new FeedData(guid, title, url,datetime);
  }

  FeedData fetchByID(int locationID) {
    return null;
  }



}
