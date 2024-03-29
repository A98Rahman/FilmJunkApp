import 'package:filmjunk_app/controllers/soundboard_api.dart';
import 'package:filmjunk_app/custom_widgets/soundboard_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/soundboard_data.dart';
import 'package:filmjunk_app/global_settings.dart';

class SoundboardHome extends StatefulWidget {
  @override
  _SoundboardHomeState createState() => _SoundboardHomeState();
}

class _SoundboardHomeState extends State<SoundboardHome> with AutomaticKeepAliveClientMixin<SoundboardHome> {
  Future soundboard;
  List<SoundboardData> list;
  SoundboardApi api = SoundboardApi();

  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
    checkConnectionState();
    print('');
    soundboard = _refresh();
  }
  checkConnectionState() async {
    UrlConstants.isConnected(context).then((stat) {
      if(!stat){
        final snackBar = SnackBar(
          content: Text('Connection failed: Check your connectivity.'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
    }});
  }

  _refresh() async {
    // return api.getFeed().then((value) => list);
    list = await api.getSoundboards();
    return list;
  }


  _buildSoundBoard(List<SoundboardData> items){
    return Column(
      children: <Widget>[ ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int row) {
          // if (row.isOdd)
          //   return Divider();
          // else
            return _buildRow(items[row].soundName, items[row].url);
        },
      )],
    );
  }

  // Build and return the list item
  Widget _buildRow(String name, String url) {
    return SoundboardTile(name, url);
  } // _buildRow



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(
        children:
        <Widget>[ FutureBuilder(
          future: soundboard,
          builder:(BuildContext context,
              AsyncSnapshot<dynamic> snapshot) {
            if(!snapshot.hasData)
              return Padding(
                padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator()
              );
            List items = snapshot.data;
            return new  GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (context,index){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[(Flexible(
                        fit: FlexFit.loose,
                        child: _buildRow(
                            items[index].soundName,
                            items[index].url
                        )
                    ))],
                  );
                }
            );
          } ,
        ),
        ]));
  }
}
