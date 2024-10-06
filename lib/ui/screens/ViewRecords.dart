import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Viewrecords extends StatelessWidget {
  final String docID;

  const Viewrecords({required this.docID, super.key});

  Future<Map<String, dynamic>?> fetchEyeCheckupDetails() async {
    try {
      DocumentSnapshot optometrySnapshot = await FirebaseFirestore.instance
          .collection('optometryDetails')
          .doc(docID)
          .get();

      // Fetch patient details
      if (!optometrySnapshot.exists) {
        return null;
      }

      // Extract patientId from optometry details
      String patientId = optometrySnapshot['patientId'];

      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get();

      if (optometrySnapshot.exists && patientSnapshot.exists) {
        // Combine data from both collections
        Map<String, dynamic> combinedData = {
          ...optometrySnapshot.data() as Map<String, dynamic>,
          ...patientSnapshot.data() as Map<String, dynamic>,
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
          backgroundColor: Color(0xFFE9E6DB),
          title: Center(
            child: Text(
              "View Records",
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
      body: Container(
        color: Color(0xFFE9E6DB),
        child: FutureBuilder<Map<String, dynamic>?>(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                            ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(data['imageUrl']),
                          backgroundColor: Colors.transparent,
                        )
                            : CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFFBBC2B4),
                          child: Icon(
                            data['gender']=="Male" ? Icons.face: Icons.face_3,
                            color: Color(0xFF163352),
                            size: 80,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name']??'John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                            Text('Age : ${data['age'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                            Text('ID: ${data['patientId']}', style: TextStyle( fontSize: 18)),
                          ],
                        )
                      ],
                    ),
                    //_buildCard('Patient ID', patientId),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9E6DB),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          // color: Colors.grey[200],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility_off,
                                  size: 30.0,
                                  color: Color(0xFF163352),
                                ),
                                SizedBox(width: 20,),
                                Text('Without Aid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            ),
                            SizedBox(height: 20),
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
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9E6DB),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          // color: Colors.grey[200],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: 30.0,
                                  color: Color(0xFF163352),
                                ),
                                SizedBox(width: 20,),
                                Text('With Aid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Brief Complaint', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                            _buildTitleLessCard(data['BriefComplaint'] ?? 'N/A'),
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
                            Text('I.P.D.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                            _buildTitleLessCard(data['IPD']+" mm" ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9E6DB),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          // color: Colors.grey[200],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 30.0,
                                  color: Color(0xFF163352),
                                ),
                                SizedBox(width: 20,),
                                Text('With Correction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            ),
                            SizedBox(height: 20),
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
                            Text('I.P.D.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                            _buildTitleLessCard(data['CorrectedIPD']+" mm" ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9E6DB),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          // color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            _buildIconCard(Icon(Icons.blur_on, color: Color(0xFF163352),),'Bifocal', data['Bifocal'] ?? 'N/A'),
                            SizedBox(height: 2),
                            _buildIconCard(Icon(Icons.invert_colors, color: Color(0xFF163352),),'Color', data['Color'] ?? 'N/A'),
                            SizedBox(height: 2),
                            _buildIconCard(Icon(Icons.comment, color: Color(0xFF163352),),'Remarks', data['Remarks'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF163352),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(10),
                          minimumSize: Size(88, 60),
                        ),
                        onPressed: (){},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Share Report",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(width: 20),
                              Icon(Icons.share, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      color: Color(0xFFBBC2B4),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Increase border radius
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              title+" : ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                  color: Color(0xFF163352)
              ),
            ),
            SizedBox(width: 10),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF163352)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleLessCard(String title) {
    return Card(
      color: Color(0xFFBBC2B4),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Increase border radius
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF163352)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(Icon icon, String title, String subtitle) {
    return Card(
      color: Color(0xFFBBC2B4),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Increase border radius
      ),
      child: ListTile(
        title: Row(
          children: [
            icon,
            SizedBox(width: 10,),
            Text(
              title+" : ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF163352)
              ),
            ),
            SizedBox(width: 10),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF163352)
              ),
            ),
          ],
        ),
      ),
    );
  }
}