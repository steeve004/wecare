import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPatientsScreen extends StatefulWidget {
  @override
  _ViewPatientsScreenState createState() => _ViewPatientsScreenState();
}

class _ViewPatientsScreenState extends State<ViewPatientsScreen> {
  List<dynamic> patients = []; // List to store fetched patients

  @override
  void initState() {
    super.initState();
    fetchPatients(); // Fetch patients when the screen initializes
  }

  // Function to fetch patients from the server
  Future<void> fetchPatients() async {
    final response = await http.get(Uri.parse('https://wecare-p8lx.onrender.com/addPatient'));
    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body); // Decode JSON response
      });
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Patients'),
      ),
      body: patients.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Show loading indicator if patients are being fetched
            )
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (BuildContext context, int index) {
                final patient = patients[index];
                return Card(
                  child: ListTile(
                    title: Text(patient['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Age: ${patient['age']}"),
                        Text("Gender: ${patient['gender']}"),
                        Text("diagnosis: ${patient['diagnosis']}"),
                         // Add more details as needed
      ],
    ),
    // You can add more widgets here if needed
    // Example: trailing: Text("Status: ${patient['status']}"),
  ),
);
              },
            ),
    );
  }
}
