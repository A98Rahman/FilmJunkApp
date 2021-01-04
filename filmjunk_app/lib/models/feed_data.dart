import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class FeedData {
   String guid;
   String title;
   String url;
   String description;
   DateTime datetime;
  // final List<LocationFact> facts;

  FeedData(this.guid, this.title, this.url,this.description,this.datetime);
  FeedData.from(RssItem item){
    guid = item.guid;
    title = item.title;
    url = item.link;
    description = item.description;
    datetime = item.pubDate;
  }
  static FeedData ParseFeedRSS(RssItem item) {
    String title = item.title.toString();
    String url = item.link.toString();
    print(url);
    String guid = item.guid.toString();
    DateTime datetime = item.pubDate;
    String description = item.description;
    return new FeedData(guid, title, url,description,datetime);
  }

  FeedData fetchByID(int locationID) {
    return null;
  }



}
