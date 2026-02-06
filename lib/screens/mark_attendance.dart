import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/wallet_service.dart';

class MarkAttendance extends StatefulWidget {
  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  List<Attendance> students = [
    Attendance(studentName: "Andrew", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Magot", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Alier", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Majur", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Guut", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "David", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Samuel", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Barnabas", date: DateTime.now(), isPresent: true),
    Attendance(studentName: "Kon", date: DateTime.now(), isPresent: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text("Mark Attendance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
        child: Icon(Icons.send),
        onPressed: () async {
          String txHash = await WalletService.storeAttendance(students);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Attendance stored! Tx: $txHash")));
        },
      ),
    );
  }
}
