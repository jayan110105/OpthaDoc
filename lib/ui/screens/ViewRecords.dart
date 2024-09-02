import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Viewrecords extends StatelessWidget {
  final String patientId;

  const Viewrecords({required this.patientId, super.key});

  Future<Map<String, dynamic>?> fetchEyeCheckupDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('optometryDetails')
          .where('patientId', isEqualTo: patientId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return doc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching eye checkup details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Records'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchEyeCheckupDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No records found.'));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildCard('Patient ID', patientId),
                  Row(
                    children: [
                      Expanded(child: _buildCard('DVR', data['DVR'] ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('DVL', data['DVL'] ?? 'N/A')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildCard('DVR2', data['DVR2'] ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('DVL2', data['DVL2'] ?? 'N/A')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildCard('DVSpR', data['DVSpR'] ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('DVSpL', data['DVSpL'] ?? 'N/A')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildCard('NVR', data['NVR'] ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('NVL', data['NVL'] ?? 'N/A')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildCard('NVSpR', data['NVSpR'] ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('NVSpL', data['NVSpL'] ?? 'N/A')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildCard('CylR', data['CylR'] ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('CylL', data['CylL'] ?? 'N/A')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildCard('AxisR', data['AxisR']+"°" ?? 'N/A')),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard('AxisL', data['AxisL']+"°" ?? 'N/A')),
                    ],
                  ),
                  _buildCard('IPD', data['IPD'] ?? 'N/A'),
                  _buildCard('Bifocal', data['Bifocal'] ?? 'N/A'),
                  _buildCard('Color', data['Color'] ?? 'N/A'),
                  _buildCard('Remarks', data['Remarks'] ?? 'N/A'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}