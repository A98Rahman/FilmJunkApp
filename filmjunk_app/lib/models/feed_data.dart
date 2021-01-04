import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class FeedData {
   String guid;
   String title;
   String url;
   DateTime datetime;
   String description;
  // final List<LocationFact> facts;

  FeedData(this.guid, this.title, this.url,this.datetime);
  FeedData.from(RssItem item){
    guid = item.guid;
    title = item.title;
    url = item.link;
    datetime = item.pubDate;
    description = item.description;
  }
  static FeedData ParseFeedRSS(RssItem item) {
    String title = item.title.toString();
    String url = item.link.toString();
    print(url);
    String guid = item.guid.toString();
    DateTime datetime = item.pubDate;
    return new FeedData(guid, title, url,datetime);
  }

  FeedData fetchByID(int locationID) {
    return null;
  }



}
