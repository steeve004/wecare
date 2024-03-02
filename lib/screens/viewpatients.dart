import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPatientsScreen extends StatefulWidget {
  const ViewPatientsScreen({Key? key}) : super(key: key);

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
    final response = await http.get(Uri.parse('https://wecare-p8lx.onrender.com/patients'));
    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body); // Decode JSON response
      });
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  // Function to delete a patient
  Future<void> deletePatient(String id) async {
    final response = await http.delete(
      Uri.parse('https://wecare-p8lx.onrender.com/patients/$id'),
    );
    if (response.statusCode == 200) {
      // Patient deleted successfully
      // Remove the deleted patient from the local list
      setState(() {
        patients.removeWhere((patient) => patient['_id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient deleted successfully')),
      );
    } else {
      // Failed to delete patient
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete patient')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Patients',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 34, 95, 11),
          ),
        ),
      ),
      body: Container(
        child: patients.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: patients.length,
                itemBuilder: (BuildContext context, int index) {
                  final patient = patients[index];
                  return AnimatedPatientCard(
                    patient: patient,
                    onDelete: (id) {
                      deletePatient(id);
                    },
                  );
                },
              ),
      ),
    );
  }
}

class AnimatedPatientCard extends StatefulWidget {
  final dynamic patient;
  final Function(String) onDelete;

  AnimatedPatientCard({required this.patient, required this.onDelete});

  @override
  _AnimatedPatientCardState createState() => _AnimatedPatientCardState();
}

class _AnimatedPatientCardState extends State<AnimatedPatientCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, 100 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: Card(
              color: const Color.fromARGB(255, 7, 85, 12), // Dark green color
              child: ListTile(
                title: Text(
                  widget.patient['name'],
                  style: const TextStyle(color: Colors.white), // White text color
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Age: ${widget.patient['age']}",
                      style: const TextStyle(color: Colors.white), // White text color
                    ),
                    Text(
                      "Gender: ${widget.patient['gender']}",
                      style: const TextStyle(color: Colors.white), // White text color
                    ),
                    Text(
                      "diagnosis: ${widget.patient['diagnosis']}",
                      style: const TextStyle(color: Colors.white), // White text color
                    ),
                    // Add more details as needed
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.nordic_walking, color: Colors.white),
                      onPressed: () {
                        // Implement tests functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        // Implement update functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        // Call the onDelete callback function
                        widget.onDelete(widget.patient['_id']);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
