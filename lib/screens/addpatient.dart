import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewpatients.dart';
import 'addtest.dart';
import 'viewalltest.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  bool _isMale = false; // Variable to track if male is selected
  bool _isFemale = false; // Variable to track if female is selected
  int? _age;
  String? _diagnosis;
  DateTime? _dateOfBirth;

  void _handleGenderChange(bool? value) {
    setState(() {
      if (value != null) {
        _isMale = value;
        _isFemale = !value;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _age = DateTime.now().year - _dateOfBirth!.year;
      });
    }
  }

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    final Map<String, dynamic> data = {
      'name': _name,
      'gender': _isMale ? 'Male' : 'Female',
      'age': _age,
      'diagnosis': _diagnosis,
    };

    final response = await http.post(
      Uri.parse('https://wecare-p8lx.onrender.com/addPatient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient record added successfully')),
      );
      // Clear input fields and reset form state
      _formKey.currentState!.reset();
      setState(() {
        _isMale = false;
        _isFemale = false;
        _dateOfBirth = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add patient record')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Patient',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 34, 95, 11),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 1000,
            height: 1000,
            child: Image.asset('assets/images/bck3.png'),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'viewPatients') {
                // Navigate to view patients screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewPatientsScreen()),
                );
              } else if (value == 'addTest') {
                // Navigate to add test screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTestsScreen()));
              } else if (value == 'viewAllTests') {
                // Navigate to view all tests screen
               Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewAllTestsScreen()));
              }else if (value == 'logOut') {
                //navigate to logout
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'viewPatients',
                child: Text('View Patients'),
              ),
              const PopupMenuItem<String>(
                value: 'addTest',
                child: Text('Add Test'),
              ),
              const PopupMenuItem<String>(
                value: 'viewAllTests',
                child: Text('View All Tests'),
              ),
              const PopupMenuItem<String>(
                value: 'logOut',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bck5.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Radio(
                      value: true,
                      groupValue: _isMale,
                      onChanged: _handleGenderChange,
                    ),
                    const Text('Male'),
                    Radio(
                      value: false,
                      groupValue: _isFemale,
                      onChanged: _handleGenderChange,
                    ),
                    const Text('Female'),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _dateOfBirth != null
                        ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                        : '',
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (_dateOfBirth == null) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Diagnosis',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient diagnosis';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _diagnosis = value;
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 22, 83, 24),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
