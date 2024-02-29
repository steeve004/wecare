import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'viewpatients.dart';

import 'package:wecare/screens/addpatient.dart';

class AddTestsScreen extends StatefulWidget {
  const AddTestsScreen({super.key});

  @override
  _AddTestsScreenState createState() => _AddTestsScreenState();
}

class _AddTestsScreenState extends State<AddTestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tests'),
      ),
      body: const Center(
        child: Text('Add Tests Screen'),
      ),
    );
  }
}
