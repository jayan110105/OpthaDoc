import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  final String patientId;

  const Appointment({required this.patientId, super.key});

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _scheduleAppointment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('appointments').add({
          'patientId': widget.patientId,
          'date': _dateController.text,
          'time': _timeController.text,
          'description': _descriptionController.text,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment scheduled successfully')),
        );

        Navigator.pop(context);
        Navigator.pop(context);
      } catch (e) {
        print('Error scheduling appointment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scheduling appointment')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Accent color
              onPrimary: Colors.white, // Text color on accent color
              onSurface: Colors.black, // Text color on surface
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Accent color
              onPrimary: Colors.white, // Text color on accent color
              onSurface: Colors.black, // Text color on surface
              secondary: Colors.black,
              onSecondary: Colors.white,// Background color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                cursorColor: Colors.black,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                cursorColor: Colors.black,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectTime(context);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.black,))
                  : SizedBox(
                height: 60,
                width: double.infinity,
                child: _buildTextButton(
                  icon: Icons.schedule,
                  label: "Schedule Appointment",
                  onPressed: _scheduleAppointment,
                ),
              ),
            ],
          ),
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