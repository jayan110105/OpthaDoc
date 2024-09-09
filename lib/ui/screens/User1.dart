import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:firebase_storage/firebase_storage.dart';

class User1 extends StatefulWidget {
  const User1({super.key});

  @override
  State<User1> createState() => _User1State();
}

class _User1State extends State<User1> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _parentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = 'patients/${_nameController.text}.jpg';
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> savePatientRecord() async {
    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImage(_image!);
      }

      await _firestore.collection('patients').doc(_aadhaarController.text.trim().replaceAll(' ', '')).set({
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim(),
        'gender': _selectedGender,
        'aadhaarNumber': _aadhaarController.text.trim().replaceAll(' ', ''),
        'parent/spouseName': _parentController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      print("Saving patient record...");
      // Show success message or navigate to another screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Patient record saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to save patient record: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    finally {
      setState(() {
        _isLoading = false; // Stop loading state
      });
    }
  }

  final List<String> _gender = [
    'Male',
    'Female',
  ];

  String scannedText = "";
  File? _image;

  Map<String,String> preprocessAadhaarText(String scannedText) {
    // Normalize the text by converting to lowercase and removing extra whitespaces
    String normalizedText = scannedText.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // Extract Name - assuming it appears before the DOB or gender
    String namePattern = r'government of india\s*(.*?)\s*(?:dob|date of birth|date of bith|gender|male|female)';
    RegExp nameRegex = RegExp(namePattern, caseSensitive: false);
    String name = capitalize(nameRegex.firstMatch(normalizedText)?.group(1)?.trim()) ?? 'Name not found';

    // Extract Date of Birth
    String dobPattern = r'(dob:|date of birth[: ]*)\s*(\d{1,2}/\d{1,2}/\d{4})';
    RegExp dobRegex = RegExp(dobPattern, caseSensitive: false);
    String dob = dobRegex.firstMatch(normalizedText)?.group(2) ?? 'DOB not found';

    int age = -1;
    if (dob != 'DOB not found') {
      DateTime dobDate = DateTime.parse(dob.split('/').reversed.join('-'));
      DateTime today = DateTime.now();
      age = today.year - dobDate.year;
      if (today.month < dobDate.month || (today.month == dobDate.month && today.day < dobDate.day)) {
        age--;
      }
    }

    // Extract Gender
    String genderPattern = r'\b(male|female)\b';
    RegExp genderRegex = RegExp(genderPattern, caseSensitive: false);
    String gender = capitalize(genderRegex.firstMatch(normalizedText)?.group(0)) ?? 'Gender not found';

    // Extract Aadhaar Number
    String aadhaarPattern = r'\b\d{4} \d{4} \d{4}\b';
    RegExp aadhaarRegex = RegExp(aadhaarPattern);
    String aadhaarNumber = aadhaarRegex.firstMatch(normalizedText)?.group(0) ?? 'Aadhaar number not found';

    // Return a formatted string or a map with extracted data
    return {
      'name': name,
      'age': age == -1 ? 'Age not found' : age.toString(),
      'gender': gender,
      'aadhaarNumber': aadhaarNumber,
    };
  }

  String? capitalize(String? input) {
    if (input == null || input.isEmpty) {
      return input;
    }
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }

  Future<void> scanText() async {
    File? imageFile = await getImage();
    if (imageFile != null) {
      String text = await performOCR(imageFile);
      Map<String, String> extractedData = preprocessAadhaarText(text);
      setState(() {
        _nameController.text = extractedData['name'] ?? '';
        _ageController.text = extractedData['age'] ?? '';
        _selectedGender = extractedData['gender'] ?? '';
        _aadhaarController.text = extractedData['aadhaarNumber'] ?? '';
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
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      File? imageFile = await getImage();
                      if (imageFile != null) {
                        setState(() {
                          _image = imageFile;
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 60,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.camera_alt, color: Colors.white, size: 40)
                          : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTextField('Patient Name', _nameController),
                        const SizedBox(height: 20),
                        _buildTextField('Age', _ageController),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: const Text('Select Gender'),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                items: _gender.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildTextField('Aadhar Card No.', _aadhaarController),
              const SizedBox(height: 20),
              _buildTextField('Parent/Spouse Name', _parentController),
              const SizedBox(height: 20),
              _buildTextField('Phone No.', _phoneController, prefixText: '+91 '),
              const SizedBox(height: 20),
              _buildTextArea('Address', _addressController),
              const SizedBox(height: 20),
              _buildTextArea('Chief Complaint', _addressController),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOutlinedButton("Cancel", onPressed: () {}),
                  _isLoading
                      ? Container(
                        width: 200,
                        child: Center(
                            child: CircularProgressIndicator(color: Colors.black,)
                        )
                      )
                      : _buildFilledButton("Save", onPressed: savePatientRecord),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, {String? prefixText}) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
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

  Widget _buildTextArea(String labelText, TextEditingController controller, {String? prefixText}) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
      maxLines: 5, // Set maxLines to a higher value for a text area
      decoration: InputDecoration(
        alignLabelWithHint: true,
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