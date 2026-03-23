class Attendance {
  String studentName;
  bool isPresent;
  DateTime? date; // nullable now
  String? transactionHash; // for blockchain

  Attendance({
    required this.studentName,
    required this.isPresent,
    this.date, // can be null
    this.transactionHash,
  });
}
