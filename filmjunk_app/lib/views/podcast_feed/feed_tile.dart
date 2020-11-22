import 'package:flutter/material.dart';
import '../podcast_details/podcast_details.dart';
import '../../models/feed_data.dart';

class FeedTile extends StatelessWidget {
  final String _title;
  final String _guid;
  final String _description;
  static const double _hPad = 16.0;

  FeedTile(this._title, this._guid, this._description);

  @override
  Widget build(BuildContext context) {
    return //Flexible(
    //   fit: FlexFit.loose,
        Column(

      mainAxisAlignment: MainAxisAlignment
          .start, //This is where we set up the dimensions of the returning widget.
          mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Container(

            padding: const EdgeInsets.fromLTRB(_hPad, 32.0, _hPad, 4.0),
            child: Text(_title, style: Theme.of(context).textTheme.bodyText1)),
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: _hPad),
            child: Text(_description)),
      ],
    //)
    );
  }


  // final Map<String, dynamic> data;
  // Weather(this.data);
  // Widget build(BuildContext context) {
  // double temp = data['main']['temp'];
  // return new Text(
  // '${temp.toStringAsFixed(1)} °C',
  // style: Theme.of(context).textTheme.display4,
  // );
  // }

}
