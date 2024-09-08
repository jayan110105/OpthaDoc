import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:optha_doc/ui/screens/EditRecords.dart';
import 'package:optha_doc/ui/screens/User2.dart';
import 'package:optha_doc/ui/screens/ViewRecords.dart';
import 'package:optha_doc/ui/screens/appointment.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String patientId = '';

  TextEditingController _patientIdController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  Future<Map<String, String>> _getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return {
        'role': userDoc['role'],
        'username': userDoc['username'],
      };
    }
    return {
      'role': 'Guest',
      'username': 'Guest',
    };
  }

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
      Logger().e('Error checking patient ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking patient ID: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<Map<String, String>>(
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
          String greeting = _getGreeting();
          return _buildDashboardContent(context, role, username, greeting);
        },
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

  Widget _buildDashboardContent(BuildContext context, String role, String username, String greeting) {
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
                    '$greeting, $username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildMenuAnchor(context),
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
                  child: _buildDashboardGrid(context, role),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuAnchor(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        elevation: WidgetStateProperty.all(10),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
          ),
        );
      },
      menuChildren: [
        Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _logout(context),
          ),
        ),
      ],
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
        if (role == 'Optometrist' || role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant')
          _buildDashboardButton(Icons.visibility, 'Eye Checkup', () {
            // Navigator.pushNamed(context, '/eyecheckup');
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => User2(patientId: patientId))
            );
          }),
        if (role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant')
          _buildDashboardButton(Icons.assignment, 'View Records', () {
            // Navigator.pushNamed(context, '/viewrecords');
            Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => Viewrecords(patientId: patientId))
            );
          }),
        if (role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant')
          _buildDashboardButton(Icons.edit, 'Edit Records', () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditRecords(patientId: patientId))
            );
          }),
        if (role == 'Senior Doctor/ Consultant')
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