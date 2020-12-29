import 'dart:async';
import 'dart:io';
import 'package:html/parser.dart' show parse;
import '../global_settings.dart';
import '../models/soundboard_data.dart';

class SoundboardApi{

  Future<List<SoundboardData>> getSoundboards() async {
    var response = await networkCalls.getData(UrlConstants
        .soundBoardIndexDir); //Use the Index Dir when you need to grab the PHP script.

    String prefix = "<html><head></head><body>"; //Just making sure that the php script parses correctly.
    String suffix = "</body></html>";

    String body = prefix + response + suffix;

    var doc = parse(
        body); //Normally it would take Response.body but that is exactly what we return from networkCalls.getData()
    var items = doc.getElementsByTagName('html a');

    var soundboardData = items.map((item) => SoundboardData.from(item.text))
        .toList();
    return soundboardData;
  }

}