import 'package:flutter/material.dart';
import 'package:optha_doc/ui/screens/Diagnosis.dart';
import 'package:optha_doc/ui/screens/User3.dart';
import 'package:optha_doc/ui/screens/login.dart';
import 'package:optha_doc/ui/screens/register.dart';
import 'package:optha_doc/ui/screens/User1.dart';
import 'package:optha_doc/ui/screens/User2.dart';
import 'package:optha_doc/ui/screens/MedicalHistory.dart';
import 'package:optha_doc/ui/screens/ClinicalExamination.dart';
import 'package:optha_doc/ui/screens/RoleLogin.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/home': (context) => const Home(),
    '/login': (context) => const Login(),
    '/register': (context) => const Register(),
    '/user1' : (context) => const User1(),
    '/user2' : (context) => const User2(),
    '/user3' : (context) => const User3(),
    '/medicalhistory' : (context) => const MedicalHistory(),
    '/clinicalexamination' : (context) => const Clinicalexamination(),
    '/diagnosis' : (context) => const Diagnosis(),
    '/rolelogin' : (context) => const Rolelogin(),
  },
  //home: Home(),
));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/homepage.jpg', // Replace with your image path
              height: 300, // Adjust the size as needed
            ),
            const Text(
                'OpthaDoc',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            const Text(
                'Documentation Tool',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 23,
            ),
            ),
            const SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
