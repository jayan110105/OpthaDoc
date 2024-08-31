import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      "OpthaDoc",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Username", _usernameController, false),
                  const SizedBox(height: 20),
                  _buildTextField("Password", _passwordController, true),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.black,),)
                      : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                          'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                          'Register',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String text, TextEditingController controller, bool isPassword) {
    return  TextField(
      cursorColor: Colors.black,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Start loading state
    });

    try {
      // Retrieve email from Firestore based on username
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: _usernameController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that username.',
        );
      }

      String email = querySnapshot.docs.first['email'];

      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );

      // Navigate to another screen or show success message
      Navigator.pushNamed(context, '/rolelogin');
    } on FirebaseAuthException catch (e) {
      // Handle different errors from FirebaseAuthException
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that username.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }

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
