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
                _buildEyeLabel("R (Right Eye)"),
                _buildEyeLabel("L (Left Eye)"),
                _buildTextLabel('Distance Vision'),
                _buildTextField('R'),
                _buildTextField('L'),
                _buildTextLabel('Pinhole'),
                _buildTextField('R'),
                _buildTextField('L'),
                _buildTextLabel('Glasses'),
                _buildTextField('R'),
                _buildTextField('L'),
                _buildEyeLabel("ARK"),
                const SizedBox(),
                const SizedBox(),
                _buildTextLabel('Sp.'),
                _buildTextField('R'),
                _buildTextField('L'),
                _buildTextLabel('Cyl.'),
                _buildTextField('R'),
                _buildTextField('L'),
                _buildTextLabel('Axis'),
                _buildTextField('R'),
                _buildTextField('L'),
              ],
            ),
            SizedBox(height: 20,),
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
          GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildEyeLabel("BGC"),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildEyeLabel("R"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildEyeLabel("L"),
              ],
            ),
            _buildTextLabel("Sp."),
            _buildTextField("R"),
            _buildTextField("L"),
            _buildTextLabel("Cyl."),
            _buildTextField("R"),
            _buildTextField("L"),
            _buildTextLabel("Axis"),
            _buildTextField("R"),
            _buildTextField("L"),
            _buildTextLabel("ADD"),
            _buildTextField("R"),
            _buildTextField("L"),
          ],
          ),
            SizedBox(height: 20,),
            Divider(),
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
            _buildEyeLabel("Remarks"),
            _buildCheckboxListTile('D.V. only', selectedRemarks, (value) {
              setState(() {
                selectedRemarks = (value ?? false) ? 'D.V only' : null;
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
}