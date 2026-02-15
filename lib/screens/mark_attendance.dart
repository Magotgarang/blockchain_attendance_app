import 'package:flutter/material.dart';
import '../services/attendance_service.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  late List<Attendance> studentsAttendance = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  // Load students from blockchain
  Future<void> loadStudents() async {
    setState(() {
      isLoading = true;
    });

    final students = await attendanceService.getStudentsBlockchain();

    setState(() {
      studentsAttendance = students
          .map((s) => Attendance(
                studentName: s.name,
                isPresent: true,
                date: DateTime.now(),
                txHash: "",
              ))
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Mark Attendance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: studentsAttendance.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(
                          studentsAttendance[index].studentName[0],
                        ),
                      ),
                      title: Text(studentsAttendance[index].studentName),
                      trailing: Checkbox(
                        value: studentsAttendance[index].isPresent,
                        onChanged: (val) {
                          setState(() {
                            studentsAttendance[index].isPresent = val!;
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
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          // Mark attendance on blockchain
          for (var att in studentsAttendance) {
            await attendanceService.markAttendanceBlockchain(
                att.studentName, att.isPresent);
          }

          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Attendance stored successfully!")),
          );
        },
      ),
    );
  }
}
