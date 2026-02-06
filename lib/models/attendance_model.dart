class Attendance {
  String studentName;
  bool isPresent;
  DateTime date;
  String? transactionHash; // for blockchain

  Attendance({
    required this.studentName,
    required this.isPresent,
    required this.date,
    this.transactionHash,
  });
}
