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
          backgroundColor: Color(0xFFE9E6DB),
          title: Center(
            child: Text(
              "New patient record",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:Color(0xFF163352),
              ), // Reduced font size
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF163352),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFE9E6DB),
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
                        backgroundColor: Color(0xFFBBC2B4),
                        radius: 80,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Icon(Icons.camera_alt, color: Color(0xFF163352), size: 60)
                            : null,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Color(0xFF163352),
                              ),
                              SizedBox(width: 10),
                              Text(
                                  'Patient Name',
                                  style: TextStyle(
                                    color: Color(0xFF163352),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          _buildTextField('', _nameController),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Icons.cake,
                                color: Color(0xFF163352),
                              ),
                              SizedBox(width: 10),
                              Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Color(0xFF163352),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          _buildTextField('', _ageController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Icon(
                      Icons.wc,
                      color: Color(0xFF163352),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Gender',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    SizedBox(width: 80,),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Color(0xFFE9E6DB) ,
                        value: _selectedGender,
                        hint: const Text('Select Gender'),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Color(0xFF163352),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Color(0xFF163352),
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: Color(0xFF163352),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Aadhar Card',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    SizedBox(width: 30,),
                    Expanded(child: _buildTextField('', _aadhaarController)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.family_restroom,
                      color: Color(0xFF163352),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Parent/Spouse',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    SizedBox(width: 10),
                    Expanded(child: _buildTextField('', _parentController)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Color(0xFF163352),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Phone No.',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    SizedBox(width: 60),
                    Expanded(child: _buildTextField('', _phoneController, prefixText: '+91 ')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: Color(0xFF163352),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Address',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextArea('', _addressController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.assignment,
                      color: Color(0xFF163352),
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Chief Complaint',
                        style: TextStyle(
                          color: Color(0xFF163352),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextArea('', _addressController),
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
                              child: CircularProgressIndicator(color: Color(0xFF163352),)
                          )
                        )
                        : _buildFilledButton("Save", onPressed: savePatientRecord),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, {String? prefixText}) {
    return TextField(
      cursorColor: Color(0xFF163352),
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color(0xFF163352),
        ),
        labelText: labelText,
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color(0xFF163352),
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea(String labelText, TextEditingController controller, {String? prefixText}) {
    return TextField(
      cursorColor: Color(0xFF163352),
      controller: controller,
      maxLines: 5, // Set maxLines to a higher value for a text area
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          color: Color(0xFF163352),
        ),
        labelText: labelText,
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color(0xFF163352),
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
        backgroundColor: Color(0xFF163352),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildOutlinedButton(String label, {required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFBBC2B4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          // side: BorderSide(color: Colors.black, width: 0.5),
        ),
        padding: const EdgeInsets.all(10),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Text(label, style: TextStyle(color: Color(0xFF163352))),
      ),
    );
  }

  Widget _buildFilledButton(String label, {required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF163352),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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