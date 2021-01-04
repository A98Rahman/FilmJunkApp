import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'network/network_calls.dart';
import 'dart:io';

final networkCalls = NetworkCalls();

abstract class UrlConstants {
  static const String baseUrl = 'https://feeds.feedburner.com/filmjunk';
  static const String soundBoardIndexDir = 'https://filmjunk.com/soundboard/index.php';
  static const String soundBoardDir = 'https://filmjunk.com/soundboard/';

  ///
  /// isConnected() checks if the film junk website is up and running or not. If it is not connecting to, then we can assume 2 things.
  /// The server is down or the user is not connected to the internet.
  /// and so we warn the users accordingly.
  ///
  static Future<bool> isConnected(BuildContext context) async{
    try {
      final result = await InternetAddress.lookup('filmjunk.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');

      return false;
    }
  }
}


