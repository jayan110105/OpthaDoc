import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 0, // Hides the app bar completely
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Good Morning, Riley',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30.0,
                  ),
                ],
              ),
            ),
           SizedBox(height: 20,),
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: Container(
                padding: EdgeInsets.all(20.0),
               decoration: BoxDecoration(
                 color: Colors.grey[200], // Background color
                 borderRadius: BorderRadius.circular(15.0), // Rounded corners
               ),
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 30.0,
                    shrinkWrap: true,
                    children: [
                      _buildDashboardButton(Icons.person_add, 'Registration'),
                      _buildDashboardButton(Icons.visibility, 'Eye Checkup'),
                      _buildDashboardButton(Icons.assignment, 'View Records'),
                      _buildDashboardButton(Icons.edit, 'Edit Records'),
                      _buildDashboardButton(Icons.event, 'Appointment'),
                    ],
                  ),
                ),
              ),
           ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(IconData icon, String label) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shadowColor: Colors.grey[200],
            elevation: 5,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16.0),
          ),
          child: Icon(
                icon,
                size: 30.0,
                color: Colors.white,
              ),
          ),
          SizedBox(height: 8.0),
          Text(label,
          textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
