import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';




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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: myController,
            decoration: InputDecoration(labelText: 'Patreon RSS Link'),
            keyboardType: TextInputType.url,
            validator: (value) {
              final isValid = validate(value).then((valid) {
                if(valid){
                  debugPrint("VALID");
                  _patreonURL = myController.text;
                  savePatreonRss(value);
                  Navigator.pop(context);
                  return "Parsing...";
                }
                else{
                  debugPrint("INVALID");
                  return "Please enter a Patreon URL";
                }
              });
              return "";
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  _patreonURL = myController.text;
                  savePatreonRss(_patreonURL);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
          new RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                  text: 'Patreon RSS Link',
                  style: new TextStyle(color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () { launch('https://support.patreon.com/hc/en-us/articles/212055866-Subscribe-to-your-Audio-RSS-link-on-the-Patreon-app');
                    },
                ),
              ],
            ),
          ),
          ],
    ),
        )
        )
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