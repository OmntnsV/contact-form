import 'package:flutter/material.dart';
import 'contact_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'Home',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: TextButton(
            child: const Text('Contact Us'),
            onPressed: () {
              Navigator.of(context).pushNamed('/contact');
            },
          ),
        ),
      ),
    );
  }
}
