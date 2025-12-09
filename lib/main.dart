import 'package:flutter/material.dart';
import 'nav.dart';
import 'controller/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditrak',
      home: Nav(), // Redirect directly to Homepage (Nav)
    );
  }
}
