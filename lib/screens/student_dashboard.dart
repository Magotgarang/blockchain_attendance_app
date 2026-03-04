import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/contract_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final ContractService contractService = ContractService();
  List<Attendance> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    await contractService.init();
    final count = await contractService.studentCount();
    List<Attendance> loaded = [];

    for (int i = 0; i < count; i++) {
      final studentRes = await contractService.getStudent(i);
      final studentName = studentRes[1] as String;

      final attendanceRes = await contractService.getAttendance(i);
      bool isPresent = (attendanceRes.isNotEmpty) ? attendanceRes.last : false;

      loaded.add(Attendance(
        studentName: studentName,
        date: DateTime.now(),
        isPresent: isPresent,
      ));
    }

    setState(() {
      students = loaded;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.greenAccent.shade700,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(student.studentName),
                    subtitle: Text(
                        "Present: ${student.isPresent} on ${student.date.toLocal()}"),
                  ),
                );
              },
            ),
    );
  }
}
