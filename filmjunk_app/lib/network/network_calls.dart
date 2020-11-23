
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';
import 'package:webfeed/webfeed.dart';
import '../models/feed_data.dart';

class NetworkCalls{
  Future<String> getData(String url) async{
    var response = await get(url);
    checkAndThrowError(response);
    return response.body;
  }

  static void checkAndThrowError(Response response) {
    if(response.statusCode != 200) throw Exception(response.body);
  }

}