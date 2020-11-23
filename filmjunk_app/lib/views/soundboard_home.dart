import 'package:filmjunk_app/controllers/feed_api.dart';
import 'package:filmjunk_app/controllers/soundboard_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

class SoundboardHome extends StatefulWidget {
  @override

    _SoundboardHomeState createState() => _SoundboardHomeState();

}
  class _SoundboardHomeState extends State<SoundboardHome>{

    Future soundboard;
    String list;
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





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SoundBoards",style: Theme.of(context).textTheme.headline1),

      ),
      body: Column( children: <Widget>[ FutureBuilder(
        future: soundboard,
        builder:(BuildContext context,
    AsyncSnapshot<dynamic> snapshot) {
          if(!snapshot.hasData)
            return CircularProgressIndicator();
          return Text(snapshot.data);
        } ,
      ),
      ]
      )

    );
  }


  }

