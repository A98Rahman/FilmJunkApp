import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
  final myController = TextEditingController();

  savePatreonRss(String rssURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('patreon_rss', rssURL); //Saving patreon_rss in shared preferences so that on restart the user would not need to enter the link again.
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(body:
        Container(child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: myController,
            validator: (value) {
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
                  // _patreonURL = _formKey.currentState.toString();
                  _patreonURL = myController.text;
                  savePatreonRss(_patreonURL);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    )));
  }
}