import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class User1 extends StatefulWidget {
  const User1({super.key});

  @override
  State<User1> createState() => _User1State();
}

class _User1State extends State<User1> {
  String scannedText = "";
  File? _image;

  String preprocessAadhaarText(String scannedText) {
    // Normalize the text by converting to lowercase and removing extra whitespaces
    String normalizedText = scannedText.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // Extract Name - assuming it appears before the DOB or gender
    String namePattern = r'government of india\s*(.*?)\s*(?:dob|date of birth|date of bith|gender|male|female)';
    RegExp nameRegex = RegExp(namePattern, caseSensitive: false);
    String name = nameRegex.firstMatch(normalizedText)?.group(1)?.trim() ?? 'Name not found';

    // Extract Date of Birth
    String dobPattern = r'(dob:|date of birth[: ]*)\s*(\d{1,2}/\d{1,2}/\d{4})';
    RegExp dobRegex = RegExp(dobPattern, caseSensitive: false);
    String dob = dobRegex.firstMatch(normalizedText)?.group(2) ?? 'DOB not found';

    // Extract Gender
    String genderPattern = r'\b(male|female)\b';
    RegExp genderRegex = RegExp(genderPattern, caseSensitive: false);
    String gender = capitalize(genderRegex.firstMatch(normalizedText)?.group(0)) ?? 'Gender not found';

    // Extract Aadhaar Number
    String aadhaarPattern = r'\b\d{4} \d{4} \d{4}\b';
    RegExp aadhaarRegex = RegExp(aadhaarPattern);
    String aadhaarNumber = aadhaarRegex.firstMatch(normalizedText)?.group(0) ?? 'Aadhaar number not found';

    // Return a formatted string or a map with extracted data
    return 'Name: $name\nDOB: $dob\nGender: $gender\nAadhaar Number: $aadhaarNumber';
  }

  String? capitalize(String? input) {
    if (input == null) {
      return null;
    }
    if (input.isEmpty) {
      return input;
    }
    return '${input[0].toUpperCase()}${input.substring(1)}';
  }

  Future<void> scanText() async {
    File? imageFile = await getImage();
    if (imageFile != null) {
      String text = await performOCR(imageFile);
      setState(() {
        scannedText = preprocessAadhaarText(text);
        _image = imageFile;
      });
    }
  }

  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // or ImageSource.gallery

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String> performOCR(File imageFile) async {
    // Convert the image to an InputImage object
    final inputImage = InputImage.fromFile(imageFile);

    // Initialize the text recognizer
    final textRecognizer = TextRecognizer();

    // Process the image and recognize text
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // Extract the text
    String extractedText = recognizedText.text;

    // Close the recognizer to free up resources
    textRecognizer.close();

    return extractedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person_add),
            SizedBox(width: 8),
            Text("New patient record"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('Patient Name'),
              const SizedBox(height: 20),
              _buildTextField('Age'),
              const SizedBox(height: 20),
              _buildTextField('Phone No.', prefixText: '+91 '),
              const SizedBox(height: 20),
              _buildTextField('Aadhar Card No.'),
              const SizedBox(height: 20),
              _buildTextField('Address'),
              const SizedBox(height: 20),
              _buildTextField('Hospital No.'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: _buildTextButton(
                  icon: Icons.photo_camera,
                  label: "Scan Aadhar Card",
                  onPressed: scanText,
                ),
              ),
              const SizedBox(height: 20),
              Text(scannedText),
              //Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOutlinedButton("Cancel", onPressed: () {}),
                  _buildFilledButton("Save", onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, {String? prefixText}) {
    return TextField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        labelText: labelText,
        prefixText: prefixText,
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

  Widget _buildTextButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildOutlinedButton(String label, {required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black, width: 0.5),
        ),
        padding: const EdgeInsets.all(10),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildFilledButton(String label, {required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}