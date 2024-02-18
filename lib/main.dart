import 'package:flutter/material.dart';
import 'package:wecare/screens/welcome.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Corrected constructor syntax

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple, // Corrected seedColor to primarySwatch
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}


