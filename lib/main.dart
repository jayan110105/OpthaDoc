import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optha_doc/firebase_options.dart';
import 'package:optha_doc/services/Hive/patients.dart';
import 'package:optha_doc/services/Hive/optometry_details.dart';
import 'package:optha_doc/ui/Camp/camp_dashboard.dart';
import 'package:optha_doc/ui/Camp/camp_registration.dart';
import 'package:optha_doc/ui/screens/login.dart';
import 'package:optha_doc/ui/screens/register.dart';
import 'package:optha_doc/ui/screens/User1.dart';
import 'package:optha_doc/ui/screens/dashboard.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
        dividerColor: Colors.transparent, // Change the divider color to black
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Color(0xFF163352), // Change the selection handle (cursor dropper) color to black
        ),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF163352),), // Default text color
          bodyMedium: TextStyle(color: Color(0xFF163352),), // Default text color
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
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true; // Connected to mobile or wifi
    } else {
      return false; // Not connected to the internet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E6DB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'OpthaDoc',
              style: TextStyle(
                color: Color(0xFF163352),
                fontWeight: FontWeight.bold,
                fontSize: 62,
              ),
            ),
            const Text(
              'Opthalmology EMR System',
              style: TextStyle(
                color: Color(0xFF163352),
                fontWeight: FontWeight.w500,
                fontSize: 23,
              ),
            ),
            Image.asset(
              'assets/images/homepage.jpg', // Replace with your image path
              height: 350, // Adjust the size as needed
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF163352),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/campdashboard');
                            },
                            icon: Icon(Icons.health_and_safety),
                            color: Colors.white,
                            iconSize: 40,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Camp',
                          style: TextStyle(
                            color: Color(0xFF163352),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF163352),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              if (await isConnectedToInternet()) {
                                Navigator.pushNamed(context, '/login');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No internet connection'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.local_hospital),
                            color: Colors.white,
                            iconSize: 40,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Hospital',
                          style: TextStyle(
                            color: Color(0xFF163352),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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