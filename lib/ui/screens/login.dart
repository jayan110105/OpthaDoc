import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                  TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                    ),
                  ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/user1');
                      },
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
}
