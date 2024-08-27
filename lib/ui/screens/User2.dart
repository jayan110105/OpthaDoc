import 'package:flutter/material.dart';

class User2 extends StatelessWidget {
  const User2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User 2"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Distance Vision'),
                SizedBox(height: 20,),
                Text('Pinhole'),
              ],
            ),
            Column(
              children: [
                Text(
                  "R (Right Eye)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                        width: 80,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'R',
                          ),
                        ),
                      )
                ),
                SizedBox(height: 20,),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 80,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'R',
                        ),
                      ),
                    )
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "L (Left Eye)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child:
                      Container(
                        width: 80,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'L ',
                          ),
                        ),
                      )
                  ),
                SizedBox(height: 20,),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                    Container(
                      width: 80,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'L ',
                        ),
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
