import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:optha_doc/services/Hive/optometry_details.dart';
import 'package:optha_doc/services/Hive/patients.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class campViewRecords extends StatelessWidget {
  final int docID;

  const campViewRecords({required this.docID, super.key});

  String formatDate(DateTime dateTime) {
    return DateFormat('d MMMM, yyyy').format(dateTime);
  }

  Future<Map<String, dynamic>?> fetchEyeCheckupDetails() async {
    try {
      var box = Hive.box<OptometryDetails>('optometryDetails');
      OptometryDetails? optometryDetails = box.get(docID);

      if (optometryDetails == null) {
        return null;
      }

      // Extract patientId from optometry details
      String? patientId = optometryDetails.patientId;

      var patientBox = Hive.box<Patients>('patients');
      Patients? patientDetails = patientBox.values.firstWhere(
            (patient) => patient.aadhaarNumber == patientId,
        orElse: () => null as Patients,
      );


      if (patientDetails == null) {
        return null;
      }

      // Combine data from both collections
      Map<String, dynamic> combinedData = {
        ...optometryDetails.toMap(),
        ...patientDetails.toMap(),
      };


      return combinedData;
    } catch (e) {
      print('Error fetching eye checkup details: $e');
      return null;
    }
  }

  Future<void> _generatePDF(Map<String, dynamic> patientData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 10),
              pw.Text(
                "KASTURBA HOSPITAL",
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "MANIPAL",
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  "DEPARTMENT OF OPHTHALMOLOGY",
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  "PRESCRIPTION FOR GLASSES",
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(),
                  pw.Text("Date: ${formatDate(patientData['createdAt'])}"),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(),
                  pw.Text("Hospital No.: ${patientData['patientId']}"),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text("Name: ${patientData['name'] ?? 'John Doe'}"),
              pw.SizedBox(height: 10),
              // Table for Eye Prescription
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(1.5),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1.5),
                  5: pw.FlexColumnWidth(1),
                  6: pw.FlexColumnWidth(1),
                  7: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('RIGHT Eye')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('Sphere')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('Cyl')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('Axis')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('LEFT Eye')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('Sphere')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('Cyl')),
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Center(child: pw.Text('Axis')),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('D.V.')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedDVSpL'] ?? ''}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedCylL'] ?? ''}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedAxisL']+"°" ?? ''}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('D.V.')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedDVSpR'] ?? ''}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedCylR'] ?? ''}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedAxisR']+"°" ?? ''}')),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('N.V.')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedNVSpL']=="nullnull" ? '' : patientData['CorrectedNVSpL']}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('N.V.')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['CorrectedNVSpR']=="nullnull" ? '': patientData['CorrectedNVSpR']}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('I.P.D.')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('${patientData['IPD']+" mm" ?? ''}')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('')),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              // Bifocal, Color, and Remarks sections
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Bifocal: "),
                  pw.Text("${patientData['Bifocal']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Colour: "),
                  pw.Text("${patientData['Color']}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Remarks: "),
                  pw.Text("${patientData['Remarks']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    // Preview the PDF using the Printing package
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
                                Expanded(child: _buildCard('Left', data['AxisL']!=null?data['AxisL']+"°" : 'N/A')),
                                SizedBox(width: 16),
                                Expanded(child: _buildCard('Right', data['AxisR']!=null?data['AxisL']+"°" : 'N/A')),
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
                                Expanded(child: _buildCard('Left', data['CorrectedAxisL'] == null ? 'N/A' : data['CorrectedAxisL']+"°")),
                                SizedBox(width: 16),
                                Expanded(child: _buildCard('Right', data['CorrectedAxisR'] == null ? 'N/A' : data['CorrectedAxisR']+"°")),
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
                        onPressed: () => _generatePDF(data),
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
                color: Color(0xFF163352),
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