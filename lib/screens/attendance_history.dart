import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/contract_service.dart';
import 'package:web3dart/web3dart.dart';

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
      final studentRes = await contractService.getStudent(i + 1);
      final studentName = studentRes[0] as String;
      final walletAddress = (studentRes[1] as EthereumAddress).hex;

      final attendanceRes = await contractService.getAttendance(i + 1);
      final dates = attendanceRes[0] as List<dynamic>;
      final statuses = attendanceRes[1] as List<dynamic>;

      DateTime? date;
      bool isPresent = false;

      if (dates.isNotEmpty && statuses.isNotEmpty) {
        final lastIndex = dates.length - 1;
        date = DateTime.fromMillisecondsSinceEpoch(
            (dates[lastIndex] as BigInt).toInt() * 1000);
        isPresent = statuses[lastIndex] as bool;
      }

      loaded.add(Attendance(
        studentName: studentName,
        date: date,
        isPresent: isPresent,
        transactionHash: walletAddress,
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
                    subtitle: Text(att.date != null
                        ? "Date: ${att.date!.toLocal().toString().split('.')[0]}"
                        : "No record yet"),
                    trailing: att.date != null
                        ? Icon(
                            att.isPresent ? Icons.check_circle : Icons.cancel,
                            color: att.isPresent ? Colors.green : Colors.red,
                            size: 28,
                          )
                        : const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                );
              },
            ),
    );
  }
}
