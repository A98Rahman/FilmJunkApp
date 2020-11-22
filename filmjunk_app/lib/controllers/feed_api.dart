import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';
import 'package:webfeed/webfeed.dart';
import '../models/feed_data.dart';
import '../network/network_calls.dart';
import '../global_settings.dart';

class FeedApi{

  Future<List<FeedData>> getFeed() async {
    var response = await networkCalls.getRssFeed(UrlConstants.baseUrl);
    var feed = RssFeed.parse(response);
    var items = feed.items;
    var temp = items.map((item) => FeedData.from(item)).toList();
    return temp;
    // print('');
  }

  List<RssItem> parseItems(RssFeed ){

  }

}