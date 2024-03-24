import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTestRecordDialog extends StatefulWidget {
  final String patientId;

  const AddTestRecordDialog({Key? key, required this.patientId}) : super(key: key);

  @override
  _AddTestRecordDialogState createState() => _AddTestRecordDialogState();
}

class _AddTestRecordDialogState extends State<AddTestRecordDialog> {
  TextEditingController testDiastolicController = TextEditingController();
  TextEditingController testSystolicController = TextEditingController();
  TextEditingController testSymptomsController = TextEditingController();

  void _submitForm() async {
  // Retrieve form data
  String testDiastolic = testDiastolicController.text;
  String testSystolic = testSystolicController.text;
  String testSymptoms = testSymptomsController.text;

  try {
    // Fetch patient information
    final patientResponse = await http.get(
      Uri.parse('https://wecare-p8lx.onrender.com/patient/${widget.patientId}'),
    );

    if (patientResponse.statusCode == 200) {
      Map<String, dynamic> patientData = jsonDecode(patientResponse.body);
      String patientName = patientData['name'];

      // Send data to the server to add the test record
      final testResponse = await http.post(
        Uri.parse('https://wecare-p8lx.onrender.com/addPatientTest/${widget.patientId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'patientId': widget.patientId,
          'patientName': patientName, // Include patient's name
          'testDiastolic': testDiastolic,
          'testSystolic': testSystolic,
          'testSymptoms': testSymptoms,
        }),
      );

      if (testResponse.statusCode == 201) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test record added successfully for patient: $patientName')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add test record')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch patient information')),
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
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Text('Add Test Record'),
    content: Container(
     // color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: testDiastolicController,
              decoration: const InputDecoration(labelText: 'Diastolic Readings'),
            ),
            TextField(
              controller: testSystolicController,
              decoration: const InputDecoration(labelText: 'Systolic Readings'),
            ),
            TextField(
              controller: testSymptomsController,
              decoration: const InputDecoration(labelText: 'Symptoms'),
            ),
            const SizedBox(height: 20), // Add some space between text fields and image
            Center(
              child: Image.asset(
                'assets/images/bck3.png', // Replace 'logo.png' with your image asset path
                height: 100, // Adjust the height as needed
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _submitForm,
        child: const Text('Add'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
    ],
  );
}

}