import 'package:flutter/material.dart';

class MedicalHistory extends StatelessWidget {
  const MedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical History"),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle("Chief Complaint"),
            SizedBox(height: 10,),
            _buildTextField('Primary reason for the visit'),
            SizedBox(height: 20,),
            _buildTitle("Past Ocular History"),
            SizedBox(height: 10,),
            _buildTextField('Previous eye conditions'),
            SizedBox(height: 10,),
            _buildTextField('Surgeries'),
            SizedBox(height: 10,),
            _buildTextField('Treatments'),
            SizedBox(height: 20,),
            _buildTitle('General Medical History'),
            SizedBox(height: 10,),
            _buildTextField('Chronic diseases'),
            SizedBox(height: 10,),
            _buildTextField('Allergies'),
            SizedBox(height: 10,),
            _buildTextField('Medications'),
            SizedBox(height: 20,),
            _buildTitle('Family History'),
            SizedBox(height: 10,),
            _buildTextField('History of eye diseases in the family'),
            SizedBox(height: 20,),
            _buildTitle('Social History'),
            SizedBox(height: 10,),
            _buildTextField('Smoking'),
            SizedBox(height: 10,),
            _buildTextField('Alcohol consumption'),
            SizedBox(height: 10,),
            _buildTextField('Occupation'),
            SizedBox(height: 20,),
            _buildTitle('Review of Systems'),
            SizedBox(height: 10,),
            _buildTextField('Overview of other symptoms'),
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
            SizedBox(height: 20,),
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
      )
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
