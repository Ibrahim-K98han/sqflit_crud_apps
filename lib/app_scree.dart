import 'package:flutter/material.dart';
import 'package:sqflit_crud_app/contact_screen.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ContactScreen(),
    );
  }
}
