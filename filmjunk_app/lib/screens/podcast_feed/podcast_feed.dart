import 'package:filmjunk_app/models/feed_data.dart';
import 'package:filmjunk_app/screens/podcast_feed/feed_tile.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/util/style.dart';

class PodcastFeed extends StatelessWidget {
  final feeddata = FeedData.fetchAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("FILM JUNK", style: Theme.of(context).textTheme.headline1),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                  ]..addAll(textSections(feeddata)) //Need an iterable
                  ,
                ))));
  }

  List<Widget> textSections(List<FeedData> feedData) {
    return feedData
        .map((data) => FeedTile(data.title, data.guid, data.details))
        .toList();
  }
}
