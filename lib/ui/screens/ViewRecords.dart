import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Viewrecords extends StatelessWidget {
  final String patientId;

  const Viewrecords({required this.patientId, super.key});

  Future<Map<String, dynamic>?> fetchEyeCheckupDetails() async {
    try {
      QuerySnapshot optometrySnapshot = await FirebaseFirestore.instance
          .collection('optometryDetails')
          .where('patientId', isEqualTo: patientId)
          .get();

      // Fetch patient details
      QuerySnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('aadhaarNumber', isEqualTo: patientId)
          .get();

      if (optometrySnapshot.docs.isNotEmpty && patientSnapshot.docs.isNotEmpty) {
        DocumentSnapshot optometryDoc = optometrySnapshot.docs.first;
        DocumentSnapshot patientDoc = patientSnapshot.docs.first;

        // Combine data from both collections
        Map<String, dynamic> combinedData = {
          ...optometryDoc.data() as Map<String, dynamic>,
          ...patientDoc.data() as Map<String, dynamic>,
        };

        return combinedData;
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
            return Center(child: CircularProgressIndicator(color: Colors.black,));
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
                  Row(
                    children: [
                      data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                          ? CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(data['imageUrl']),
                        backgroundColor: Colors.transparent,
                      )
                          : CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name']??'John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          Text('Age : ${data['age'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                          Text('ID: $patientId', style: TextStyle( fontSize: 18)),
                        ],
                      )
                    ],
                  ),
                  //_buildCard('Patient ID', patientId),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Without Aid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Distance Vision', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['DVL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['DVR'] ?? 'N/A')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('With Aid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(height: 16),
                        _buildCard('Brief Complaint', data['BriefComplaint'] ?? 'N/A'),
                        SizedBox(height: 16),
                        Text('Distance Vision', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['AidedDVL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['AidedDVR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('D.V. Sphere', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['DVSpL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['DVSpR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Near Vision', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['NVL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['NVR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('N.V. Sphere', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['NVSpL'] == 'nullnull' ? 'N/A': data['NVSpL'])),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['NVSpR'] == 'nullnull' ?'N/A': data['NVSpR'])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Cyl', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CylL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CylR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Axis', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['AxisL']+"°" ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['AxisR']+"°" ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildCard('I.P.D.', data['IPD'] ?? 'N/A'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('With Correction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Distance Vision', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CorrectedDVL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CorrectedDVR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('D.V. Sphere', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CorrectedDVSpL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CorrectedDVSpR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Near Vision', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CorrectedNVL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CorrectedNVR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('N.V. Sphere', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CorrectedNVSpL'] == 'nullnull' ? 'N/A': data['CorrectedNVSpL'])),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CorrectedNVSpR'] == 'nullnull' ?'N/A': data['CorrectedNVSpR'])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Cyl', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CorrectedCylL'] ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CorrectedCylR'] ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Axis', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                        Row(
                          children: [
                            Expanded(child: _buildCard('Left', data['CorrectedAxisL']+"°" ?? 'N/A')),
                            SizedBox(width: 16),
                            Expanded(child: _buildCard('Right', data['CorrectedAxisR']+"°" ?? 'N/A')),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildCard('I.P.D.', data['CorrectedIPD'] ?? 'N/A'),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        _buildCard('Bifocal', data['Bifocal'] ?? 'N/A'),
                        SizedBox(height: 2),
                        _buildCard('Color', data['Color'] ?? 'N/A'),
                        SizedBox(height: 2),
                        _buildCard('Remarks', data['Remarks'] ?? 'N/A'),
                      ],
                    ),
                  ),
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