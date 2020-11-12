import 'package:flutter/material.dart';
import 'package:filmjunk_app/util/theme.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    theme: basicTheme(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FILM JUNK",
        style: Theme.of(context).textTheme.headline1),
      ),
      
    );
  }
}

