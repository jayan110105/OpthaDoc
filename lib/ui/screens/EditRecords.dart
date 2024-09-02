import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditRecords extends StatefulWidget {
  final String patientId;

  const EditRecords({required this.patientId, super.key});

  @override
  _EditRecordsState createState() => _EditRecordsState();
}

class _EditRecordsState extends State<EditRecords> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  bool _isLoading = false;
  bool _isFetching = true;

  final TextEditingController _axisRController = TextEditingController();
  final TextEditingController _axisLController = TextEditingController();
  final TextEditingController _ipdController = TextEditingController();

  String? selectedBifocal;
  String? selectedColor;
  String? selectedRemarks;
  double? selectedDVSpR;
  double? selectedDVSpL;
  double? selectedNVSpR;
  double? selectedNVSpL;
  double? selectedCylR;
  double? selectedCylL;
  String? selectedSignDVSpR;
  String? selectedSignDVSpL;
  String? selectedSignNVSpR;
  String? selectedSignNVSpL;
  String? selectedSignCylR;
  String? selectedSignCylL;
  String? selectedDVR;
  String? selectedDVL;
  String? selectedDVR2;
  String? selectedDVL2;
  String? selectedNVR;
  String? selectedNVL;

  @override
  void initState() {
    super.initState();
    fetchEyeCheckupDetails();
  }

  Future<void> fetchEyeCheckupDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('optometryDetails')
          .where('patientId', isEqualTo: widget.patientId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          _axisRController.text = data['AxisR'] ?? '';
          _axisLController.text = data['AxisL'] ?? '';
          _ipdController.text = data['IPD'] ?? '';
          selectedBifocal = data['Bifocal'];
          selectedColor = data['Color'];
          selectedRemarks = data['Remarks'];
          selectedDVSpR = double.tryParse(data['DVSpR'].substring(1) ?? '');
          selectedDVSpL = double.tryParse(data['DVSpL'].substring(1) ?? '');
          selectedNVSpR = double.tryParse(data['NVSpR'].substring(1) ?? '');
          selectedNVSpL = double.tryParse(data['NVSpL'].substring(1) ?? '');
          selectedCylR = double.tryParse(data['CylR'].substring(1) ?? '');
          selectedCylL = double.tryParse(data['CylL'].substring(1) ?? '');
          selectedSignDVSpR = data['DVSpR'].substring(0, 1);
          selectedSignDVSpL = data['DVSpL'].substring(0, 1);
          selectedSignNVSpR = data['NVSpR'].substring(0, 1);
          selectedSignNVSpL = data['NVSpL'].substring(0, 1);
          selectedSignCylR = data['CylR'].substring(0, 1);
          selectedSignCylL = data['CylL'].substring(0, 1);
          selectedDVR = data['DVR'];
          selectedDVL = data['DVL'];
          selectedDVR2 = data['DVR2'];
          selectedDVL2 = data['DVL2'];
          selectedNVR = data['NVR'];
          selectedNVL = data['NVL'];
          _isFetching = false;
        });
      } else {
        setState(() {
          _isFetching = false;
        });
      }
    } catch (e) {
      print('Error fetching eye checkup details: $e');
      setState(() {
        _isFetching = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('optometryDetails')
            .where('patientId', isEqualTo: widget.patientId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference docRef = querySnapshot.docs.first.reference;
          await docRef.update({
            'patientId': widget.patientId,
            'Bifocal': selectedBifocal,
            'Color': selectedColor,
            'Remarks': selectedRemarks,
            'DVSpR': '$selectedSignDVSpR$selectedDVSpR',
            'DVSpL': '$selectedSignDVSpR$selectedDVSpL',
            'NVSpR': '$selectedSignNVSpR$selectedNVSpR',
            'NVSpL': '$selectedSignNVSpR$selectedNVSpL',
            'CylR': '$selectedSignCylR$selectedCylR',
            'CylL': '$selectedSignCylL$selectedCylL',
            'DVR': selectedDVR,
            'DVL': selectedDVL,
            'DVR2': selectedDVR2,
            'DVL2': selectedDVL2,
            'NVR': selectedNVR,
            'NVL': selectedNVL,
            'AxisR': _axisRController.text,
            'AxisL': _axisLController.text,
            'IPD': _ipdController.text,
            'createdAt': Timestamp.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Records updated successfully')),
          );
        }
      }catch (e) {
        print('Error updating records: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating records')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Records'),
      ),
      body: _isFetching
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(),
                  Center(child: _buildEyeLabel("RIGHT Eye")),
                  Center(child: _buildEyeLabel("LEFT Eye")),
                  _buildTextLabel('Distance Vision'),
                  _buildDistanceVisionDropdown(selectedDVR, "R", (newValue) {
                    setState(() {
                      selectedDVR = newValue;
                    });
                  }),
                  _buildDistanceVisionDropdown(selectedDVL, "L", (newValue) {
                    setState(() {
                      selectedDVL = newValue;
                    });
                  }),
                ],
              ),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildEyeLabel("D.V."),
                ],
              ),
              SizedBox(height: 20,),
              GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTextLabel('Distance Vision'),
                    _buildDistanceVisionDropdown(selectedDVR2, "R", (newValue) {
                      setState(() {
                        selectedDVR2 = newValue;
                      });
                    }),
                    _buildDistanceVisionDropdown(selectedDVL2, "L", (newValue) {
                      setState(() {
                        selectedDVL2 = newValue;
                      });
                    }),
                  ]
              ),
              SizedBox(height: 16,),
              GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildSignDropdown(selectedSignDVSpR, (newValue) {
                      setState(() {
                        selectedSignDVSpR = newValue;
                      });
                    }),
                    _buildDropdown(8, "Sp.", selectedDVSpR, (newValue) {
                      setState(() {
                        selectedDVSpR = newValue;
                      });
                    }),
                    _buildSignDropdown(selectedSignDVSpL, (newValue) {
                      setState(() {
                        selectedSignDVSpL = newValue;
                      });
                    }),
                    _buildDropdown(8, "Sp.", selectedDVSpL, (newValue) {
                      setState(() {
                        selectedDVSpL = newValue;
                      });
                    }),
                  ]
              ),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildEyeLabel("N.V."),
                ],
              ),
              SizedBox(height: 20,),
              GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTextLabel('Near Vision'),
                    _buildNearVisionDropdown(selectedNVR, "R", (newValue) {
                      setState(() {
                        selectedNVR = newValue;
                      });
                    }),
                    _buildNearVisionDropdown(selectedNVL, "L", (newValue) {
                      setState(() {
                        selectedNVL = newValue;
                      });
                    }),
                  ]
              ),
              SizedBox(height: 16,),
              GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildSignDropdown(selectedSignNVSpR, (newValue) {
                      setState(() {
                        selectedSignNVSpR = newValue;
                      });
                    }),
                    _buildDropdown(8, "Sp.", selectedNVSpR, (newValue) {
                      setState(() {
                        selectedNVSpR = newValue;
                      });
                    }),
                    _buildSignDropdown(selectedSignNVSpL, (newValue) {
                      setState(() {
                        selectedSignNVSpL = newValue;
                      });
                    }),
                    _buildDropdown(8, "Sp.", selectedNVSpL, (newValue) {
                      setState(() {
                        selectedNVSpL = newValue;
                      });
                    }),
                  ]
              ),
              SizedBox(height: 16,),
              Divider(),
              SizedBox(height: 20,),
              GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildSignDropdown(selectedSignCylR, (newValue) {
                      setState(() {
                        selectedSignCylR = newValue;
                      });
                    }),
                    _buildDropdown(6, "Cyl.", selectedCylR, (newValue) {
                      setState(() {
                        selectedCylR = newValue;
                      });
                    }),
                    _buildSignDropdown(selectedSignCylL, (newValue) {
                      setState(() {
                        selectedSignCylL = newValue;
                      });
                    }),
                    _buildDropdown(6, "Cyl.", selectedCylL, (newValue) {
                      setState(() {
                        selectedCylL = newValue;
                      });
                    }),
                  ]
              ),
              SizedBox(height: 16,),
              GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildTextLabel('Axis'),
                    _buildTextField('R', _axisRController),
                    _buildTextField('L', _axisLController),
                  ]
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  _buildTextLabel("IPD"),
                  SizedBox(width: 125,),
                  Container(
                    width: 215,
                    child: TextField(
                      controller: _ipdController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'IPD',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),
              _buildEyeLabel("Bifocal"),
              _buildCheckboxListTile('Kryptok', selectedBifocal, (value) {
                setState(() {
                  selectedBifocal = (value ?? false) ? 'Kryptok' : null;
                });
              }),
              _buildCheckboxListTile('Executive', selectedBifocal, (value) {
                setState(() {
                  selectedBifocal = (value ?? false) ? 'Executive' : null;
                });
              }),
              _buildCheckboxListTile('D-Segment', selectedBifocal, (value) {
                setState(() {
                  selectedBifocal = (value ?? false) ? 'D-Segment' : null;
                });
              }),
              _buildCheckboxListTile('Trifocal', selectedBifocal, (value) {
                setState(() {
                  selectedBifocal = (value ?? false) ? 'Trifocal' : null;
                });
              }),
              _buildCheckboxListTile('Omnivision', selectedBifocal, (value) {
                setState(() {
                  selectedBifocal = (value ?? false) ? 'Omnivision' : null;
                });
              }),
              _buildCheckboxListTile('Progressive', selectedBifocal, (value) {
                setState(() {
                  selectedBifocal = (value ?? false) ? 'Progressive' : null;
                });
              }),
              Divider(),
              SizedBox(height: 20,),
              _buildEyeLabel("Colour"),
              _buildCheckboxListTile('White', selectedColor, (value) {
                setState(() {
                  selectedColor = (value ?? false) ? 'White' : null;
                });
              }),
              _buildCheckboxListTile('SP2Alpha', selectedColor, (value) {
                setState(() {
                  selectedColor = (value ?? false) ? 'SP2Alpha' : null;
                });
              }),
              _buildCheckboxListTile('Photogrey', selectedColor, (value) {
                setState(() {
                  selectedColor = (value ?? false) ? 'Photogrey' : null;
                });
              }),
              _buildCheckboxListTile('Photosun', selectedColor, (value) {
                setState(() {
                  selectedColor = (value ?? false) ? 'Photosun' : null;
                });
              }),
              _buildCheckboxListTile('Photobrown', selectedColor, (value) {
                setState(() {
                  selectedColor = (value ?? false) ? 'Photobrown' : null;
                });
              }),
              Divider(),
              SizedBox(height: 20,),
              _buildEyeLabel("Remarks"),
              _buildCheckboxListTile('D.V. only', selectedRemarks, (value) {
                setState(() {
                  selectedRemarks = (value ?? false) ? 'D.V. only' : null;
                });
              }),
              _buildCheckboxListTile('N.V. Only', selectedRemarks, (value) {
                setState(() {
                  selectedRemarks = (value ?? false) ? 'N.V. Only' : null;
                });
              }),
              _buildCheckboxListTile('Constant Use', selectedRemarks, (value) {
                setState(() {
                  selectedRemarks = (value ?? false) ? 'Constant Use' : null;
                });
              }),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: (){},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                  ),
                  _isLoading
                      ? Container(
                      width: 200,
                      child: Center(child: CircularProgressIndicator(color: Colors.black))
                  ): TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: _saveChanges,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildCheckboxListTile(String title, String? groupValue, Function(bool?) onChanged) {
      return CheckboxListTile(
        activeColor: Colors.black,
        title: Text(title),
        value: groupValue == title,
        onChanged: onChanged,
      );
    }

    Widget _buildEyeLabel(String text) {
      return Text(
        text,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
        // textAlign: TextAlign.center,
      );
    }

    Widget _buildTextLabel(String text) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
        ],
      );
    }

    Widget _buildTextField(String hint, TextEditingController controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: 80, // Use SizedBox instead of Container to enforce fixed width
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hint,
            ),
          ),
        ),
      );
    }

    Widget _buildDropdown(int val, String hint, double? selectedValue, Function(double?) onChanged) {
      List<double> values = [];
      for (double i = 0; i <= val; i += 0.25) {
        values.add(i);
      }

      return DropdownButton<double>(
        value: selectedValue,
        hint: Text(hint),
        items: values.map((double value) {
          return DropdownMenuItem<double>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: onChanged,
      );
    }

    Widget _buildSignDropdown(String? selectedSign, Function(String?) onChanged) {
      List<String> signs = ["+", "-"];

      return DropdownButton<String>(
        value: selectedSign,
        hint: Text("+/-"),
        items: signs.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      );
    }

    Widget _buildDistanceVisionDropdown(String? value,String hint, Function(String?) onChanged) {
      List<String> visionValues = ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60", "3/60", "1/60"];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          items: visionValues.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      );
    }
    Widget _buildNearVisionDropdown(String? value,String hint, Function(String?) onChanged) {
      List<String> visionValues = ["N5", "N6", "N8", "N10", "N12", "N14", "N18", "N24", "N36", "N48", "N60"];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          items: visionValues.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      );
    }
  }