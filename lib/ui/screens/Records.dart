import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optha_doc/ui/screens/ViewRecords.dart';
import 'package:optha_doc/ui/screens/EditRecords.dart';

class Records extends StatelessWidget {
  final String patientId;
  final String routeName;


  const Records({required this.routeName, required this.patientId, super.key});

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('d MMMM, yyyy').format(dateTime);
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<List<Map<String, dynamic>>> fetchOptometryDetails() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('optometryDetails')
          .where('patientId', isEqualTo: patientId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['docID'] = doc.id; // Add document ID to the data map
        return data;
      }).toList();
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
        MaterialPageRoute(builder: (context) => Viewrecords(docID: docID)),
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
          backgroundColor: Color(0xFFE9E6DB),
          title: Center(
            child: Text(
              "Optometry Records",
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      child: Container(
                          child: _buildCard('Created At ${formatDate(record['createdAt'])}', formatTimestamp(record['createdAt']))),
                    );
                  },
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
      elevation: 4.0,
      color: Color(0xFFE9E6DB),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF163352),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF163352),
          ),
        ),
      ),
    );
  }
}