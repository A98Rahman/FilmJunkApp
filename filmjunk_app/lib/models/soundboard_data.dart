import 'package:filmjunk_app/global_settings.dart';
import 'package:flutter/material.dart';

class SoundboardData {
  String soundName;
  String url;


  SoundboardData(this.soundName, this.url);

  SoundboardData.from(String name){
    this.soundName = name;
    this.url = UrlConstants.soundBoardDir +
        name; //Saving the URL of the soundboard resource.
  }

  SoundboardData fetchByName(int soundName) {
    return null;
  }
}