import '../models/attendance_model.dart';

class WalletService {
  // Simulate storing attendance on blockchain
  static Future<String> storeAttendance(List<Attendance> attendanceList) async {
    await Future.delayed(Duration(seconds: 2)); // simulate network delay
    String txHash = "0x123abc456def789"; // fake blockchain transaction hash
    for (var att in attendanceList) {
      att.transactionHash = txHash;
    }
    return txHash;
  }
}
