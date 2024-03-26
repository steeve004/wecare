import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wecare/screens/addpatient.dart';
import 'dart:convert';
import 'EditPatientScreen.dart';
import 'addtest.dart';
import 'viewalltest.dart';
import 'AddTestRecordDialog.dart';

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
  // Show confirmation dialog
  bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Set background color to white
        title: Text('Confirm Deletion', style: TextStyle(color: Colors.black)), // Title text color
        content: Text('Are you sure you want to delete this patient?', style: TextStyle(color: Colors.black)), // Content text color
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false if user cancels
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)), // Cancel button text color
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true if user confirms
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)), // Delete button text color
          ),
        ],
      );
    },
  );

  // If user confirms deletion, proceed with deletion
  if (confirmDelete == true) {
    final response = await http.delete(
      Uri.parse('https://wecare-p8lx.onrender.com/patients/$id'),
    );
    if (response.statusCode == 200) {
      setState(() {
        patients.removeWhere((patient) => patient['_id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete patient')),
      );
    }
  }
}



  // Function to update patient details
  Future<void> updatePatient(String id, dynamic updatedPatient) async {
    final response = await http.put(
      Uri.parse('https://wecare-p8lx.onrender.com/patients/$id'),
      body: json.encode(updatedPatient),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      int index = patients.indexWhere((patient) => patient['_id'] == id);
      if (index != -1) {
        setState(() {
          patients[index] = updatedPatient;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient details updated successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update patient details')),
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
            color: Color.fromARGB(255, 10, 11, 9),
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
                  MaterialPageRoute(builder: (context) => const AddPatientScreen()),
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
                child: Text('Add Patients'),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bck5.png"), // Use your image asset here
            fit: BoxFit.cover,
          ),
        ),
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
                    onUpdate: (updatedPatient) {
                      updatePatient(patient['_id'], updatedPatient);
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
  final Function(dynamic) onUpdate;

  AnimatedPatientCard({required this.patient, required this.onDelete, required this.onUpdate});

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
                      "Diagnosis: ${widget.patient['diagnosis']}",
                      style: const TextStyle(color: Colors.white), // White text color
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                    icon: const Icon(Icons.note, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddTestRecordDialog(patientId: widget.patient['_id']);
                        },
                      );
                    },
                  ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                       showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white, // Set background color to white
                            title: const Text('Edit WeCare Patient'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: EditPatientScreen(
                                    patient: widget.patient,
                                    onUpdate: widget.onUpdate,
                                  ),
                                ),
                                const SizedBox(height: 80), // Add some space between the content and the logo
                                Image.asset('assets/images/bck3.png', // Provide the path to your logo image asset
                                  height: 150, // Adjust the height as needed
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
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