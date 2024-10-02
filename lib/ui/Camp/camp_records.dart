import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optha_doc/ui/screens/ViewRecords.dart';
import 'package:optha_doc/ui/screens/EditRecords.dart';
import 'package:optha_doc/ui/Camp/camp_viewRecords.dart';
import 'package:hive/hive.dart';
import 'package:optha_doc/services/Hive/optometry_details.dart';
import 'package:optha_doc/services/Hive/patients.dart';

class CampRecords extends StatelessWidget {
  final String patientId;
  final String routeName;


  const CampRecords({required this.routeName, required this.patientId, super.key});

  String formatDate(DateTime dateTime) {
    return DateFormat('d MMMM, yyyy').format(dateTime);
  }

  String formatTimestamp(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<List<Map<String, dynamic>>> fetchOptometryDetails() async {
    try {
      var optometryBox = Hive.box<OptometryDetails>('optometryDetails');
      var patientBox = Hive.box<Patients>('patients');

      List<Map<String, dynamic>> records = [];

      for (var key in optometryBox.keys) {
        var optometryDetails = optometryBox.get(key);
        if (optometryDetails != null && optometryDetails.patientId == patientId) {
          var patientDetails = patientBox.values.firstWhere(
                (patient) => patient.aadhaarNumber == patientId,
            orElse: () => null as Patients,
          );
          if (patientDetails != null) {
            Map<String, dynamic> combinedData = {
              'docID': key,
              ...optometryDetails.toMap(),
              ...patientDetails.toMap(),
            };
            records.add(combinedData);
          }
        }
      }

      return records;
    } catch (e) {
      print('Error fetching details: $e');
      return [];
    }
  }

  void onCardTap(BuildContext context, Map<String, dynamic> record) {
    final docID = record['docID'];
    if (routeName == 'ViewRecords') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => campViewRecords(docID: docID)),
      );
    } else if (routeName == 'EditRecords') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditRecords(docID: docID)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optometry Records'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOptometryDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found.'));
          } else {
            final records = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return GestureDetector(
                    onTap: () => onCardTap(context, record),
                    child: _buildCard('Created At ${formatDate(record['createdAt'])}', formatTimestamp(record['createdAt'])),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      color: Colors.black87,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}