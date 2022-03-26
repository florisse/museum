import 'package:flutter/material.dart';
import 'Screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

var myColor;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    myColor = Colors.deepOrange;

    return MaterialApp(
      title: 'Smart Museum App',
      theme: ThemeData(
        primaryColor: myColor,
        primarySwatch: myColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
