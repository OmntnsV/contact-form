import 'package:flutter/material.dart';
import 'package:task/contact_screen.dart';
import 'package:task/home_screen.dart';

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
      routes: {
        '/': (context) => const HomeScreen(),
        '/contact': (context) => const ContactScreen(),
      },
      initialRoute: '/',
      title: 'Advertech',
    );
  }
}
