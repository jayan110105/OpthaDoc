import 'package:flutter/material.dart';

class User2 extends StatefulWidget {
  const User2({super.key});

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
  String? selectedDVR;
  String? selectedDVL;
  String? selectedDVR2;
  String? selectedDVL2;
  String? selectedNVR;
  String? selectedNVL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User 2"),
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
                _buildTextField('R'),
                _buildTextField('L'),
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
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
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

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
          width: 80, // Use SizedBox instead of Container to enforce fixed width
          child: TextField(
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