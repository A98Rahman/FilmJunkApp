import 'package:filmjunk_app/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:filmjunk_app/global_settings.dart';

class AudioControl extends StatefulWidget {

  final Function next;

  AudioControl({Key key, this.next}) : super(key: key);

  @override
  AudioControlState createState() => AudioControlState();
}

class AudioControlState extends State<AudioControl> {

  static final int SHORTSKIP = 20000; //Skips ahead for 20 seconds.
  static final int LONGSKIP = 5*60000; //Skips ahead for 5 minutes.

  bool playing = false;
  IconData playPauseButton;
  String _nowPlaying = '<No podcast selected>';
  String _url;
  String _description = '<A currently playing podcast will have its description here>';
  int _currentSeekValue=1;
  int _duration=1;
  AudioPlayer player = AudioPlayer();
  bool mustSeek = false; //The podcast must keep seeking until the user lifts their hands

@override

  void statify(String nP, String url, String desc){
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

  void seekPodcast(bool isForwards, int timeSkip) async {
    if (isForwards) {
      if (_currentSeekValue * 1000 + timeSkip > _duration*1000) // Can not skip ahead of the duration of the podcast
        return;

      int result = await player.seek(
          Duration(milliseconds: _currentSeekValue * 1000 + timeSkip));
    }else {
      if (_currentSeekValue * 1000 - timeSkip < .1 ) //Must be greater than 0.1
        return;

        int result = await player.seek(
            Duration(milliseconds: _currentSeekValue * 1000 - timeSkip));
    }
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

      player.onPlayerCompletion.listen((event) {  //On complete event of the Audio PLayer, Plays the next podcast when current compeletes
          widget.next();
      });

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
                padding: const EdgeInsets.all(12.0),
                child: LinearPercentIndicator(
                  backgroundColor: Colors.white,
                  progressColor: basicTheme().accentColor,
                  width: MediaQuery.of(context).size.width *(3/4),
                  lineHeight: 10,
                  alignment: MainAxisAlignment.center,
                  percent: _currentSeekValue/_duration,
                ),
              )
          ),
           Row( // Button controls for the player
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar( // Previous button
                backgroundColor: basicTheme().accentColor,
                radius: 20,
                child: Center(
                  child: ClipOval(
                      child: Material(
                          elevation: 8.0,
                          color: basicTheme().accentColor,
                          child: InkWell(
                            splashColor: Colors.tealAccent,
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () => _showPodcastInfo(_nowPlaying,_description),
                          )
                      )
                  ),
                ),
              ),
              CircleAvatar( // Previous button
                radius: 20,
                backgroundColor: basicTheme().accentColor,
                child: Center(
                  child: ClipOval(
                      child: Material(
                          elevation: 8.0,
                          color: basicTheme().accentColor,
                          child: InkWell(
                            splashColor: Colors.tealAccent,
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                  Icons.fast_rewind,
                                  color: Colors.white
                              ),
                            ),
                            onTap: () => seekPodcast(false,SHORTSKIP),
                            onLongPress: () => seekPodcast(false,LONGSKIP),
                          )
                      )
                  ),
                )
              ),
              CircleAvatar( // Play/Pause button
                backgroundColor: basicTheme().accentColor,
                radius: 30,
                child: Center(
                  child: ClipOval(
                      child: Material(
                          elevation: 8.0,
                          color: basicTheme().accentColor,
                          child: InkWell(
                            splashColor: Colors.tealAccent,
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                  playPauseButton,
                                  color: Colors.white
                              ),
                            ),
                            onTap: () => _playToggle(),
                          )
                      )
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: basicTheme().accentColor,
                radius: 20,
                child: Center(
                  child: ClipOval(
                      child: Material(
                          elevation: 8.0,
                          color: basicTheme().accentColor,
                          child: InkWell(
                            splashColor: Colors.tealAccent,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Icon(
                                  Icons.fast_forward,
                                  color: Colors.white
                              ),
                            ),
                            onTap: () => seekPodcast(true,SHORTSKIP),
                            onLongPress: () => seekPodcast(true,LONGSKIP),
                          )
                      )
                  ),
                ),
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
