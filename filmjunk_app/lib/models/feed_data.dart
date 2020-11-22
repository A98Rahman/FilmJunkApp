import 'file:///C:/Users/a98ra/filmjunk_app/filmjunk_app/lib/custom_widgets/feed_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class FeedData {
   String guid;
   String title;
   String url;
   DateTime datetime;
  // final List<LocationFact> facts;

  FeedData(this.guid, this.title, this.url,this.datetime);
  FeedData.from(RssItem item){
    guid = item.guid;
    title = item.title;
    url = item.link;
    datetime = item.pubDate;
  }
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
