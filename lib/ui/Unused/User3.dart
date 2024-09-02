import 'package:flutter/material.dart';

class User3 extends StatelessWidget {
  const User3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User 3"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/medicalhistory');
              },
              icon: Icon(
                Icons.history,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Medical history",
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
                Navigator.pushNamed(context, '/clinicalexamination');
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Clinical examination",
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
                Navigator.pushNamed(context, '/diagnosis');
              },
              icon: Icon(
                Icons.fact_check,
                color: Colors.white,
              ),  // Choose the desired icon, e.g., a camera icon
              label: Text(
                "Diagnosis",
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
