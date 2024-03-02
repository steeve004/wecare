import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'viewpatients.dart';

import 'package:wecare/screens/addpatient.dart';

class AddTestsScreen extends StatefulWidget {
  const AddTestsScreen({Key? key}) : super(key: key);

  @override
  _AddTestsScreenState createState() => _AddTestsScreenState();
}

class _AddTestsScreenState extends State<AddTestsScreen> {
  List<String> patientNames = []; // List to store patient names
  String? selectedPatient; // Currently selected patient
  TextEditingController diastolicController = TextEditingController();
  TextEditingController systolicController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients(); // Fetch patients when the screen initializes
  }

  // Function to fetch patients from the server
  void fetchPatients() async {
    final response = await http.get(Uri.parse('https://wecare-p8lx.onrender.com/patients'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        patientNames = data.map((e) => e['name'] as String).toList();
      });
    } else {
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Test',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 34, 95, 11),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bck5.png"), // Replace with your image path
            fit: BoxFit.fill, // Fill the screen with the image
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Select Patient',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedPatient,
                hint: const Text('Select a patient'),
                onChanged: (String? value) { // Adjusted signature
                  setState(() {
                    selectedPatient = value;
                  });
                },
                items: patientNames.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: diastolicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Diastolic Reading',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: systolicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Systolic Reading',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: symptomsController,
                decoration: const InputDecoration(
                  labelText: 'Symptoms',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform action with selected patient and form inputs
                  if (selectedPatient != null) {
                    String diastolic = diastolicController.text;
                    String systolic = systolicController.text;
                    String symptoms = symptomsController.text;
                    // Handle submission, e.g., send data to server
                  } else {
                    // Show error message or handle the case when no patient is selected
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 84, 117, 84)), // Green button
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white, // White text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
