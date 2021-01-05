import 'package:filmjunk_app/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:filmjunk_app/global_settings.dart';

class AudioControl extends StatefulWidget {

  final Function next;
  // final Function prev;

  AudioControl({Key key, this.next/*, this.prev*/}) : super(key: key);

  @override
  AudioControlState createState() => AudioControlState();
}

class AudioControlState extends State<AudioControl> {

  bool playing = false;
  IconData playPauseButton;
  String _nowPlaying = '<No podcast selected>';
  String _url;
  String _description = '<A currently playing podcast will have its description here>';
  int _currentSeekValue=1;
  int _duration=1;
  AudioPlayer player = AudioPlayer();

@override
  /*AudioControlState(String _nowPlaying,String _url,bool playing,AudioPlayer player){
    this._nowPlaying = _nowPlaying;
    this._url = _url;
    this.playing = playing;
    this.player = player;
  }*/

  Dispose() {
    this.player.dispose();
  }

  void statify(String nP, String url, String desc){
   // Dispose();
    _nowPlaying = nP;
    _url = url;
    _description = desc;
    playing = true;
    play();
    if(playing)
      playPauseButton = Icons.pause;
    else
      playPauseButton = Icons.play_arrow;
  }

  void initState() {
    super.initState();
    UrlConstants.isConnected(context);
    print('');
    if(playing)
      playPauseButton = Icons.pause;
    else
      playPauseButton = Icons.play_arrow;
    // play();
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
        color: basicTheme().primaryColor,
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
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: LinearPercentIndicator(
                  backgroundColor: Colors.white,
                  progressColor: basicTheme().accentColor,
                  width: MediaQuery.of(context).size.width *(6/7),
                  lineHeight: 5,
                  percent: _currentSeekValue/_duration,
                ),
              )
          ),
          // Slider( // The seek bar for playback
          //   min: 0,
          //   max: 200,
          //   value: 100,
          //   activeColor: Colors.white,
          //   inactiveColor: Colors.grey,
          //   onChanged: (double value) {
          //     setState( () => {} );
          //   },
          // ),
          Row( // Button controls for the player
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar( // Previous button
                backgroundColor: basicTheme().accentColor,
                radius: 20,
                child: Center(child: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  onPressed: () => _showPodcastInfo(_nowPlaying,_description),
                ),),
              ),
              CircleAvatar( // Previous button
                radius: 20,
                backgroundColor: basicTheme().accentColor,
                child: Center(child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                  // onPressed: () => _showToast("previous")
                ),),
              ),
              CircleAvatar( // Play/Pause button
                backgroundColor: basicTheme().accentColor,
                radius: 30,
                child: Center(
                    child: IconButton(
                        icon: Icon(
                            playPauseButton
                        ),
                        onPressed: () => _playToggle(),
                      color: Colors.white,
                    )
                ),
              ),
              CircleAvatar(
                backgroundColor: basicTheme().accentColor,
                radius: 20,
                child: Center(child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => widget.next(),
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showPodcastInfo(String infoTitle, String infoDescription) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(infoTitle),
            content: SingleChildScrollView(
              child: Text(infoDescription),
            ),
          );
        }
    );
  }

  void _playToggle() {
    if (playing) {
      setState(() {
        playPauseButton = Icons.play_arrow;
        playing = false;
        player.pause();
      });
    }
    else {
      setState(() {
        playPauseButton = Icons.pause;
        playing = true;
        player.resume();
      });
    }
  }

}
