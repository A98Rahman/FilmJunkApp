import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/models/feed_data.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:filmjunk_app/views/audio_control.dart';
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
  String _description = "";
  IconData playPauseIcon = Icons.play_arrow;
  bool _isPlay = false;
  int _currentSeekValue = 0;
  Future feedList;
  List<FeedData> list;
  FeedApi api = FeedApi();
  // MediaControls mediaControl;
  FeedData Selection;
  AudioControl audioControl;
  int CURR_IDX; //Index of the currently playing podcast.

  GlobalKey<AudioControlState> _key = GlobalKey();

  void initState() {
    super.initState();
    UrlConstants.isConnected(context);
    print('');
    feedList = _refresh();
    CURR_IDX=0;
    // audioControl = new AudioControl("Nothing Selected", "", false);
    // Selection = FeedData("null", "No podcast Selected", "null", "No Selection", null);
    // mediaControl = MediaControls(_nowPlaying, _url, _description, false, 0);
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
                feed[itemCount].url,
                feed[itemCount].description,
                DateFormat('yyyy-MM-dd').format(feed[itemCount].datetime),itemCount
            );
        },
      ),
    );
  }

  // Build and return the list item
  Widget _buildRow(String title, String url, String desc, String pubDate, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.0
      ),
      color: basicTheme().backgroundColor,
      child: ListTile(
        title: Text('Podcast $title'),
        subtitle: Text('Published: $pubDate'),
        trailing: new IconButton(
          icon: new Icon(Icons.info_outline),
          onPressed: () => _showToast('Info: $url'),
        ),
        onTap: () => _selectToPlay('$url','$title','$desc',index),
      ),
    );
  } // _buildRow

  // Update the podcast playing
  void _selectToPlay(String guid, String title, String desc, int index) {
    setState(() {
          CURR_IDX = index;
        _key.currentState.statify(title, guid);
    });
  }

  nextPodcast(){
    bool isNext = true;
    if(list == null || list.isEmpty)
      return;

    if(isNext){
      if (CURR_IDX+1 > list.length){
        return;
      }else {
        CURR_IDX++;
      }
    }else {
      if (CURR_IDX-1 < 0){
        return;
      }else {
        CURR_IDX--;
      }
    }
    _selectToPlay(list[CURR_IDX].url, list[CURR_IDX].title, list[CURR_IDX].description, CURR_IDX);

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
          bottomNavigationBar: Stack(
            children: [
              Wrap(
                  children: <Widget>[
                    AudioControl(
                      key: _key,
                      next: nextPodcast,
                      prev: nextPodcast,
                    ),
                  ]
              ),
            ],
          ),
        ),
    );
    // throw UnimplementedError();
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
