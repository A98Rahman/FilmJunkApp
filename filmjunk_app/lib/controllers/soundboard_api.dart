import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';
import 'package:webfeed/webfeed.dart';
import '../models/feed_data.dart';
import '../network/network_calls.dart';
import '../global_settings.dart';

class SoundboardApi{

  Future<String> getSoundboards() async {
    var response = await networkCalls.getData(UrlConstants.baseGAPI);
    // var feed = RssFeed.parse(response);
    // var items = feed.items;
    // var temp = items.map((item) => FeedData.from(item)).toList();
    return response;
    // print('');
  }


}