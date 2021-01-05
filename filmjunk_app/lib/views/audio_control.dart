import 'package:filmjunk_app/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:filmjunk_app/global_settings.dart';

class AudioControl extends StatefulWidget {
  @override
  String _nP; //now plaiyng
  String _url;
  bool p; //playing
  AudioPlayer player = AudioPlayer();

  Dispose() {
    this.player.dispose();
  }

  AudioControl(this._nP, this._url, this.p);
  // AudioControl(String _nP, String _url, bool p) {
    // _AudioControlState createState() =>
        // _AudioControlState(_nP, _url, p, player);
  // }
  _AudioControlState createState() => _AudioControlState(_nP, _url, p, player);
}

class _AudioControlState extends State<AudioControl> {

  bool playing = false;
  IconData playPauseButton;
  String _nowPlaying = '<No podcast selected>';
  String _url;
  int _currentSeekValue=1;
  int _duration=1;
  AudioPlayer player;

  _AudioControlState(String _nowPlaying,String _url,bool playing,AudioPlayer player){
    this._nowPlaying = _nowPlaying;
    this._url = _url;
    this.playing = playing;
    this.player = player;



  }

  void initState() {
    super.initState();
    UrlConstants.isConnected(context);
    print('');
    play();

    if(playing)
      playPauseButton = Icons.pause;
    else
      playPauseButton = Icons.play_arrow;
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


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
          bottom: Radius.zero,
        ),
        color: basicTheme().accentColor,
      ),
      padding: EdgeInsets.all(16.0),
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
            lineHeight: 5,
            percent: _currentSeekValue/_duration,
          )),
          /*Slider( // The seek bar for playback
            min: 0,
            max: 200,
            value: 100,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            onChanged: (double value) {
              setState( () => {} );
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
                        playPauseButton),
                    onPressed: () => _playToggle()
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

  void _playToggle() {
    if (playing) {
      setState(() {
        playPauseButton = Icons.pause;
        playing = false;
      });
    }
    else {
      setState(() {
        playPauseButton = Icons.play_arrow;
        playing = true;
      });
    }
  }

}
