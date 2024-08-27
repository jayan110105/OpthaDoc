import 'package:flutter/material.dart';

class Rolelogin extends StatelessWidget {
  const Rolelogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Role Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/user1');
              },
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Receptionist",
                style: TextStyle(color: Colors.white),
              ),       // The text that appears next to the icon
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20,),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/user2');
              },
              icon: Icon(
                Icons.visibility,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Optometrist",
                style: TextStyle(color: Colors.white),
              ),       // The text that appears next to the icon
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20,),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/user3');
              },
              icon: Icon(
                Icons.school,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Junior Doctor/PostGraduate",
                style: TextStyle(color: Colors.white),
              ),       // The text that appears next to the icon
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 20,),
            TextButton.icon(
              onPressed: () {
                // Define the action when the button is pressed
              },
              icon: Icon(
                Icons.local_hospital,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Senior Doctor/Consultant",
                style: TextStyle(color: Colors.white),
              ),       // The text that appears next to the icon
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
