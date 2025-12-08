import 'package:flutter/material.dart';
import 'nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medimate',
      home: Nav(), // Redirect directly to Homepage (Nav)
    );
  }
}
