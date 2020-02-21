import 'package:flutter/material.dart';
import 'package:tms/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMS',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
