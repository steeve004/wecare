import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WelcomeScreen.dart'; // Import the WelcomeScreen.dart file

import 'package:wecare/screens/addpatient.dart';

class Patient {
  final String id;
  final String name;
  final String gender;
  final int age;
  final String diagnosis;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.diagnosis,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      diagnosis: json['diagnosis'],
    );
  }
}

class Test {
  final String id;
  final String patientId;
  final String patientName;
  final int diastolicReadings;
  final int systolicReadings;
  final String symptoms;

  Test({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.diastolicReadings,
    required this.systolicReadings,
    required this.symptoms,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['_id'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      diastolicReadings: json['diastolicReadings'],
      systolicReadings: json['systolicReadings'],
      symptoms: json['symptoms'],
    );
  }
}


class ViewAllTestsScreen extends StatefulWidget {
  const ViewAllTestsScreen({super.key});

  @override
  _ViewAllTestsScreenState createState() => _ViewAllTestsScreenState();
}

class _ViewAllTestsScreenState extends State<ViewAllTestsScreen> {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Records',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientList(),
    );
  }
}

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late List<Patient> patients;
  late List<Test> tests = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/patients'));
      if (response.statusCode == 200) {
        setState(() {
          patients = (json.decode(response.body) as List)
              .map((data) => Patient.fromJson(data))
              .toList();
        });
        // Once patients are fetched, fetch tests for each patient
        for (var patient in patients) {
          await fetchTests(patient.id);
        }
      } else {
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching patients: $error');
      // Handle error gracefully, e.g., show an error message to the user
    }
  }

  Future<void> fetchTests(String patientId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/patientTests/$patientId'));
      if (response.statusCode == 200) {
        setState(() {
          final List<Test> fetchedTests = (json.decode(response.body) as List)
              .map((data) => Test.fromJson(data))
              .toList();
          tests.addAll(fetchedTests);
        });
      } else {
        throw Exception('Failed to load tests for patient $patientId: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching tests for patient $patientId: $error');
      // Handle error gracefully, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Records'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push( context,
             MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
              // Simply pop back to the previous screen
          },
        ),
      ),
      body: patients == null // Check if patients is null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (BuildContext context, int index) {
                final patient = patients[index];
                final patientTests = tests.where((test) => test.patientId == patient.id).toList();
                return Card(
                  color: const Color.fromARGB(255, 8, 37, 9), // Set card background color to green
                  child: ListTile(
                    title: Text(
                      patient.name,
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Gender: ${patient.gender}',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                        Text(
                          'Age: ${patient.age}',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                        Text(
                          'Diagnosis: ${patient.diagnosis}',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tests:',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: patientTests.map((test) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Diastolic Readings: ${test.diastolicReadings}',
                                  style: TextStyle(color: Colors.white), // Set text color to white
                                ),
                                Text(
                                  'Systolic Readings: ${test.systolicReadings}',
                                  style: TextStyle(color: Colors.white), // Set text color to white
                                ),
                                Text(
                                  'Symptoms: ${test.symptoms}',
                                  style: TextStyle(color: Colors.white), // Set text color to white
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
