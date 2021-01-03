import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundboardTile extends StatelessWidget {
  final String _title;
  final String _url;
  bool isSelected = false;

  SoundboardTile(this._title, this._url);

  play() async {
    AudioPlayer player = AudioPlayer();
    int result = await player
        .play(this._url);
    if (result == 1) {
      //Success
    } else{
      //Not Succesful, display a toast saying that its unavailable.
    }
  }


  @override
  Widget build(BuildContext context) {
    return //Flexible(
        //   fit: FlexFit.loose,
        Column(
      mainAxisAlignment: MainAxisAlignment
          .start, //This is where we set up the dimensions of the returning widget.
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [GestureDetector(
          onTap: () {
            play();
          },
          child:InkWell(child:
            TextButton(
                child: Text(_title, style: Theme.of(context).textTheme.bodyText1))
      ),)],
      //)
    );
  }
}
