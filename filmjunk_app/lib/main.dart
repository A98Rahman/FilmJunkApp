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

  final List<String> entries = <String>['A', 'B', 'C','D','E','F','G','H'];
  double _currentSeekValue = 40;

  Widget _buildFeed() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: entries.length*2,
        itemBuilder: (BuildContext context, int row) {
          if (row.isOdd) return Divider();
          else return _buildRow(entries[row~/2]);
        },
      ),
    );
  }

  Widget _buildRow(String entry) {
    return ListTile (
      title: Text('Podcast $entry'),
      subtitle: Text('timestamp'),
      trailing: Icon(
          Icons.info_outline,
        ),
      );
  } // _buildRow

  void _showToast (String message) {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Film Junk Feed'),
        ),
        body: new Container (
          child: Column(
              children: <Widget>[
                Expanded (
                  child: _buildFeed(),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Column (
                    children: [
                      Slider(
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
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Center(child: IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              onPressed: ()=> _showToast("info"),
                            ),),
                          ),
                          CircleAvatar(
                            radius: 20,
                            child: Center(child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: ()=> _showToast("previous")
                            ),),
                          ),
                          CircleAvatar(
                            radius: 30,
                            child: Center(child: IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                onPressed: ()=> _showToast("play/pause")
                            ),),
                          ),
                          CircleAvatar(
                            radius: 20,
                            child: Center(child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: ()=> _showToast("next")
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