import 'package:flutter/material.dart';
import '../services/attendance_service.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  List attendanceList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  // Load attendance records from blockchain
  Future<void> _loadAttendance() async {
    setState(() {
      _loading = true;
    });
    final list = await attendanceService.getAttendanceBlockchain();
    setState(() {
      attendanceList = list
          .map((att) => {
                'name': att.studentName,
                'isPresent': att.isPresent,
                'date': att.date,
                'txHash': att.txHash,
              })
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.green,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final att = attendanceList[index];
                  return Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(att['name'][0].toUpperCase()),
                      ),
                      title: Text(att['name']),
                      subtitle: Text(
                          "Status: ${att['isPresent'] ? 'Present' : 'Absent'}\nDate: ${att['date']}"),
                      isThreeLine: true,
                      trailing: Icon(
                        Icons.check_circle,
                        color: att['isPresent'] ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
