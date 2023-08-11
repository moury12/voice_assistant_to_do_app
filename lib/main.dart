import 'package:flutter/material.dart';
import 'package:voice_assistant/pages/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Assistant',
      theme:ThemeData.light(useMaterial3: true,).copyWith(scaffoldBackgroundColor: Colors.white,appBarTheme: AppBarTheme(backgroundColor: Colors.white,foregroundColor: Colors.black54)),

      home: Home()
    );
  }
}
