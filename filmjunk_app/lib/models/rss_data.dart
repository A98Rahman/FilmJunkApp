import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';
import 'package:webfeed/webfeed.dart';
import 'feed_data.dart';

class RSSData {
  // final String rssURL = 'https://filmjunk.libsyn.com/rss';
  final String rssURL = 'https://feeds.feedburner.com/filmjunk';
  List<FeedData> datalist;

   getPosts() async {
    Response res = await get(rssURL);
    print('');
    if (res.statusCode == 200) {
      String body = (res.body);

      final document = RssFeed.parse(body);

      var items = document.items;
      var list = getFeedData(items);
      print('');
      return list;
    } else {
      throw "Can't get posts.";
    }
  }

   getFeedData(var feedRSS) {
    // List feedXML =  getPosts();
    dynamic dataList = new List();
    Iterator iterF = feedRSS.iterator;
    while (iterF.moveNext()) {
      dataList.add(FeedData.ParseFeedRSS(iterF.current));
    }
    this.datalist = datalist;
    return dataList;
  }
}
