import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wecare/screens/addpatient.dart';

class ViewAllTestsScreen extends StatefulWidget {
  const ViewAllTestsScreen({super.key});

  @override
  _ViewAllTestsScreenState createState() => _ViewAllTestsScreenState();
}

class _ViewAllTestsScreenState extends State<ViewAllTestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View All Tests'),
      ),
      body: const Center(
        child: Text('View Tests Screen'),
      ),
    );
  }
}
