import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optha_doc/firebase_options.dart';
import 'package:optha_doc/services/Hive/patients.dart';
import 'package:optha_doc/services/Hive/optometry_details.dart';
import 'package:optha_doc/ui/Camp/camp_dashboard.dart';
import 'package:optha_doc/ui/Camp/camp_registration.dart';
import 'package:optha_doc/ui/Unused/PatientSearch.dart';
import 'package:optha_doc/ui/screens/login.dart';
import 'package:optha_doc/ui/screens/register.dart';
import 'package:optha_doc/ui/screens/User1.dart';
import 'package:optha_doc/ui/screens/dashboard.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  await Hive.initFlutter();
  await Hive.initFlutter();
  Hive.registerAdapter(PatientsAdapter());
  Hive.registerAdapter(OptometryDetailsAdapter());
  await Hive.openBox<Patients>('patients');
  await Hive.openBox<OptometryDetails>('optometryDetails');

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
        '/campdashboard': (context) => const campDashboard(),
        '/registration': (context) => const User1(),
        '/campregistration': (context) => const campRegistration(),
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
              'Opthalmology EMR',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/campdashboard');
                      },
                      child: const Text('Camp'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(150, 50), // Ensure both buttons have the same size
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Hospital'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(150, 50), // Ensure both buttons have the same size
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: IconButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/login');
            //     },
            //     icon: const Icon(Icons.arrow_forward, color: Colors.white),
            //     tooltip: 'Go to Login', // Accessibility improvement
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}