import 'package:cryptocontrol/screens/graph_page.dart';
import 'package:cryptocontrol/screens/home.dart';
import 'package:cryptocontrol/screens/splash_screen.dart';
import 'package:cryptocontrol/themes.dart';
import 'package:flutter/material.dart';

void main() {
  OurTheme _theme = OurTheme();
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: _theme.primaryColor,
        primaryColor: _theme.primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/graph': (context) => const GraphPage(),
      },
    ),
  );
}
