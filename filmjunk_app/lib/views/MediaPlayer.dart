import 'package:filmjunk_app/global_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaControls extends StatefulWidget {
  String _nowPlaying = '<No podcast selected>';
  String _url;
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  double _currentSeekValue;
  AudioPlayer player;


  MediaControls(String nowPlaying, String url, bool isPlay,
      double currentSeekVal) {
      this._nowPlaying = nowPlaying;
      this._url = url;
      this._isPlay = isPlay;
      this._currentSeekValue = currentSeekVal;
  }

  _MediaControlsState createState() => _MediaControlsState(_nowPlaying,_url,_isPlay,_currentSeekValue);
}
  class _MediaControlsState extends State<MediaControls> {

    String _nowPlaying = '<No podcast selected>';
    String _url;
    IconData playPauseIcon = Icons.play_arrow;
    bool _isPlay;
    double _currentSeekValue;
    AudioPlayer player;

    _MediaControlsState(String nowPlaying, String url, bool isPlay,
        double currentSeekVal){

      this._nowPlaying = nowPlaying;
      this._url = url;
      this._isPlay = isPlay;
      this._currentSeekValue = currentSeekVal;
    }

    void initState() {
      super.initState();
      UrlConstants.isConnected(context);
      print('');
      player = AudioPlayer();
      play();
    }



    play() async {
      print(this._url + " ////////////////////////////////////////");
      int result = await player.play(this._url);
      if (result !=
          1) { //If the result == 1 then there were no issues while play back
        final snackBar = SnackBar(
          content: Text('Nothing to play.'),
        );
        // Scaffold.of(context).showSnackBar(snackBar);
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
        height: 200.0,
        width: width,
        color: Colors.blue,
        child: Column(
          children: [
            Text( // The title of the podcast being played
              _nowPlaying,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Slider( // The seek bar for playback
              value: player.onDurationChanged,
              activeColor: Colors.white,
              min: 0,
              max: 100,
              // onChanged: (double value) {
              //   setState(() {
              //     _currentSeekValue = value;
              //   });
              // },
            ),
            Row( // Button controls for the player
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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