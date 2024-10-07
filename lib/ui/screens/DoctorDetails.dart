import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorDetailsForm extends StatefulWidget {
  @override
  _DoctorDetailsFormState createState() => _DoctorDetailsFormState();
}

class _DoctorDetailsFormState extends State<DoctorDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  TextEditingController maxAppointmentsPerDayController = TextEditingController();
  TextEditingController slotDurationController = TextEditingController();

  Map<String, TimeOfDay> workingHoursStart = {};
  Map<String, TimeOfDay> workingHoursEnd = {};

  @override
  void initState() {
    super.initState();

    // Initialize working hours for each weekday
    List<String> weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    for (var day in weekdays) {
      workingHoursStart[day] = TimeOfDay(hour: 9, minute: 0);
      workingHoursEnd[day] = TimeOfDay(hour: 17, minute: 0);
    }
  }

  // Function to pick a time
  Future<void> _selectTime(BuildContext context, String day, bool isStart) async {
    TimeOfDay initialTime = isStart ? workingHoursStart[day]! : workingHoursEnd[day]!;
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFF163352), // Accent color
                onPrimary: Color(0xFFE9E6DB), // Text color on accent color
                onSurface: Color(0xFF163352), // Text color on surface
                secondary: Color(0xFF163352),
                onSecondary: Color(0xFFE9E6DB),// Background color
              ),
              dialogBackgroundColor: Color(0xFFE9E6DB),
            ),
            child: child!,
          );
        },
    );
    if (picked != null && picked != initialTime) {
      setState(() {
        if (isStart) {
          workingHoursStart[day] = picked;
        } else {
          workingHoursEnd[day] = picked;
        }
      });
    }
  }

  // Function to validate and save form data
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Save form data to variables or send to a database
      Map<String, dynamic> doctorData = {
        "maxAppointmentsPerDay": int.parse(maxAppointmentsPerDayController.text),
        "slotDuration": int.parse(slotDurationController.text),
        "workingHours": {
          for (var day in workingHoursStart.keys)
            day: {
              "start": workingHoursStart[day]!.format(context),
              "end": workingHoursEnd[day]!.format(context),
            }
        },
      };

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          doctorData["doctorId"] = user.uid; // Add doctorId to doctorData
          await FirebaseFirestore.instance.collection('doctors').add(doctorData);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Doctor details saved successfully!')));
          Navigator.pushNamed(context, '/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user logged in')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving doctor details: $e')));
      }
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
              "Doctor Details",
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
          // padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Color(0xFFE9E6DB),
              elevation: 10,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Max Appointments per Day
                      TextFormField(
                        cursorColor: Color(0xFF163352),
                        controller: maxAppointmentsPerDayController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Color(0xFF163352),
                          ),
                          labelText: 'Max Appointments per Day',
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
                        // InputDecoration(labelText: ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter max appointments per day';
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Slot Duration
                      TextFormField(
                        cursorColor: Color(0xFF163352),
                        controller: slotDurationController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Color(0xFF163352),
                          ),
                          labelText: 'Slot Duration (minutes)',
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
                        // InputDecoration(labelText: 'Slot Duration (minutes)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter slot duration';
                          return null;
                        },
                      ),

                      // Working Hours
                      SizedBox(height: 20),
                      Text('Working Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...workingHoursStart.keys.map((day) {
                        return Row(
                          children: [
                            Text('$day: '),
                            Container(
                              child: TextButton(
                                onPressed: () => _selectTime(context, day, true),
                                child: Text(
                                    'Start: ${workingHoursStart[day]!.format(context)}',
                                    style: TextStyle(color: Color(0xFF163352)),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _selectTime(context, day, false),
                              child: Text(
                                  'End: ${workingHoursEnd[day]!.format(context)}',
                                  style: TextStyle(color: Color(0xFF163352)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF163352), // Set the background color
                            ),
                            child: Text('Save Doctor Details', style: TextStyle(color: Colors.white),),
                          ),
                        ],
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
}
