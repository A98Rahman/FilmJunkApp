import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';
import 'package:webfeed/webfeed.dart';
import 'models/feed_data.dart';
import 'network/network_calls.dart';

final networkCalls = NetworkCalls();

abstract class UrlConstants {
  static const String baseUrl = 'https://feeds.feedburner.com/filmjunk';
  static const String soundBoardIndexDir = 'https://filmjunk.com/soundboard/index.php';
  static const String soundBoardDir = 'https://filmjunk.com/soundboard/';

}

