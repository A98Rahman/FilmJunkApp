import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/models/feed_data.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:filmjunk_app/views/audio_control.dart';
import 'package:filmjunk_app/views/podcast_feed/PatreonUrlForm.dart';
import 'package:filmjunk_app/views/soundboard_home.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/controllers/feed_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MediaPlayer.dart';

class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState() => _PodcastFeedState();
}

class _PodcastFeedState extends State<PodcastFeed> with AutomaticKeepAliveClientMixin<PodcastFeed> {
  IconData playPauseIcon = Icons.play_arrow;
  Future feedList;
  List<FeedData> list;
  FeedApi api = FeedApi();

  @override
  bool get wantKeepAlive => true;

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
    CURR_IDX = 0;
    loadCurrentSelection(); // Load the podcast played int he previous session
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
        separatorBuilder: (BuildContext context, int itemCount) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int itemCount) {
          return _buildRow(
              feed[itemCount].title,
              feed[itemCount].url,
              feed[itemCount].description,
              DateFormat('yyyy-MM-dd').format(feed[itemCount].datetime),
              itemCount
          );
        },
      ),
    );
  }


  _showPodcastInfo(String infoTitle, String infoDescription) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(infoTitle),
            content: SingleChildScrollView(
              child: Text(infoDescription),
            ),
          );
        }
    );
  }

  saveCurrentSelection(String title, String url, String desc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('curr_title',
        title);
    await prefs.setString('curr_url',
        url);
    await prefs.setString('curr_desc',
        desc);
  }
  //load podcast from shared preferences, if it exists.
  loadCurrentSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currTitle = (prefs.get('curr_title') ?? ""); //null check
    if (currTitle == "") {
      return;
    }
    String currUrl = (prefs.get('curr_url') ?? ""); //null check
    if (currTitle == "") {
      return;
    }
    String currDesc = (prefs.get('curr_desc') ?? ""); //null check
    if (currTitle == "") {
      return;
    }

    //If we reach to this mark then we can assume that all the data is present in shared prefs

    _selectToPlay(currUrl, currTitle, currDesc, 0);

  }

  // Update the podcast playing
  void _selectToPlay(String url, String title, String desc, int index) {
    setState(() {
      CURR_IDX = index;
      _key.currentState.statify(title, url, desc);
      saveCurrentSelection(title,url,desc); //Save the seelction in shared preferences
      // _key.currentState.statify(title, url, desc);

    });
  }

  // Build and return the list item
  Widget _buildRow(String title, String guid, String desc, String pubDate,
      int index) {
    final rssDesc = parse(desc);
    final String parsedDesc = parse(rssDesc.body.text).documentElement.text;

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
            onPressed: () => _showPodcastInfo(title, parsedDesc),
          ),
          onTap: () => _selectToPlay('$guid', '$title', '$parsedDesc', index),
        ),
      );
    } // _buildRow


    nextPodcast() {
      bool isNext = true;
      if (list == null || list.isEmpty)
        return;

      if (isNext) {
        if (CURR_IDX + 1 > list.length) {
          return;
        } else {
          CURR_IDX++;
        }
      } else {
        if (CURR_IDX - 1 < 0) {
          return;
        } else {
          CURR_IDX--;
        }
      }
      _selectToPlay(
          list[CURR_IDX].url, list[CURR_IDX].title, list[CURR_IDX].description,
          CURR_IDX);
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
                    showSearch(context: context, delegate: FeedSearch(list,_selectToPlay));
                  }),
              IconButton(
                icon: Icon(Icons.monetization_on),
                onPressed: () {
                  patreonFeed();
                },
                tooltip: 'Patreon Feed',
              ),
            ],
            bottom: TabBar(
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
          body: TabBarView(
            children: [
              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: feedList,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ));
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
  Function func;
  FeedSearch(this.feeditems, this.func);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
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
                func(data.url,data.title,data.description,0);
                Navigator.pop(context);
              }))
              .toList()
      ),
    );
  }

  //Checks for connectivity when the widget is built and not before we play a sound

//
}
