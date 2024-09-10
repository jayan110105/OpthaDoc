import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:optha_doc/ui/screens/EditRecords.dart';
import 'package:optha_doc/ui/screens/User2.dart';
import 'package:optha_doc/ui/screens/ViewRecords.dart';
import 'package:optha_doc/ui/screens/appointment.dart';

class SearchPatient extends StatefulWidget {

  final String routeName;

  const SearchPatient({required this.routeName, super.key});

  @override
  State<SearchPatient> createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {

  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> searchPatient() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('patients')
          .where('aadhaarNumber', isEqualTo: _searchController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Patient found, navigate to optometry details screen
        if(widget.routeName == 'eyecheckup'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => User2(patientId: querySnapshot.docs.first.id)),
          );
        } else if(widget.routeName == 'viewrecords'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Viewrecords(docID: querySnapshot.docs.first.id)),
          );
        }else if(widget.routeName == 'editrecords') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                EditRecords(docID: querySnapshot.docs.first.id)),
          );
        }else if(widget.routeName == 'appointment') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Appointment(patientId: querySnapshot.docs.first.id)),
          );
        }else
        {
        }
      } else {
        // Patient not found, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for patient: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
              TextField(
              cursorColor: Colors.black,
              controller: _searchController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                labelText: 'Enter Aadhaar Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator(color: Colors.black,)
                : SizedBox(
              width: double.infinity,
              child: _buildTextButton(
                icon: Icons.search,
                label: "Search",
                onPressed: searchPatient,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

}
