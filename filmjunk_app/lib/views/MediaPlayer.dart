import 'dart:async';
import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MediaControls extends StatefulWidget {
  String _nowPlaying = '<No podcast selected>';
  String _url;
  String _description;
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  int _currentSeekValue;
  AudioPlayer player = AudioPlayer();

  Dispose(){
    this.player.dispose();
  }

  MediaControls(String nowPlaying, String url, String description, bool isPlay,
      int currentSeekVal) {
      // this._nowPlaying = nowPlaying;
      // this._url = url;
      // this._description = description;
      // this._isPlay = isPlay;
      // this._currentSeekValue = currentSeekVal;
  }

  _MediaControlsState createState() => _MediaControlsState(_nowPlaying,_url,_description,_isPlay,_currentSeekValue, player);
}
  class _MediaControlsState extends State<MediaControls> {

    String _nowPlaying = '<No podcast selected>';
    String _url;
    String _description;
    IconData playPauseIcon = Icons.play_arrow;
    bool _isPlay;
    int _currentSeekValue=0;
    AudioPlayer player;
    int _duration=10;
    // ignore: close_sinks


    _MediaControlsState(String nowPlaying, String url, String description, bool isPlay,
        int currentSeekVal, AudioPlayer player){
      this._nowPlaying = nowPlaying;
      this._url = url;
      this._isPlay = isPlay;
      this.player = player;
      if(_isPlay)
          playPauseIcon = Icons.play_arrow;

      play();
    }

    void initState() {
      super.initState();
      UrlConstants.isConnected(context);
      print('');
    }


    play() async {
      print(this._url + " ////////////////////////////////////////");
      int result = await player.play(this._url);
      if (result == 1) { //If the result == 1 then there were no issues while play back


        player.onAudioPositionChanged.listen((Duration p) { //Get the position stream for the slider
          print('Current position: $p');
          setState(() => _currentSeekValue = p.inSeconds);
        });

        player.onDurationChanged.listen((Duration d) {
          print('Max duration: $d');
          setState(() => _duration = d.inSeconds);
        });

        // _duration = await player.getDuration(); //Get the duration of the podcast.
        // print("////////////////////////////////////////// DURATION: " + _duration.toString());

      }else {

      }
    }

// Toggle play/pause button
    void _togglePlayPause() {
      setState(() {
        if (_isPlay == false) {
          _isPlay = true;
          player.resume();
          // _showToast('Now playing');
          playPauseIcon = Icons.pause;
        }
        else {
          _isPlay = false;
          player.pause();
          // _showToast('Paused');
          playPauseIcon = Icons.play_arrow;
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      double width = MediaQuery
          .of(context)
          .size
          .width;
      return Container( // The persistent player at the bottom of the page
        padding: EdgeInsets.all(16.0),
        width: width,
        color: basicTheme().accentColor,
        child: Column(
          children: [
            Text( // The title of the podcast being played
              _nowPlaying,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),Center(child:
           new LinearPercentIndicator(
             width: MediaQuery.of(context).size.width *(6/7),
             percent: _currentSeekValue/_duration,
           )),
           /* Slider( // The seek bar for playback
              value:  _currentSeekValue.toDouble(),
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              min: 0,
              max: _duration.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _currentSeekValue = value as int;

                });
              },
            ),*/
            Row( // Button controls for the player
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar( // Previous button
                  radius: 20,
                  child: Center(child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    // onPressed: () => _showToast("previous")
                  ),),
                ),
                CircleAvatar( // Previous button
                  radius: 20,
                  child: Center(child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    ),
                    // onPressed: () => _showToast("previous")
                  ),),
                ),
                CircleAvatar( // Play/Pause button
                  radius: 30,
                  child: Center(child: IconButton(
                      icon: Icon(
                          playPauseIcon),
                      onPressed: () => _togglePlayPause()
                  )),
                ),
                CircleAvatar(
                  radius: 20,
                  child: Center(child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ),
                    // onPressed: () => _showToast("next")
                  ),),
                ),
              ],
            ),
          ],
        ),
      );
    }



  }
