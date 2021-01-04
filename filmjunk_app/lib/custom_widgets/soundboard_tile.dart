import 'package:filmjunk_app/util/style.dart';
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
      //Failed to find the link
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, //This is where we set up the dimensions of the returning widget.
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: ClipOval(
              child: Material(
                elevation: 8.0,
                color: basicTheme().accentColor,
                child: InkWell(
                  splashColor: Colors.lightBlueAccent,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.multitrack_audio),
                  ),
                  onTap: () {play();},
                )
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              getTitle(_title),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String getTitle(String title){
    String stripped = title.split(".")[0]; //Strips the .mp3 extension of the file name
    return stripped.replaceAll("_", " "); //In the future if you space the filename ith an underscore (_) then this will replace it with space and make it look pretty
  }




}
