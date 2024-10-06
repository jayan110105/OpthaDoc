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

  final TextEditingController _axisRController = TextEditingController(text: "0");
  final TextEditingController _axisLController = TextEditingController(text: "0");
  final TextEditingController _ipdController = TextEditingController();

  final TextEditingController _CorrectedAxisRController = TextEditingController(text: "0");
  final TextEditingController _CorrectedAxisLController = TextEditingController(text: "0");
  final TextEditingController _CorrectedIpdController = TextEditingController();
  final TextEditingController _BriefComplaintController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  int _axisRValue = 0;
  int _axisLValue = 0;

  int _CorrectedaxisRValue = 0;
  int _CorrectedaxisLValue = 0;

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
          backgroundColor: Color(0xFFE9E6DB),
        title: Center(
          child: Text(
            "Eye Checkup",
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Color(0xFFE9E6DB),
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
                // Center(child: _buildEyeLabel("RIGHT Eye")),
                // Center(child: _buildEyeLabel("LEFT Eye")),
                Center(child: Image.asset('assets/images/eyeL.png')),
                Center(child: Image.asset('assets/images/eyeR.png')),
                ]
              ),
              // Divider(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.visibility_off,
                    size: 30.0,
                    color: Color(0xFF163352),
                  ),
                  SizedBox(width: 20,),
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
                  Icon(
                    Icons.visibility,
                    size: 30.0,
                    color: Color(0xFF163352),
                  ),
                  SizedBox(width: 20,),
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
                      cursorColor: Color(0xFF163352),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color(0xFF163352),
                        ),
                        hintText: 'Enter Complaint',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF163352),
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
                    // _buildTextField('R', _axisRController),
                    _buildAxisWheel("Axis R", _axisRValue, (newValue) {
                      setState(() {
                        _axisRValue = newValue;
                        _axisRController.text = newValue.toString();
                      });
                    }),
                    // _buildTextField('L', _axisLController),
                    _buildAxisWheel("Axis L", _axisLValue, (newValue) {
                      setState(() {
                        _axisLValue = newValue;
                        _axisLController.text = newValue.toString();
                      });
                    }),
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
                      cursorColor: Color(0xFF163352),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color(0xFF163352),
                        ),
                        labelText: 'Enter IPD value',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF163352),
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
                    activeColor: Color(0xFF163352),
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
                  Icon(
                    Icons.search,
                    size: 30.0,
                    color: Color(0xFF163352),
                  ),
                  SizedBox(width: 20,),
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
                    _buildTextLabel('Axis'),                    _buildAxisWheel("Axis R", _CorrectedaxisLValue, (newValue) {
                      setState(() {
                        _CorrectedaxisLValue = newValue;
                        _CorrectedAxisRController.text = newValue.toString();
                      });
                    }),
                    _buildAxisWheel("Axis L", _CorrectedaxisRValue, (newValue) {
                      setState(() {
                        _CorrectedaxisRValue = newValue;
                        _CorrectedAxisLController.text = newValue.toString();
                      });
                    }),
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
                      cursorColor: Color(0xFF163352),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color(0xFF163352),
                        ),
                        labelText: 'Enter IPD value',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF163352),
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
                    activeColor: Color(0xFF163352),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.blur_on,
                    size: 30.0,
                    color: Color(0xFF163352),
                  ),
                  SizedBox(width: 20,),
                  _buildEyeLabel("Bifocal"),
                SizedBox(width: 60,),
                SizedBox(
                  width: 200,
                  child: _buildBifocalDropdown(selectedBifocal, (newValue) {
                    setState(() {
                      selectedBifocal = newValue;
                    });
                  }),
                ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.invert_colors,
                    size: 30.0,
                    color: Color(0xFF163352),
                  ),
                  SizedBox(width: 20,),
                  _buildEyeLabel("Colour"),
                SizedBox(width: 60,),
                SizedBox(
                  width: 200,
                  child: _buildColorDropdown(selectedColor, (newValue) {
                    setState(() {
                      selectedColor = newValue;
                    });
                  }),
                ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.comment,
                    size: 30.0,
                    color: Color(0xFF163352),
                  ),
                  SizedBox(width: 20,),
                  _buildEyeLabel("Remarks"),
                SizedBox(width: 40,),
                SizedBox(
                  width: 200,
                  child: _buildRemarksDropdown(selectedRemarks, (newValue) {
                    setState(() {
                      selectedRemarks = newValue;
                    });
                  }),
                ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFBBC2B4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // side: BorderSide(color: Color(0xFF163352), width: 0.5),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: (){},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFF163352)),
                        ),
                      )
                  ),
                  _isLoading
                      ? Container(
                        width: 200,
                        child: Center(child: CircularProgressIndicator(color: Color(0xFF163352)))
                      )
                      : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF163352),
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
      ),
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
        dropdownColor: Color(0xFFE9E6DB)
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
        dropdownColor: Color(0xFFE9E6DB)
    );
  }

  Widget _buildDistanceVisionDropdown(String? value,String hint, Function(String?) onChanged) {
    List<String> visionValues = ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60", "3/60", "1/60"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
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
            dropdownColor: Color(0xFFE9E6DB)
        ),
      ),
    );
  }
  Widget _buildNearVisionDropdown(String? value,String hint, Function(String?) onChanged) {
    List<String> visionValues = ["N5", "N6", "N8", "N10", "N12", "N14", "N18", "N24", "N36", "N48", "N60"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        dropdownColor: Color(0xFFE9E6DB),
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

  Widget _buildAxisWheel(String label, int value, Function(int) onSelectedItemChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListWheelScrollView.useDelegate(
            magnification: 1.05,
            diameterRatio: 1.2,
            overAndUnderCenterOpacity: 0.85,
            useMagnifier: true,
            itemExtent: 20,
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Container(
                    width: 50,
                    color: Color(0xFF163352),
                    child: Center(
                        child: Text(
                          (index * 5).toString(),
                          style: TextStyle(
                              color: Colors.white,
                          ),
                        )
                    )
                );
              },
              childCount: 37,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBifocalDropdown(String? value, Function(String?) onChanged) {
    List<String> bifocalValues = ["Kryptok", "Executive", "D-Segment", "Trifocal", "Omnivision", "Progressive"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        dropdownColor: Color(0xFFE9E6DB),
        value: value,
        hint: Text("Select Bifocal     "),
        items: bifocalValues.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildColorDropdown(String? value, Function(String?) onChanged) {
    List<String> colorValues = ["White", "SP2Alpha", "Photogrey", "Photosun", "Photobrown"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        dropdownColor: Color(0xFFE9E6DB),
        value: value,
        hint: Text("Select Color        "),
        items: colorValues.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRemarksDropdown(String? value, Function(String?) onChanged) {
    List<String> remarksValues = ["D.V. only", "N.V. Only", "Constant Use"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        dropdownColor: Color(0xFFE9E6DB),
        value: value,
        hint: Text("Select Remarks  "),
        items: remarksValues.map((String value) {
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