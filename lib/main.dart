import 'package:flutter/material.dart';
import 'package:wecare/screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(0xFF046346, <int, Color>{
            50: Color(0xFFE0F4F0),
            100: Color(0xFFB3DFD4),
            200: Color(0xFF80C9B6),
            300: Color(0xFF4EB39A),
            400: Color(0xFF29A384),
            500: Color(0xFF046346),
            600: Color(0xFF03593D),
            700: Color(0xFF024A31),
            800: Color(0xFF013A25),
            900: Color(0xFF002B1B),
          }),
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
