// lib/models/attendance_model.dart

class Attendance {
  final String studentName;
  bool isPresent;
  final DateTime date;
  final String transactionHash;

  Attendance({
    required this.studentName,
    this.isPresent = true,
    required this.date,
    this.transactionHash = "",
  });
}
