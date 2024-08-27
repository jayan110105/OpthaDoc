import 'package:flutter/material.dart';

class User2 extends StatefulWidget {
  const User2({super.key});

  @override
  State<User2> createState() => _User2State();
}

class _User2State extends State<User2> {
  String? selectedCheckbox;
  String? selectedCheckbox2;

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
                _buildTextLabel("IOP"),
                SizedBox(width: 125,),
                Container(
                  width: 215,
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Enter IOP value',
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
            SizedBox(),
            _buildTextField("R"),
            _buildTextField("L"),
            SizedBox(),
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
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildEyeLabel("Select one")
                ]
            ),
            CheckboxListTile(
              title: Text('Progressive'),
              value: selectedCheckbox == 'Progressive',
              onChanged: (value) {
                setState(() {
                  selectedCheckbox = value! ? 'Progressive' : null;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Keep'),
              value: selectedCheckbox == 'Keep',
              onChanged: (value) {
                setState(() {
                  selectedCheckbox = value! ? 'Keep' : null;
                });
              },
            ),
            Divider(),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildEyeLabel("Select one")
                ]
            ),
            CheckboxListTile(
              title: Text('DU only'),
              value: selectedCheckbox2 == 'DU only',
              onChanged: (value) {
                setState(() {
                    selectedCheckbox2 = value! ? 'DU only' : null;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Near Only'),
              value: selectedCheckbox2 == 'Near Only',
              onChanged: (value) {
                setState(() {
                  selectedCheckbox2 = value! ? 'Near Only' : null;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Constant Use'),
              value: selectedCheckbox2 == 'Constant Use',
              onChanged: (value) {
                setState(() {
                  selectedCheckbox2 = value! ? 'Constant Use' : null;
                });
              },
            ),
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