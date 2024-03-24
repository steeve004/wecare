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

    // Send data to the server
    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/addTestRecord'),
        body: {
          'patientId': widget.patientId,
          'testDiastolic': testDiastolic,
          'testSystolic': testSystolic,
          'testSymptoms': testSymptoms,
        },
      );

      if (response.statusCode == 200) {
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
              decoration: InputDecoration(labelText: 'Diastolic Readings'),
            ),
            TextField(
              controller: testSystolicController,
              decoration: InputDecoration(labelText: 'Systolic Readings'),
            ),
            TextField(
              controller: testSymptomsController,
              decoration: InputDecoration(labelText: 'Symptoms'),
            ),
            SizedBox(height: 20), // Add some space between text fields and image
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
        child: Text('Add'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
    ],
  );
}

}