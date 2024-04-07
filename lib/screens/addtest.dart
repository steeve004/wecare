import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'viewpatients.dart';

class AddTestsScreen extends StatefulWidget {
  const AddTestsScreen({Key? key}) : super(key: key);

  @override
  _AddTestsScreenState createState() => _AddTestsScreenState();
}

class _AddTestsScreenState extends State<AddTestsScreen> {
  List<String> patientNames = [];
  String? selectedPatient;
  TextEditingController diastolicController = TextEditingController();
  TextEditingController systolicController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  void fetchPatients() async {
    final response = await http.get(Uri.parse('http://localhost:8000/patients'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        patientNames = data.map((e) => e['name'] as String).toList();
      });
    } else {
      throw Exception('Failed to load patients');
    }
  }

 void _submitForm() async {
  // Retrieve form data
  String testDiastolic = diastolicController.text;
  String testSystolic = systolicController.text;
  String testSymptoms = symptomsController.text;

  // Check if a patient is selected
  if (selectedPatient == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a patient')),
    );
    return;
  }

  // Send data to the server to add the test record
  try {
    final testResponse = await http.post(
      Uri.parse('https://localhost:8000/addPatientTest/$selectedPatient'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'patientId': selectedPatient,
        'testDiastolic': testDiastolic,
        'testSystolic': testSystolic,
        'testSymptoms': testSymptoms,
      }),
    );

    if (testResponse.statusCode == 201) {
      // If the test record was added successfully, show success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test record added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add test record')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error occurred while adding test record')),
    );
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
            image: AssetImage("assets/images/bck5.png"),
            fit: BoxFit.fill,
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
                hint: const Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Select a patient'),
                  ],
                ),
                onChanged: (String? value) {
                  setState(() {
                    selectedPatient = value;
                  });
                },
                dropdownColor: Colors.white,
                items: patientNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
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
                onPressed: _submitForm, // Changed from submitTest to _submitForm
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 84, 117, 84),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
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
