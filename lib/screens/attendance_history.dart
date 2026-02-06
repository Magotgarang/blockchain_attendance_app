import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceHistory extends StatelessWidget {
  final List<Attendance> attendanceList = [
    Attendance(
        studentName: "Andrew",
        date: DateTime.now(),
        isPresent: true,
        transactionHash: "0x123abc"),
    Attendance(
        studentName: "Magot",
        date: DateTime.now(),
        isPresent: false,
        transactionHash: "0x123abc"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Attendance History"),
          backgroundColor: Colors.blueAccent),
      backgroundColor: Colors.blue[50],
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          final att = attendanceList[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(att.studentName),
              subtitle:
                  Text("${att.date.toLocal()} - Present: ${att.isPresent}"),
              trailing: Text(att.transactionHash ?? "-"),
            ),
          );
        },
      ),
    );
  }
}
