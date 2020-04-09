import 'package:cfchooser/pages/dashboard.dart';
import 'package:cfchooser/pages/loader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeForces Problem Chooser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => Loader(),
        '/dashboard': (context) => Dashboard()
      },
    );
  }
}