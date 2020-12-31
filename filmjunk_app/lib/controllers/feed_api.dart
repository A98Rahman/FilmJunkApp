import 'package:webfeed/webfeed.dart';
import '../models/feed_data.dart';
import '../global_settings.dart';

class FeedApi{

  Future<List<FeedData>> getFeed(String url) async {
    var response = await networkCalls.getData(url);
    var feed = RssFeed.parse(response);
    var items = feed.items;
    var temp = items.map((item) => FeedData.from(item)).toList();
    return temp;
    // print('');
  }


}