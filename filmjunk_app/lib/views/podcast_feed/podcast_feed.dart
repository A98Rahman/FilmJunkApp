import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/models/feed_data.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:filmjunk_app/views/podcast_feed/PatreonUrlForm.dart';
import 'package:filmjunk_app/views/soundboard_home.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/controllers/feed_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState() => _PodcastFeedState();
}

class _PodcastFeedState extends State<PodcastFeed> {
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
    String url = await feedSource();
    feedList = api.getFeed(url);
    list = await feedList;
    return list;
  }


  patreonFeed() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => PatreonUrlForm()),
    ).then((value) =>
        setState(() {
          _refresh();
        }));
  }

  Future<String> feedSource() async {
    //Checks the Shared preferences to see if the feed will be called from Patreon Link or the Regular link.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String patreonRss = (prefs.get('patreon_rss') ?? ""); //null check
    if (patreonRss == "") {
      return UrlConstants.baseUrl;
    } else {
      return patreonRss;
    }
  }

  Widget _buildFeed(List<dynamic> feed) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: feed.length,
        separatorBuilder: (BuildContext context, int itemCount) => Divider(height: 1),
        itemBuilder: (BuildContext context, int itemCount) {
            return _buildRow(
                feed[itemCount].title,
                feed[itemCount].guid,
                DateFormat('yyyy-MM-dd').format(feed[itemCount].datetime)
            );
        },
      ),
    );
  }

  // Build and return the list item
  Widget _buildRow(String title, String guid, String pubDate) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.0
      ),
      color: basicTheme().primaryColor,
      child: ListTile(
        title: Text('Podcast $title'),
        subtitle: Text('Published: $pubDate'),
        trailing: new IconButton(
          icon: new Icon(Icons.info_outline),
          onPressed: () => _showToast('Info: $guid'),
        ),
        onTap: () => _selectToPlay('$title'),
      ),
    );
  } // _buildRow

  // Update the podcast playing
  void _selectToPlay(String p) {
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("FILM JUNK", style: Theme
                .of(context)
                .textTheme
                .headline1),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: FeedSearch(list));
                  }),
              IconButton(
                icon: Icon(Icons.monetization_on),
                onPressed: () {
                  patreonFeed();
                },
                tooltip: 'Patreon Feed',
              ),
            ],
            bottom: TabBar (
              tabs: <Widget>[
                Tab(
                  text: 'Feed',
                ),
                Tab(
                  text: 'Soundboard',
                ),
              ],
              indicatorColor: basicTheme().accentColor,
            ),
          ),
          body: TabBarView (
            children: [
              Column(
                children: <Widget>[
                  //////////////////////////////////////////////////////////////////////////
                  // TODO Only for testing, remove them when designing the UI.
                  TextButton(
                      child: Text("Patreon Feed"),
                      onPressed: () {
                        patreonFeed();
                      } //The router will help us navigate through the views in the app.
                  ),
                  // TextButton(
                  //     child: Text("Soundboard"),
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, '/soundboard');
                  //     } //The router will help us navigate through the views in the app.
                  // ),
                  //////////////////////////////////////////////////////////////////////////
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
                ], //Need an iterable
              ),
              SoundboardHome(),
            ],
          ),
          floatingActionButton: ControlsFAB(),
        ),
    );
    // throw UnimplementedError();
  }

  List<Widget> tabs = [
    // FutureBuilder(
    //   future: feedList,
    //   builder: (BuildContext context,
    //       AsyncSnapshot<dynamic> snapshot) {
    //     if (!snapshot.hasData)
    //       return Center(child: CircularProgressIndicator());
    //     List items = snapshot.data;
    //     return new Flexible(
    //       fit: FlexFit.loose,
    //       child: _buildFeed(items),
    //     );
    //   },
    // ),
    Container (
      color: Colors.amber,
    ),
    Container (
      child: SoundboardHome(),
    )
  ];

}

class ControlsFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => MediaControls(),
        );
      },
      icon: Icon(Icons.play_arrow),
      label: Text('Now Playing'),
      backgroundColor: basicTheme().accentColor,
      foregroundColor: Colors.white,
    );
  }
}

class MediaControls extends StatelessWidget {
  String _nowPlaying = '<No podcast selected>';
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  double _currentSeekValue = 40;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Container( // The persistent player at the bottom of the page
      padding: EdgeInsets.all(16.0),
      height: 200.0,
      width: width,
      color: basicTheme().accentColor,
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
            // onChanged: (double value) {
            //   setState(() {
            //     _currentSeekValue = value;
            //   });
            // },
          ),
          Row( // Button controls for the player
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                      playPauseIcon),
                  // onPressed: () => _togglePlayPause()
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
}

class FeedSearch extends SearchDelegate<FeedData> {
  var feeditems;

  FeedSearch(this.feeditems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';

          ///The logic to start playing the selected podcast should go here.
        }
    ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
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
    result = feeditems.where((dat) =>
    dat.title.toLowerCase().contains(query)
        ? true
        : false).toList();

    if (result.isEmpty) {
      return Text(query);
    }

    return Container(
      child: ListView(
          children:
          result.map((data) =>
              ListTile(title: Text(data.title), onTap: () {
                query = data.title;
              }))
              .toList()

      ),
    );
  }
//
}
