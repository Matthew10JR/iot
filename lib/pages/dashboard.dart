import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'door_control.dart';
import 'readings.dart';
import 'sign_in_page.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDashboardButton(context, Icons.door_front_door, 'Door Control', DoorControl()),
              SizedBox(height: 20),
              _buildDashboardButton(context, Icons.sensors, 'Readings', Readings()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, IconData icon, String label, Widget page) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Icon(icon, size: 40),
      label: Text(label, style: TextStyle(fontSize: 18)),
    );
  }
}
