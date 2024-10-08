import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:optha_doc/ui/screens/Records.dart';
import 'package:optha_doc/ui/screens/ScheduleAppointment.dart';
import 'package:optha_doc/ui/screens/User2.dart';
import 'package:hive/hive.dart';
import 'package:optha_doc/services/Hive/optometry_details.dart';
import 'package:optha_doc/services/Hive/patients.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String patientId = '';

  String imageUrl = '';

  String gender = '';

  String name = '';

  String age = '';

  TextEditingController _patientIdController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  Future<Map<String, String>> _getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return {
        'role': userDoc['role'],
        'username': userDoc['username'],
        'email': userDoc['email'],
      };
    }
    return {
      'role': 'Guest',
      'username': 'Guest',
      'email': 'guest@opthadoc.com',
    };
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _checkPatientId(BuildContext context) async {
    String id = _patientIdController.text;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('aadhaarNumber', isEqualTo: id)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ID $id found!'), backgroundColor: Colors.green),
        );
        var patientDoc = querySnapshot.docs.first;
        setState(() {
          patientId = id;
          imageUrl = patientDoc['imageUrl'] ?? '';
          gender = patientDoc['gender'] ?? '';
          name = patientDoc['name'] ?? '';
          age = patientDoc['age'] ?? '';
        });
        _focusNode.unfocus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ID $id not found!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      Logger().e('Error checking patient ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking patient ID: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _uploadDataToFirebase() async {
    try {
      Box<OptometryDetails> optometryBox = Hive.box('optometryDetails');
      List<OptometryDetails> optometryDetailsList = optometryBox.values.toList();

      for (var details in optometryDetailsList) {
        await FirebaseFirestore.instance.collection('optometryDetails').add(details.toMap());
      }

      Box<Patients> patientBox = Hive.box('patients');
      List<Patients>  patientList = patientBox.values.toList();

      for (var patient in patientList) {
        // await FirebaseFirestore.instance.collection('patients').add(patient.toMap());
        if(patient.aadhaarNumber != null && patient.aadhaarNumber != '') {
          await FirebaseFirestore.instance.collection('patients').doc(
              patient.aadhaarNumber).set(patient.toMap());
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data uploaded successfully'), backgroundColor: Colors.green),
      );
    } catch (e) {
      Logger().e('Error uploading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading data: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _showUploadConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFE9E6DB),
          title: Text(
              'Upload Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF163352),
              ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to upload the data to Firebase?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163352),
                  ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                  'Upload',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163352),
                  ),
                ),
              onPressed: () {
                Navigator.of(context).pop();
                _uploadDataToFirebase();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E6DB),
      appBar: _buildAppBar(),
      body: Container(
        child: FutureBuilder<Map<String, String>>(
          future: _getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.black));
            }
            if (snapshot.hasError) {
              Logger().e('Error fetching user details: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            String role = snapshot.data?['role'] ?? 'Guest';
            String username = snapshot.data?['username'] ?? 'Guest';
            String email = snapshot.data?['email'] ?? 'guest@opthadoc.now';
            return _buildDashboardContent(context, role, username, email);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 0, // Hides the app bar completely
    );
  }

  Widget _buildDashboardContent(BuildContext context, String role, String username, String email) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFE9E6DB),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFBBC2B4),
                    radius: 30.0,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$username',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$email',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        _logout(context);
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Color(0xFF163352),
                        size: 30.0,
                      )
                  )
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 10),
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
            // SizedBox(height: 10),
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
                              color: Color(0xFF163352),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),  // Spacing between TextField and Button\
                    // Status Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                  child: _buildDashboardGrid(context, role),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context, String role) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 30.0,
      shrinkWrap: true,
      children: [
        _buildDashboardButton(Icons.person_add, 'Registration', () {
          Navigator.pushNamed(context, '/registration');
        }),
        _buildDashboardButton(Icons.event, 'Appointment', () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScheduleAppointmentScreen(patientId: patientId,))
          );
        }),
        if (role == 'Optometrist' || role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant' || role == 'Admin')
          _buildDashboardButton(Icons.visibility, 'Eye Checkup', () {
            // Navigator.pushNamed(context, '/eyecheckup');
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => User2(patientId: patientId))
            );
          }),
        if (role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant' || role == 'Admin')
          _buildDashboardButton(Icons.assignment, 'View Records', () {
            // Navigator.pushNamed(context, '/viewrecords');
            Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => Records(routeName: 'ViewRecords', patientId: patientId))
            );
          }),
        if (role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant' || role == 'Admin')
          _buildDashboardButton(Icons.edit, 'Edit Records', () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Records(routeName: 'EditRecords', patientId: patientId))
            );
          }),
        if (role == 'Senior Doctor/ Consultant' || role == 'Admin')
          _buildDashboardButton(Icons.cloud_upload, 'Upload Data', () {
            _showUploadConfirmationDialog();
          }),
        if (role == 'Admin')
          _buildDashboardButton(Icons.admin_panel_settings, 'Register User', () {
            Navigator.pushNamed(context, '/register');
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