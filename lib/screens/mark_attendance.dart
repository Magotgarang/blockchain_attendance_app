import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/contract_service.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final ContractService contractService = ContractService();
  List<Attendance> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initContract();
  }

  Future<void> initContract() async {
    await contractService.init();
    await loadStudents();
  }

  Future<void> loadStudents() async {
    final count = await contractService.studentCount();
    List<Attendance> loadedStudents = [];

    for (int i = 0; i < count; i++) {
      final res = await contractService.getStudent(i);
      final studentName = res[1] as String;
      loadedStudents.add(
        Attendance(
            studentName: studentName, date: DateTime.now(), isPresent: true),
      );
    }

    setState(() {
      students = loadedStudents;
      isLoading = false;
    });
  }

  Future<void> submitAttendance() async {
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < students.length; i++) {
      await contractService.markAttendance(i, students[i].isPresent);
    }

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance stored on blockchain!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Mark Attendance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(students[index].studentName[0]),
                      ),
                      title: Text(students[index].studentName),
                      trailing: Checkbox(
                        value: students[index].isPresent,
                        onChanged: (val) {
                          setState(() {
                            students[index].isPresent = val!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.send),
        onPressed: submitAttendance,
      ),
    );
  }
}
