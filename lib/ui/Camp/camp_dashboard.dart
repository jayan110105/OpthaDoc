import 'package:flutter/material.dart';
import 'package:optha_doc/ui/Camp/camp_eyecheckup.dart';
import 'package:optha_doc/ui/Camp/camp_records.dart';
import 'package:hive/hive.dart';

import '../../services/Hive/patients.dart';

class campDashboard extends StatefulWidget {
  const campDashboard({super.key});

  @override
  State<campDashboard> createState() => _campDashboardState();
}

class _campDashboardState extends State<campDashboard> {
  String patientId = '';

  String imageUrl = '';

  String gender = '';

  String name = '';

  String age = '';

  TextEditingController _patientIdController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  Future<void> _checkPatientId(BuildContext context) async {
    String id = _patientIdController.text;
    try {
      final box = Hive.box<Patients>('patients');
      final patient = box.values.firstWhere(
            (patient) => patient.aadhaarNumber == id
      );

      final patientDetails = patient.toMap();

      if (patient != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ID $id found!'), backgroundColor: Colors.green),
        );
        setState(() {
          patientId = id;
          imageUrl = patientDetails['imageUrl'] ?? '';
          gender = patientDetails['gender'] ?? '';
          name = patientDetails['name'] ?? '';
          age = patientDetails['age'] ?? '';
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
      backgroundColor: Color(0xFFE9E6DB),
      appBar: _buildAppBar(),
      body: _buildDashboardContent(context),
      );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 0, // Hides the app bar completely
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFE9E6DB),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageUrl != null && imageUrl != '' ? CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(imageUrl),
                    backgroundColor: Colors.transparent,
                  )
                      : CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFBBC2B4),
                    child: Icon(
                      gender =="Female" ? Icons.face_3: Icons.face,
                      color: Color(0xFF163352),
                      size: 80,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name == "" ? 'Name' : '$name',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            gender == "" ? Icons.transgender : gender == "Male" ? Icons.male : Icons.female,
                            color: Color(0xFF163352),
                            size: 20.0,
                          ),
                          SizedBox(width: 10),
                          Text(
                            gender == "" ? "Gender" : '$gender',
                            style: TextStyle(
                              color: Color(0xFF163352),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(
                            Icons.cake,
                            color: Color(0xFF163352),
                            size: 20.0,
                          ),
                          SizedBox(width: 10),
                          Text(
                            age == "" ? 'Age' : '$age',
                            style: TextStyle(
                              color: Color(0xFF163352),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFBBC2B4),
                  border: Border.all(color: Color(0xFF163352)),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
                        child: TextField(
                          controller: _patientIdController,
                          focusNode: _focusNode,
                          cursorColor: Color(0xFF163352),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            hintText: 'Enter Patient ID',  // Placeholder text
                            hintStyle: TextStyle(
                              color:  Color(0xFF163352),
                            ),
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
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF163352), // Button text color
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
                  color: Color(0xFFBBC2B4), // Background color
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
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
                MaterialPageRoute(builder: (context) => CampEyeCheckUP(patientId: patientId))
            );
          }),
          _buildDashboardButton(Icons.assignment, 'View Records', () {
            // Navigator.pushNamed(context, '/viewrecords');
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CampRecords(routeName: 'ViewRecords', patientId: patientId))
            );
          }),
          _buildDashboardButton(Icons.edit, 'Edit Records', () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CampRecords(routeName: 'EditRecords', patientId: patientId))
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
            backgroundColor: Color(0xFF163352),
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
