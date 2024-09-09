import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User2 extends StatefulWidget {
  final String patientId;

  const User2({required this.patientId, super.key});

  @override
  State<User2> createState() => _User2State();
}

class _User2State extends State<User2> {

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
  String? DVR;
  String? DVL;
  String? selectedDVR;
  String? selectedDVL;
  String? selectedNVR;
  String? selectedNVL;

  bool isNVR = false;

  double? CorrectedDVSpR;
  double? CorrectedDVSpL;
  double? CorrectedNVSpR;
  double? CorrectedNVSpL;
  double? CorrectedCylR;
  double? CorrectedCylL;
  String? CorrectedSignDVSpR;
  String? CorrectedSignDVSpL;
  String? CorrectedSignNVSpR;
  String? CorrectedSignNVSpL;
  String? CorrectedSignCylR;
  String? CorrectedSignCylL;
  String? CorrectedDVR;
  String? CorrectedDVL;
  String? CorrectedNVR;
  String? CorrectedNVL;

  bool CorrectedisNVR = false;

  final TextEditingController _axisRController = TextEditingController();
  final TextEditingController _axisLController = TextEditingController();
  final TextEditingController _ipdController = TextEditingController();

  final TextEditingController _CorrectedAxisRController = TextEditingController();
  final TextEditingController _CorrectedAxisLController = TextEditingController();
  final TextEditingController _CorrectedIpdController = TextEditingController();
  final TextEditingController _BriefComplaintController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> saveOptometryDetails() async {

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('optometryDetails').add({
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
        'DVR': DVR,
        'DVL': DVL,
        'AidedDVR': selectedDVR,
        'AidedDVL': selectedDVL,
        'NVR': selectedNVR,
        'NVL': selectedNVL,
        'AxisR': _axisRController.text,
        'AxisL': _axisLController.text,
        'IPD': _ipdController.text,
        'BriefComplaint': _BriefComplaintController.text,
        'CorrectedDVSpR': '$CorrectedSignDVSpR$CorrectedDVSpR',
        'CorrectedDVSpL': '$CorrectedSignDVSpL$CorrectedDVSpL',
        'CorrectedNVSpR': '$CorrectedSignNVSpR$CorrectedNVSpR',
        'CorrectedNVSpL': '$CorrectedSignNVSpL$CorrectedNVSpL',
        'CorrectedCylR': '$CorrectedSignCylR$CorrectedCylR',
        'CorrectedCylL': '$CorrectedSignCylL$CorrectedCylL',
        'CorrectedDVR': CorrectedDVR,
        'CorrectedDVL': CorrectedDVL,
        'CorrectedNVR': CorrectedNVR,
        'CorrectedNVL': CorrectedNVL,
        'CorrectedAxisR': _CorrectedAxisRController.text,
        'CorrectedAxisL': _CorrectedAxisLController.text,
        'CorrectedIPD': _CorrectedIpdController.text,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Optometry details saved successfully!')),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eye Checkup"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              ]
            ),
            Divider(),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildEyeLabel("Without Aid"),
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
                _buildDistanceVisionDropdown(DVR, "R", (newValue) {
                  setState(() {
                    DVR = newValue;
                  });
                }),
                _buildDistanceVisionDropdown(DVL, "L", (newValue) {
                  setState(() {
                    DVL = newValue;
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
                _buildEyeLabel("With Aid"),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                _buildTextLabel("Brief Complaint"),
                SizedBox(width: 45,),
                Container(
                  width: 215,
                  child: TextField(
                    controller: _BriefComplaintController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Enter Complaint',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Enter IPD value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Near Vision Required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Checkbox(
                  activeColor: Colors.black,
                  value: isNVR,
                  onChanged: (bool? value) {
                    setState(() {
                      isNVR = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            isNVR ? GridView.count(
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
            ): SizedBox.shrink(),
            isNVR ? SizedBox(height: 16,): SizedBox.shrink(),
            isNVR ? GridView.count(
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
            ): SizedBox.shrink(),
            isNVR ? SizedBox(height: 20,): SizedBox.shrink(),
            Divider(),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildEyeLabel("With Correction"),
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
                  _buildDistanceVisionDropdown(CorrectedDVR, "R", (newValue) {
                    setState(() {
                      CorrectedDVR = newValue;
                    });
                  }),
                  _buildDistanceVisionDropdown(CorrectedDVL, "L", (newValue) {
                    setState(() {
                      CorrectedDVL = newValue;
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
                  _buildSignDropdown(CorrectedSignDVSpR, (newValue) {
                    setState(() {
                      CorrectedSignDVSpR = newValue;
                    });
                  }),
                  _buildDropdown(8, "Sp.", CorrectedDVSpR, (newValue) {
                    setState(() {
                      CorrectedDVSpR = newValue;
                    });
                  }),
                  _buildSignDropdown(CorrectedSignDVSpL, (newValue) {
                    setState(() {
                      CorrectedSignDVSpL = newValue;
                    });
                  }),
                  _buildDropdown(8, "Sp.", CorrectedDVSpL, (newValue) {
                    setState(() {
                      CorrectedDVSpL = newValue;
                    });
                  }),
                  _buildSignDropdown(CorrectedSignCylR, (newValue) {
                    setState(() {
                      CorrectedSignCylR = newValue;
                    });
                  }),
                  _buildDropdown(6, "Cyl.", CorrectedCylR, (newValue) {
                    setState(() {
                      CorrectedCylR = newValue;
                    });
                  }),
                  _buildSignDropdown(CorrectedSignCylL, (newValue) {
                    setState(() {
                      CorrectedSignCylL = newValue;
                    });
                  }),
                  _buildDropdown(6, "Cyl.", CorrectedCylL, (newValue) {
                    setState(() {
                      CorrectedCylL = newValue;
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
                  _buildTextField('R', _CorrectedAxisRController),
                  _buildTextField('L', _CorrectedAxisLController),
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
                    controller: _CorrectedIpdController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Enter IPD value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Near Vision Required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Checkbox(
                  activeColor: Colors.black,
                  value: CorrectedisNVR,
                  onChanged: (bool? value) {
                    setState(() {
                      CorrectedisNVR = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            CorrectedisNVR ? GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildTextLabel('Near Vision'),
                  _buildNearVisionDropdown(CorrectedNVR, "R", (newValue) {
                    setState(() {
                      CorrectedNVR = newValue;
                    });
                  }),
                  _buildNearVisionDropdown(CorrectedNVL, "L", (newValue) {
                    setState(() {
                      CorrectedNVL = newValue;
                    });
                  }),
                ]
            ): SizedBox.shrink(),
            CorrectedisNVR ? SizedBox(height: 16,): SizedBox.shrink(),
            CorrectedisNVR ? GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildSignDropdown(CorrectedSignNVSpR, (newValue) {
                    setState(() {
                      CorrectedSignNVSpR = newValue;
                    });
                  }),
                  _buildDropdown(8, "Sp.", CorrectedNVSpR, (newValue) {
                    setState(() {
                      CorrectedNVSpR = newValue;
                    });
                  }),
                  _buildSignDropdown(CorrectedSignNVSpL, (newValue) {
                    setState(() {
                      CorrectedSignNVSpL = newValue;
                    });
                  }),
                  _buildDropdown(8, "Sp.", CorrectedNVSpL, (newValue) {
                    setState(() {
                      CorrectedNVSpL = newValue;
                    });
                  }),
                ]
            ): SizedBox.shrink(),
            CorrectedisNVR ? SizedBox(height: 20,): SizedBox.shrink(),
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
                      //backgroundColor: Colors.white,
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
                    )
                    : TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: saveOptometryDetails,
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

  _validateAxis(String value) {
    if (value.isEmpty) {
      return false;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return false;
    }
    return n >= 0 && n <= 180;
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
          width: 80, // Use SizedBox instead of Container to enforce fixed width
          child: TextField(
            cursorColor: Colors.black,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _validateAxis(value);
              });
            },
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