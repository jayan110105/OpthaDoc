import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 0, // Hides the app bar completely
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.black,));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          String role = snapshot.data?['role'] ?? 'Guest';
          String username = snapshot.data?['username'] ?? 'Guest';
          String greeting = _getGreeting();
          return Container(
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
                      MenuAnchor(
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
                            // color: Colors.white,
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(10),
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.black26,
                            //       blurRadius: 5,
                            //       offset: Offset(0, 1),
                            //     ),
                            //   ],
                            // ),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Background color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 30.0,
                        shrinkWrap: true,
                        children: [
                          _buildDashboardButton(Icons.person_add, 'Registration', () {
                            Navigator.pushNamed(context, '/user1');
                          }),
                          if (role == 'Optometrist' || role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant')
                            _buildDashboardButton(Icons.visibility, 'Eye Checkup', () {
                              Navigator.pushNamed(context, '/patientsearch');
                            }),
                          if (role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant')
                            _buildDashboardButton(Icons.assignment, 'View Records',(){}),
                          if (role == 'Junior Doctor/ PostGraduate' || role == 'Senior Doctor/ Consultant')
                            _buildDashboardButton(Icons.edit, 'Edit Records',(){}),
                          if (role == 'Senior Doctor/ Consultant')
                            _buildDashboardButton(Icons.event, 'Appointment',(){}),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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