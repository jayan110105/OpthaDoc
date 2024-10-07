import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  bool _isLoading = false;
  String? _selectedRole;

  final List<String> _roles = [
    'Reception',
    'Optometrist',
    'Junior Doctor/ PostGraduate',
    'Senior Doctor/ Consultant',
    'Admin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E6DB),
      appBar: AppBar(
          backgroundColor: Color(0xFFE9E6DB),
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Color(0xFFE9E6DB),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                              Icons.person,
                              color: Color(0xFF163352),
                              size: 30,
                          ),
                          SizedBox(width: 10,),
                          Expanded(child: _buildTextField("Name", _usernameController, false)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: Color(0xFF163352),
                            size: 30,
                          ),
                          SizedBox(width: 10,),
                          Expanded(child: _buildTextField("Email", _emailController, false),),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Color(0xFF163352),
                            size: 30,
                          ),
                          SizedBox(width: 10,),
                          Expanded(child: _buildTextField("Password", _passwordController, true),),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.assignment_ind,
                            color: Color(0xFF163352),
                            size: 30,
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Color(0xFFE9E6DB),
                              value: _selectedRole,
                              hint: const Text('Select Role'),
                              decoration: _inputDecoration('Role'),
                              items: _roles.map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a role' : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      _isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF163352),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF163352),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelStyle: const TextStyle(
        color: Color(0xFF163352),
      ),
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Color(0xFF163352),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isPassword) {
    return TextFormField(
      cursorColor: Color(0xFF163352),
      controller: controller,
      obscureText: isPassword,
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      _logger.i("Attempting to register with username: ${_usernameController.text}");

      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Perform additional actions such as saving user data to Firestore or displaying a success message
      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'firstTimeLogin': true,
        'createdAt': Timestamp.now(),
      });

      _logger.i("Registration successful for user: ${_usernameController.text}");

      // Show a success message or navigate to another screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration Successful!'),
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
    } on FirebaseAuthException catch (e) {
      // Handle different errors from FirebaseAuthException
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }

      _logger.e("Registration error: $message");

      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading state
      });
    }
  }
}