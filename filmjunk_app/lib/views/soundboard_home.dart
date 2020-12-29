import 'package:filmjunk_app/controllers/soundboard_api.dart';
import 'package:filmjunk_app/custom_widgets/soundboard_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:developer";
import '../models/soundboard_data.dart';

class SoundboardHome extends StatefulWidget {
  @override
  _SoundboardHomeState createState() => _SoundboardHomeState();
}

class _SoundboardHomeState extends State<SoundboardHome> {
  Future soundboard;
  List<SoundboardData> list;
  SoundboardApi api = SoundboardApi();


  void initState() {
    super.initState();
    print('');
    soundboard = _refresh();
  }

  _refresh() async {
    // return api.getFeed().then((value) => list);
    list = await api.getSoundboards();
    return list;
  }


  _buildSoundBoard(List<SoundboardData> items){
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int row) {
          // if (row.isOdd)
          //   return Divider();
          // else
            return _buildRow(items[row].soundName, items[row].url);
        },
      ),
    );
  }

  // Build and return the list item
  Widget _buildRow(String name, String url) {
    return SoundboardTile(name, url);
  } // _buildRow


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("SoundBoards", style: Theme.of(context).textTheme.headline1),
        ),
        body: Column(
          children:
          <Widget>[ FutureBuilder(
              future: soundboard,
              builder:(BuildContext context,
          AsyncSnapshot<dynamic> snapshot) {
                if(!snapshot.hasData)
                  return CircularProgressIndicator();
                List items = snapshot.data;
                return new Flexible(
                  fit: FlexFit.loose,
                  child: _buildSoundBoard(items),
                );
              } ,
            ),
        ]));
  }
}
