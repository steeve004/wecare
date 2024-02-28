import 'package:flutter/material.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _gender;
  int? _age;
  String? _diagnosis;
  DateTime? _dateOfBirth;

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
        // Calculate age from date of birth
        _age = DateTime.now().year - _dateOfBirth!.year;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: const Text(
    'Add Patient',
    style: TextStyle(
      fontSize: 24, // Set the font size of the title
      fontWeight: FontWeight.bold, // Set the font weight of the title to bold
      color: Color.fromARGB(255, 34, 95, 11), // Set the color of the title
      // You can add more decorations here, such as shadows, etc.
    ),
  ),
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox( // Wrap the image with a SizedBox to specify the size
      width: 1000, // Specify the width
      height: 1000, // Specify the height
      child: Image.asset('assets/images/bck3.png'), // Replace 'assets/images/bck3.png' with your image asset path
    ),
  ),
),
    body: Center( // Center the form vertically and horizontally
      child: Container(
        color: Color.fromARGB(255, 207, 223, 213),
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0), // Add padding to the top
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 18, 91, 33), fontSize: 20,fontWeight: FontWeight.bold),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 18, 91, 33), fontSize: 20,fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient gender';
                  }
                  return null;
                },
                onSaved: (value) {
                  _gender = value;
                },
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
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 18, 91, 33), fontSize: 20,fontWeight: FontWeight.bold,),
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
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 18, 91, 33), fontSize: 20, fontWeight: FontWeight.bold,),
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
                child: Center( // Center the button horizontally
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Call a function to save patient record with _name, _gender, _age, _diagnosis
                        // For example: savePatientRecord(_name, _gender, _age, _diagnosis);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 22, 83, 24), // Set the button's text color to white // Set button background color to green
                      minimumSize: const Size(double.infinity, 48),
                    ),
                   child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18), // Set font size here
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