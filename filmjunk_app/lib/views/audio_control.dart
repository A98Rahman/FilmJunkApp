import 'package:filmjunk_app/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioControl extends StatefulWidget {
  @override
  _AudioControlState createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {

  bool playing = false;
  IconData playPauseButton = Icons.play_arrow;
  String _nowPlaying = '<No podcast selected>';

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
          ),
          Slider( // The seek bar for playback
            min: 0,
            max: 200,
            value: 100,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            onChanged: (double value) {
              setState( () => {} );
            },
          ),
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
