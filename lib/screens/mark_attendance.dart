import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/contract_service.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
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
    try {
      await contractService.init();
      await loadStudents();
    } catch (e) {
      print("Contract initialization error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // ✅ Corrected loadStudents for your smart contract
  Future<void> loadStudents() async {
    try {
      final count = await contractService.studentCount();
      List<Attendance> loadedStudents = [];

      // IDs start from 1 in your contract
      for (int i = 1; i <= count; i++) {
        final res = await contractService.getStudent(i);

        // res[0] = name, res[1] = wallet (EthereumAddress)
        String studentName = res[0];

        loadedStudents.add(
          Attendance(
            studentName: studentName,
            date: DateTime.now(),
            isPresent: true,
          ),
        );
      }

      setState(() {
        students = loadedStudents;
        isLoading = false;
      });
    } catch (e) {
      print("Load students error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitAttendance() async {
    try {
      setState(() {
        isLoading = true;
      });

      for (int i = 0; i < students.length; i++) {
        await contractService.markAttendance(i + 1, students[i].isPresent);
        // i+1 because smart contract IDs start from 1
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance stored on blockchain!")),
      );
    } catch (e) {
      print("Submit attendance error: $e");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error storing attendance")),
      );
    }
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
          : students.isEmpty
              ? const Center(
                  child: Text(
                    "No students found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            child: Text(
                              student.studentName.isNotEmpty
                                  ? student.studentName[0]
                                  : "?",
                            ),
                          ),
                          title: Text(student.studentName),
                          trailing: Checkbox(
                            value: student.isPresent,
                            onChanged: (val) {
                              setState(() {
                                student.isPresent = val ?? false;
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
