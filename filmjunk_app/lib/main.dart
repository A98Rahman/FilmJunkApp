import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:filmjunk_app/util/theme.dart';

void main() {
  runApp(MaterialApp(
    home: PodcastFeed(),
    // theme: basicTheme(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FILM JUNK",
        style: Theme.of(context).textTheme.headline1),
      ),
      
    );
  }
}

class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState () => _PodcastFeedState();
}

class _PodcastFeedState extends State<PodcastFeed> {

  final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  String _nowPlaying = '<No podcast selected>';
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  double _currentSeekValue = 40;

  Widget _buildFeed() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: entries.length * 2,
        itemBuilder: (BuildContext context, int row) {
          if (row.isOdd)
            return Divider();
          else
            return _buildRow(entries[row ~/ 2]);
        },
      ),
    );
  }

  // Build and return the list item
  Widget _buildRow(String entry) {
    return ListTile(
      title: Text('Podcast $entry'),
      subtitle: Text('timestamp'),
      trailing: new IconButton(
        icon: new Icon(Icons.info_outline),
        onPressed: () =>_showToast('Info'),
      ),
      onTap: () => _selectToPlay('$entry now playing'),
    );
  } // _buildRow

  // Update the podcast playing
  void _selectToPlay (String p) {
    setState(() {
      _nowPlaying = p;
      _currentSeekValue = 0.0;
    });
  }

  // Toast functionality
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
  } // _showToast

  // Toggle play/pause button
  void _togglePlayPause() {
    setState(() {
      if (_isPlay == false) {
        _isPlay = true;
        _showToast('Now playing');
        playPauseIcon = Icons.pause;
      }
      else {
        _isPlay = false;
        _showToast('Paused');
        playPauseIcon = Icons.play_arrow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Feed page
        appBar: AppBar( // App bar
          title: Text('Film Junk Feed'),
        ),
        body: new Container ( // Feed body
          child: Column(
              children: <Widget>[
                Expanded( // The list containing the feed
                  child: _buildFeed(),
                ),
                Container( // The persistent player at the bottom of the page
                  padding: EdgeInsets.all(16.0),
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
                        value: _currentSeekValue,
                        activeColor: Colors.white,
                        min: 0,
                        max: 100,
                        onChanged: (double value) {
                          setState(() {
                            _currentSeekValue = value;
                          });
                        },
                      ),
                      Row( // Button controls for the player
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar( // Info button
                            radius: 20,
                            child: Center(child: IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              onPressed: () => _showToast('Info'),
                            ),),
                          ),
                          CircleAvatar( // Previous button
                            radius: 20,
                            child: Center(child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () => _showToast("previous")
                            ),),
                          ),
                          CircleAvatar( // Play/Pause button
                            radius: 30,
                            child: Center(child: IconButton(
                                icon: Icon(
                                  playPauseIcon),
                                onPressed: () => _togglePlayPause())
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            child: Center(child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () => _showToast("next")
                            ),),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]
          ),
        )
    );
  }

}