import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optha_doc/firebase_options.dart';
import 'package:optha_doc/ui/screens/PatientSearch.dart';
import 'package:optha_doc/ui/screens/login.dart';
import 'package:optha_doc/ui/screens/register.dart';
import 'package:optha_doc/ui/screens/User1.dart';
import 'package:optha_doc/ui/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(initialRoute: user != null ? '/dashboard' : '/home'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.black, // Change the selection handle (cursor dropper) color to black
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/dashboard': (context) => const Dashboard(),
        '/registartion': (context) => const User1(),
        '/eyecheckup': (context) => const SearchPatient(routeName: 'eyecheckup'),
        '/viewrecords': (context) => const SearchPatient(routeName: 'viewrecords'),
        '/editrecords': (context) => const SearchPatient(routeName: 'editrecords'),
        '/appointment': (context) => const SearchPatient(routeName: 'appointment'),
      },
    );
  }
}

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
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                tooltip: 'Go to Login', // Accessibility improvement
              ),
            ),
          ],
        ),
      ),
    );
  }
}