import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundboardTile extends StatelessWidget {
  final String _title;
  final String _Url;
  static const double _hPad = 16.0;
  bool isSelected = false;

  SoundboardTile(this._title, this._Url);

  play() async {
    AudioPlayer player = AudioPlayer();
    int result = await player
        .play(this._Url);
    if (result == 1) {}
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
          child:
            Container(
              padding: const EdgeInsets.fromLTRB(_hPad, 32.0, _hPad, 4.0),
                child: Text(_title, style: Theme.of(context).textTheme.bodyText1))
        /*Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: _hPad),
            child: Text(_title))*/
      )],
      //)
    );
  }
}
