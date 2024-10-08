import 'package:flutter/material.dart';
import 'package:optha_doc/ui/screens/FindBestDoctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  final String patientId;

  ScheduleAppointmentScreen({required this.patientId});

  @override
  _ScheduleAppointmentScreenState createState() => _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  List<Map<String, DateTime>> availableSlots = [];
  DateTime selectedDate = DateTime.now(); // Default to current date
  String? selectedDoctorId;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();

  // Function to load available slots
  String getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  Future<void> _loadAvailableSlots() async {
    // Find the best suited doctor based on the patient
    String doctorId = await findBestDoctor(widget.patientId, selectedDate);
    setState(() {
      selectedDoctorId = doctorId;
    });

    // Fetch the doctor's availability details
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();

    print(doctorDoc['doctorId']);

    DocumentSnapshot docName = await FirebaseFirestore.instance.collection('users').doc(doctorDoc['doctorId']).get();
    String doctorName = docName['username'];
    _doctorController.text = doctorName;

    String dayName = getDayName(selectedDate.weekday);
    Map<String, dynamic> workingHours = doctorDoc['workingHours'][dayName];


    // Fetch the booked slots for the selected doctor on the selected date
    QuerySnapshot bookedSlotsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: selectedDate.toIso8601String().split('T')[0])
        .get();

    List<Map<String, DateTime>> bookedSlots = bookedSlotsSnapshot.docs.map((doc) {
      DateTime start = (doc['start'] as Timestamp).toDate();
      DateTime end = (doc['end'] as Timestamp).toDate();
      return {'start': start, 'end': end};
    }).toList();

    // Generate available slots based on working hours and booked slots
    String startTime = workingHours['start'];
    List<String> startParts = startTime.split(':');
    int startHour = int.parse(startParts[0]);
    int startMinute = int.parse(startParts[1].split(' ')[0]);
    String startPeriod = startParts[1].split(' ')[1];

    if (startPeriod == 'PM' && startHour != 12) {
      startHour += 12;
    }

    DateTime start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, startHour, startMinute);

    String endTime = workingHours['end'];
    List<String> endParts = endTime.split(':');
    int endHour = int.parse(endParts[0]);
    int endMinute = int.parse(endParts[1].split(' ')[0]);
    String endPeriod = endParts[1].split(' ')[1];

    if (endPeriod == 'PM' && endHour != 12) {
      endHour += 12;
    }

    DateTime end = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, endHour, endMinute);

    List<Map<String, DateTime>> slots = [];
    while (start.isBefore(end)) {
      DateTime slotEnd = start.add(Duration(minutes: doctorDoc['slotDuration']));
      if (slotEnd.isAfter(end)) break;

      bool isBooked = bookedSlots.any((slot) => slot['start']!.isBefore(slotEnd) && slot['end']!.isAfter(start));
      if (!isBooked) {
        slots.add({'start': start, 'end': slotEnd});
      }
      start = slotEnd;
    }

    setState(() {
      availableSlots = slots;
    });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
    _loadAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E6DB),
      appBar: AppBar(
          backgroundColor: Color(0xFFE9E6DB),
          title: Center(
            child: Text(
              "Schedule Appointment",
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
                    color: Color(0xFFE9E6DB)
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              color: Color(0xFFE9E6DB),
              child: Row(
                children: [
                  Icon(
                      Icons.calendar_today,
                    color: Color(0xFF163352),
                    size: 35,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      cursorColor: Color(0xFF163352),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Color(0xFF163352)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFF163352)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFF163352)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
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
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                            _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                          });
                          _loadAvailableSlots();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              color: Color(0xFFE9E6DB),
              child: Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: Color(0xFF163352),
                    size: 35,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _doctorController,
                      cursorColor: Color(0xFF163352),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Doctor',
                        labelStyle: TextStyle(color: Color(0xFF163352)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFF163352)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFF163352)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display available slots
            SizedBox(height: 20),
            Expanded(
              child: availableSlots.isEmpty
                  ? Center(child: Text('No available slots'))
                  : ListView.builder(
                itemCount: availableSlots.length,
                itemBuilder: (context, index) {
                  DateTime start = availableSlots[index]['start']!;
                  DateTime end = availableSlots[index]['end']!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Adds space below each tile
                    child: buildAppointmentTile(start, end, context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildAppointmentTile(DateTime start, DateTime end, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(
        Icons.access_time,
        color: Color(0xFF163352),
      ),
      title: Text(
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF163352),
        ),
      ),
      subtitle: Text(
        'Tap to book this slot',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF163352),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Color(0xFF163352),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Color(0xFFBBC2B4).withOpacity(0.5),
      onTap: () async {
        bool success = await _bookAppointment(start, end);
        if (success) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Color(0xFFE9E6DB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Appointment Booked',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163352),
                ),
              ),
              content: Text(
                'Your appointment has been successfully booked from ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} to ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}.',
                style: TextStyle(
                  color: Color(0xFF163352),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF163352),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<bool> _bookAppointment(DateTime start, DateTime end) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the appointment
      DocumentReference appointmentRef = FirebaseFirestore.instance.collection(
          'appointments').doc();
      batch.set(appointmentRef, {
        'patientId': widget.patientId,
        'doctorId': selectedDoctorId,
        'start': start,
        'end': end,
        'date': selectedDate.toIso8601String().split('T')[0],
      });

      // Update the patient's assigned doctor
      DocumentReference patientRef = FirebaseFirestore.instance.collection(
          'patients').doc(widget.patientId);
      batch.update(patientRef, {
        'assignedDoctor': selectedDoctorId,
      });

      // Commit the batch
      await batch.commit();
      return true;
    } catch (e) {
      print('Error booking appointment: $e');
      return false;
    }
  }
}
