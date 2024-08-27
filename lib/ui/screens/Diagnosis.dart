import 'package:flutter/material.dart';

class Diagnosis extends StatelessWidget {
  const Diagnosis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diagnosis and Plan of Treatment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle("Diagnosis"),
            const SizedBox(height: 10),
            _buildTextField("Final Diagnosis"),
            const SizedBox(height: 20),
            _buildTitle("Plan of Treatment"),
            const SizedBox(height: 10),
            _buildTextField("Medication"),
            const SizedBox(height: 10),
            _buildTextField("Procedure"),
            const SizedBox(height: 10),
            _buildTextField("Follow-up"),
            const SizedBox(height: 10),
            _buildTextField("patient Education"),
            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  // Define the action when the button is pressed
                },
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),  // Choose the desired icon, e.g., a camera icon
                label: Text(
                  "Add a photo",
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
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      //backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 0.5),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(String text) {
    return  TextField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
