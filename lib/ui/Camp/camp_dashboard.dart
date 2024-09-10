import 'package:flutter/material.dart';
import 'package:optha_doc/ui/screens/Records.dart';
import 'package:optha_doc/ui/screens/User2.dart';
import 'package:optha_doc/ui/screens/appointment.dart';
import 'package:hive/hive.dart';

import '../../services/Hive/patients.dart';

class campDashboard extends StatefulWidget {
  const campDashboard({super.key});

  @override
  State<campDashboard> createState() => _campDashboardState();
}

class _campDashboardState extends State<campDashboard> {
  String patientId = '';

  TextEditingController _patientIdController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String _getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> _checkPatientId(BuildContext context) async {
    String id = _patientIdController.text;
    try {
      final box = Hive.box<Patients>('patients');
      final patient = box.values.firstWhere(
            (patient) => patient.aadhaarNumber == id
      );

      if (patient != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ID $id found!'), backgroundColor: Colors.green),
        );
        setState(() {
          patientId = id;
        });
        _focusNode.unfocus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ID $id not found!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error checking patient ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient ID $id not found!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildDashboardContent(context, _getGreeting()),
      );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 0, // Hides the app bar completely
    );
  }

  Widget _buildDashboardContent(BuildContext context, String greeting) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _patientIdController,
                        focusNode: _focusNode,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          hintText: 'Enter Patient ID',  // Placeholder text
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),  // Spacing between TextField and Button\
                    // Status Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_focusNode.hasFocus) {
                            _checkPatientId(context);
                          } else {
                            _focusNode.requestFocus();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          backgroundColor: Colors.grey[200], // Button text color
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              patientId == '' ? 'Confirm':'Change',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Background color
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                child: Center(
                  child: _buildDashboardGrid(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 30.0,
      shrinkWrap: true,
      children: [
        _buildDashboardButton(Icons.person_add, 'Registration', () {
          Navigator.pushNamed(context, '/campregistration');
        }),
          _buildDashboardButton(Icons.visibility, 'Eye Checkup', () {
            // Navigator.pushNamed(context, '/eyecheckup');
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => User2(patientId: patientId))
            );
          }),
          _buildDashboardButton(Icons.assignment, 'View Records', () {
            // Navigator.pushNamed(context, '/viewrecords');
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Records(routeName: 'ViewRecords', patientId: patientId))
            );
          }),
          _buildDashboardButton(Icons.edit, 'Edit Records', () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Records(routeName: 'EditRecords', patientId: patientId))
            );
          }),
          _buildDashboardButton(Icons.event, 'Appointment', () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Appointment(patientId: patientId))
            );
          }),
      ],
    );
  }

  Widget _buildDashboardButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shadowColor: Colors.grey[200],
            elevation: 5,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16.0),
          ),
          child: Icon(
            icon,
            size: 30.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
