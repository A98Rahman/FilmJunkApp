import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;


class PatreonUrlForm extends StatefulWidget {
  @override
  PatreonUrlFormState createState() {
    return PatreonUrlFormState();
  }
}


// This class holds data related to the form.
class PatreonUrlFormState extends State<PatreonUrlForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String _patreonURL = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              final isValid = validate(value);
              if (value.isEmpty) {
                return 'Please enter Patreon URL';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  _patreonURL = _formKey.currentState.toString();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> validate(String value) async {
    var client = http.Client();
    try {
      // RSS feed
      var response = await client.get(value);
      var channel = RssFeed.parse(response.body);
      return true;
    }
    catch(e){
      print("$e");
      return false;
    }
  }

}