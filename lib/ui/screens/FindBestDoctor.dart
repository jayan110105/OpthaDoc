import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> findBestDoctor(String patientId, DateTime appointmentDate) async {
  final firestore = FirebaseFirestore.instance;

  // Check if patient is returning
  DocumentSnapshot patientDoc = await firestore.collection('patients').doc(patientId).get();

  String? assignedDoctorId;
  bool isReturning = patientDoc.exists && patientDoc['assignedDoctor'] != '';

  if (isReturning) {
    // Get the assigned doctor
    assignedDoctorId = patientDoc['assignedDoctor'];

    // Check if the assigned doctor has free slots
    bool hasFreeSlots = await _hasFreeSlots(assignedDoctorId!, appointmentDate);
    if (hasFreeSlots) {
      return assignedDoctorId;
    }
  }

  // If new patient or assigned doctor has no free slots, find the doctor with least appointments
  String bestDoctorId = await _findDoctorWithLeastAppointments(appointmentDate);

  return bestDoctorId;
}

// Helper function to check if a doctor has free slots
Future<bool> _hasFreeSlots(String doctorId, DateTime date) async {
  final firestore = FirebaseFirestore.instance;

  // Get the count of appointments for the doctor on the given date
  QuerySnapshot appointments = await firestore
      .collection('appointments')
      .where('doctorId', isEqualTo: doctorId)
      .where('date', isEqualTo: date.toIso8601String().split('T')[0])
      .get();

  // Get the doctor's profile to check max appointments per day
  DocumentSnapshot doctorDoc = await firestore.collection('doctors').doc(doctorId).get();
  int maxAppointments = doctorDoc['maxAppointmentsPerDay'];

  return appointments.docs.length < maxAppointments;
}

// Helper function to find doctor with least appointments
Future<String> _findDoctorWithLeastAppointments(DateTime date) async {
  final firestore = FirebaseFirestore.instance;

  // Get all doctors
  QuerySnapshot doctors = await firestore.collection('doctors').get();

  String bestDoctorId = '';
  int minAppointments = 10000;

  // Iterate over each doctor to find the one with the least appointments
  for (var doc in doctors.docs) {
    String doctorId = doc.id;

    // Get the count of appointments for this doctor on the given date
    QuerySnapshot appointments = await firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: date.toIso8601String().split('T')[0])
        .get();

    int appointmentCount = appointments.docs.length;

    // Find the doctor with the fewest appointments
    if (appointmentCount < minAppointments) {
      minAppointments = appointmentCount;
      bestDoctorId = doctorId;
    }
  }
  print('Best Doctor: $bestDoctorId');
  return bestDoctorId;
}
