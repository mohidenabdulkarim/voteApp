import 'package:flutter/material.dart';
import 'package:musharax_app/screens/add_user_screen.dart';
import 'package:musharax_app/screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musharax App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        fontFamily: 'Karla',
      ),
      home: LoginPage(),
    );
  }
}
