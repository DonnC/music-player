import 'package:flutter/material.dart';
import 'package:music_player_nf/screens/home_page.dart';
import 'package:music_player_nf/utils/color_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: colorTheme,
      home: HomePage()
    );
  }
}