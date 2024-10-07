import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class ChangePassword extends StatefulWidget {
  final String email;

  ChangePassword({required this.email});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_passwordController.text.trim());

        await _firestore.collection('users').doc(user.uid).update({
          'firstTimeLogin': false,
        });

        _logger.i("Password changed successfully for user: ${widget.email}");

        // Show a success message or navigate to another screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFFE9E6DB),
            title: const Text('Success'),
            content: const Text('Password changed successfully!'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF163352),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: const Text('OK', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _logger.e("Error changing password: $e");

      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFFE9E6DB),
          title: const Text('Error'),
          content: Text('Error changing password'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF163352),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white),),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E6DB),
      appBar: AppBar(
          backgroundColor: Color(0xFFE9E6DB),
          title: Center(
            child: Text(
              "Change Password",
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color:  Color(0xFFE9E6DB),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    const Text(
                      "OpthaDoc",
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
                          Icons.lock,
                          color: Color(0xFF163352),
                          size: 30,
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: _buildTextField("New Password", _passwordController, true),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(
                          Icons.lock_person,
                          color: Color(0xFF163352),
                          size: 30,
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: _buildValidTextField("Confirm Password", _confirmPasswordController, true),),
                      ],
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF163352),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF163352),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        'Change Password',
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
          return '$label';
        }
        return null;
      },
    );
  }

  Widget _buildValidTextField(String label, TextEditingController controller, bool isPassword) {
    return TextFormField(
      cursorColor: Color(0xFF163352),
      controller: controller,
      obscureText: isPassword,
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your new password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}