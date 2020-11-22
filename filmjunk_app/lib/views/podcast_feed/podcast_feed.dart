import 'package:filmjunk_app/models/feed_data.dart';
import 'package:filmjunk_app/models/rss_data.dart';
import 'package:filmjunk_app/views/podcast_feed/feed_tile.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:bloc/bloc.dart';

class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState() => _PodcastFeedState();
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("FILM JUNK", style: Theme.of(context).textTheme.headline1),
  //     ),
  //     body: SingleChildScrollView(
  //         child: ConstrainedBox(
  //             constraints: BoxConstraints(),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: <Widget>[
  //                 ListView(
  //                   children: [],
  //                 )
  //                 // FutureBuilder(
  //                 //   future: FeedData.fetchItems(),
  //                 //   builder: (BuildContext context,
  //                 //       AsyncSnapshot<dynamic> snapshot) {
  //                 //     if (snapshot.hasData) {
  //                 //       List<XmlElement> items = snapshot.data;
  //                 //       return new ListView(
  //                 //           shrinkWrap: true,
  //                 //           children: items
  //                 //               .map((XmlElement elem) =>
  //                 //                   FeedTile(elem.toString(), 'asdga', 'asgas'))
  //                 //               .toList());
  //                 //     }
  //                 //     return CircularProgressIndicator();
  //                 //   },
  //                 // )
  //                 //
  //               ] //Need an iterable
  //               ,
  //             ))),
  //   );
}

class _PodcastFeedState extends State<PodcastFeed> {
  Future feedList;

  void initState() {
    super.initState();
    feedList = _refresh();
  }

   _refresh() {
    RSSData rd = RSSData();
    return rd.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("FILM JUNK", style: Theme.of(context).textTheme.headline1),
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
                              child: ListView(
                              children:
                              items
                              .map((data) => FeedTile(data.title, data.guid, data.url))
                                .toList()));

                      },
                    )

                  ] //Need an iterable
                  ,
                )//)
    // )
    );
    // throw UnimplementedError();
  }
}

// List<Widget> textSections(Future<List<FeedData>> feedData) {
//   return feedData
//       .map((data) => FeedTile(data.title, data.guid, data.details))
//       .toList();
// }
