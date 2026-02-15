import 'package:flutter/material.dart';
import 'mark_attendance.dart';
import 'attendance_history.dart';
import '../services/attendance_service.dart';
import '../services/attendance_service.dart' as service;
import '../services/attendance_service.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add Student Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Show dialog to add student
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Add Student"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration:
                                const InputDecoration(hintText: "Full Name"),
                          ),
                          TextField(
                            controller: _ageController,
                            decoration: const InputDecoration(hintText: "Age"),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: _sexController,
                            decoration: const InputDecoration(hintText: "Sex"),
                          ),
                          TextField(
                            controller: _classController,
                            decoration:
                                const InputDecoration(hintText: "Class"),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          final age = int.tryParse(_ageController.text.trim());
                          final sex = _sexController.text.trim();
                          final studentClass = _classController.text.trim();

                          if (name.isNotEmpty &&
                              age != null &&
                              sex.isNotEmpty &&
                              studentClass.isNotEmpty) {
                            // Add student to blockchain
                            await attendanceService.addStudentBlockchain(
                              Student(
                                  name: name,
                                  age: age,
                                  sex: sex,
                                  studentClass: studentClass),
                            );

                            // Clear controllers
                            _nameController.clear();
                            _ageController.clear();
                            _sexController.clear();
                            _classController.clear();

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Student added successfully!")));
                          }
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                "Add Student",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // Mark Attendance Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarkAttendance()),
                );
              },
              child: const Text(
                "Mark Attendance",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // Attendance History Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendanceHistory()),
                );
              },
              child: const Text(
                "Attendance History",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
