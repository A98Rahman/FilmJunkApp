import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/models/feed_data.dart';
import 'package:filmjunk_app/views/podcast_feed/PatreonUrlForm.dart';
import 'package:filmjunk_app/views/soundboard_home.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/controllers/feed_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MediaPlayer.dart';

class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState() => _PodcastFeedState();
}

class _PodcastFeedState extends State<PodcastFeed> {
  String _nowPlaying = '<No podcast selected>';
  String _url = "";
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  int _currentSeekValue = 0;
  Future feedList;
  List<FeedData> list;
  FeedApi api = FeedApi();
  MediaControls mediaControl;

  void initState() {
    super.initState();
    UrlConstants.isConnected(context);
    print('');
    feedList = _refresh();
    mediaControl = MediaControls(_nowPlaying, _url, false, 0);
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
      context, MaterialPageRoute(builder: (context) => PatreonUrlForm()),)
        .then((value) =>
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
                feed[itemCount].url,
                DateFormat('yyyy-MM-dd').format(feed[itemCount].datetime)
            );
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
        onPressed: () => _showToast('Info: $guid'),
      ),
      onTap: () => _selectToPlay('$guid','$title'),
    );
  } // _buildRow

  // Update the podcast playing
  void _selectToPlay(String guid, String title) {
    setState(() {
      _nowPlaying = title;
      _currentSeekValue = 0;
      mediaControl.Dispose();
      mediaControl = null;
      mediaControl = MediaControls(title, guid, true, 0);

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
              IconButton(icon: Icon(Icons.search), onPressed: () {
                showSearch(context: context, delegate: FeedSearch(list));
              }),
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
          floatingActionButton: ControlsFAB(mediaControl),
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
  MediaControls _mPlayer;

  ControlsFAB(this._mPlayer);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _mPlayer,
        );
      },
      icon: Icon(Icons.play_arrow),
      label: Text('Now Playing'),
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

  //Checks for connectivity when the widget is built and not before we play a sound

//
}
