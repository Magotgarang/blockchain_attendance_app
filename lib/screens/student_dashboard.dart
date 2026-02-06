import 'package:flutter/material.dart';
import '../screens/mark_attendance.dart';
import '../screens/attendance_history.dart';

class StudentDashboard extends StatelessWidget {
  final List<Map<String, String>> students = [
    {"name": "Andrew", "image": "assets/avatar.png"},
    {"name": "Magot", "image": "assets/avatar.png"},
    {"name": "Alier", "image": "assets/avatar.png"},
    {"name": "Majur", "image": "assets/avatar.png"},
    {"name": "Guut", "image": "assets/avatar.png"},
    {"name": "David", "image": "assets/avatar.png"},
    {"name": "Samuel", "image": "assets/avatar.png"},
    {"name": "Barnabas", "image": "assets/avatar.png"},
    {"name": "Kon", "image": "assets/avatar.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Dashboard"),
        backgroundColor: Colors.greenAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: students.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final student = students[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/markAttendance');
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade200, Colors.green.shade50],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(student["image"]!),
                      ),
                      SizedBox(height: 12),
                      Text(student["name"]!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
