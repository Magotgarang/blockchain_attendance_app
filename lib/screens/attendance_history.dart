import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/contract_service.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({super.key});

  @override
  _AttendanceHistoryState createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final ContractService contractService = ContractService();
  List<Attendance> attendanceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
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
        transactionHash: "", // Optional: store tx hash if needed
      ));
    }

    setState(() {
      attendanceList = loaded;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final att = attendanceList[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(att.studentName),
                    subtitle: Text(
                        "${att.date.toLocal()} - Present: ${att.isPresent}"),
                    trailing: Text(att.transactionHash ?? "-"),
                  ),
                );
              },
            ),
    );
  }
}
