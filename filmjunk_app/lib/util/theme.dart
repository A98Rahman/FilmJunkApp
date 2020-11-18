import 'package:flutter/material.dart';

ThemeData basicTheme(){
  
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Colors.blue,
    backgroundColor: Colors.blue[200],
    scaffoldBackgroundColor: Colors.black26
  );
}
TextTheme _basicTextTheme(TextTheme base){
    return base.copyWith(  //copyWith is basically overriding the base properties with what we set them as down below
      headline1: base.headline1.copyWith(
        fontFamily: "AgencyFB",
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ); 
  }