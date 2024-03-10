import 'package:flutter/material.dart';

class EditPatientScreen extends StatefulWidget {
  final dynamic patient;
  final Function(dynamic) onUpdate;

  EditPatientScreen({required this.patient, required this.onUpdate});

  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _diagnosisController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient['name']);
    _ageController = TextEditingController(text: widget.patient['age'].toString());
    _genderController = TextEditingController(text: widget.patient['gender']);
    _diagnosisController = TextEditingController(text: widget.patient['diagnosis']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _ageController,
          decoration: const InputDecoration(labelText: 'Age'),
        ),
        TextField(
          controller: _genderController,
          decoration: const InputDecoration(labelText: 'Gender'),
        ),
        TextField(
          controller: _diagnosisController,
          decoration: const InputDecoration(labelText: 'Diagnosis'),
        ),
        ElevatedButton(
          onPressed: () {
            dynamic updatedPatient = {
              'name': _nameController.text,
              'age': int.tryParse(_ageController.text) ?? 0,
              'gender': _genderController.text,
              'diagnosis': _diagnosisController.text,
            };
            widget.onUpdate(updatedPatient);
            Navigator.pop(context); // Return to previous screen
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}