import 'file:///C:/Users/a98ra/filmjunk_app/filmjunk_app/lib/custom_widgets/feed_tile.dart';
import 'package:filmjunk_app/models/feed_data.dart';
import 'package:flutter/material.dart';
import 'package:filmjunk_app/util/style.dart';
import 'package:filmjunk_app/global_settings.dart';
import 'package:filmjunk_app/controllers/feed_api.dart';
import '../../custom_widgets/filter_bar.dart';


class PodcastFeed extends StatefulWidget {
  @override
  _PodcastFeedState createState() => _PodcastFeedState();
 }

class _PodcastFeedState extends State<PodcastFeed> {
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
