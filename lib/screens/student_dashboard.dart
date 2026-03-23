import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/contract_service.dart';
import 'package:web3dart/web3dart.dart';

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
      final studentRes = await contractService.getStudent(i + 1);
      final studentName = studentRes[0] as String;
      final walletAddress = (studentRes[1] as EthereumAddress).hex;

      final attendanceRes = await contractService.getAttendance(i + 1);
      final dates = attendanceRes[0] as List<dynamic>;
      final statuses = attendanceRes[1] as List<dynamic>;

      DateTime? date;
      bool isPresent = false;

      if (dates.isNotEmpty && statuses.isNotEmpty) {
        // Take only the latest attendance
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
                    subtitle: Text(student.date != null
                        ? "Date: ${student.date!.toLocal().toString().split('.')[0]}"
                        : "No record yet"),
                    trailing: student.date != null
                        ? Icon(
                            student.isPresent
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                student.isPresent ? Colors.green : Colors.red,
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
