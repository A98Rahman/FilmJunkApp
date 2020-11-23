import 'package:filmjunk_app/custom_widgets/feed_tile.dart';
import 'package:filmjunk_app/models/feed_data.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/controllers/feed_api.dart';
import '../../custom_widgets/filter_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState() => _PodcastFeedState();
 }

class _PodcastFeedState extends State<PodcastFeed> {
  final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  String _nowPlaying = '<No podcast selected>';
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  double _currentSeekValue = 40;
  Future feedList;
  List<FeedData> list;
  FeedApi api = FeedApi();

  void initState() {
    super.initState();
    print('');
    feedList = _refresh();
  }

   _refresh() async {
     // return api.getFeed().then((value) => list);
     list = await api.getFeed();
     return list;
   }

  Widget _buildFeed(List<dynamic> feed) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: feed.length,
        itemBuilder: (BuildContext context, int row) {
          if (row.isOdd)
            return Divider();
          else
            return _buildRow(feed[row].title, feed[row].guid, DateFormat('yyyy-MM-dd').format(feed[row].datetime));
        },
      ),
    );
  }

  // Build and return the list item
  Widget _buildRow(String title, String guid, String pubDate) {
    return ListTile(
      title: Text('Podcast $title'),
      subtitle: Text('Published: $pubDate'),
      trailing: new IconButton(
        icon: new Icon(Icons.info_outline),
        onPressed: () =>_showToast('Info: $guid'),
      ),
      onTap: () => _selectToPlay('$title now playing'),
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
    return Scaffold(
        appBar: AppBar(
          title:
              Text("FILM JUNK", style: Theme.of(context).textTheme.headline1),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: (){
              showSearch(context: context, delegate: FeedSearch(list));
            }),
          ],
        ),
        body: //SingleChildScrollView(
            // child: ConstrainedBox(
            //     constraints: BoxConstraints(),
        Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FutureBuilder(
                      future: feedList,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        
                          List items = snapshot.data;
                          return new Flexible(
                            fit: FlexFit.loose,
                              child: _buildFeed(items),
                          );
                      },
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

                  ] //Need an iterable
                  ,
                )//)
    // )
    );
    // throw UnimplementedError();
  }

}

class FeedSearch extends SearchDelegate<FeedData>{
  var feeditems;
  FeedSearch(this.feeditems);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        }
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          close(context,null);
    },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List<FeedData> result = feeditems;
    result = feeditems.where((dat)=>dat.title.toLowerCase().contains(query)? true:false).toList();

    if(result.isEmpty){

      return Text(query);
    }

    return Container(
      child: ListView(
        children:
          result.map((data) => ListTile(title: Text(data.title), onTap: (){query = data.title;}))
              .toList()

      ),
    );

  }
//
}
