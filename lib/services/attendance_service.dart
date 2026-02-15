import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For Infura
import 'dart:convert';

// Student model
class Student {
  String name;
  int age;
  String sex;
  String studentClass;
  Student({
    required this.name,
    required this.age,
    required this.sex,
    required this.studentClass,
  });
}

// Attendance record model
class Attendance {
  String studentName;
  bool isPresent;
  DateTime date;
  String txHash;
  Attendance({
    required this.studentName,
    required this.isPresent,
    required this.date,
    required this.txHash,
  });
}

class AttendanceService {
  final List<Student> _students = [];
  final List<Attendance> _attendanceList = [];

  // Blockchain config
  final String rpcUrl =
      "https://sepolia.infura.io/v3/014d1e55fda5499ba75861d931b34c70";
  final String privateKey =
      "B69b4aa7a9353214bfdb562e2f3eaba95be0f11ec4dc2bb027203f79e03fe50e";
  final String contractAddress = "0x1768953EE7C405770a0F4ce2376DF279e608b6C4";

  // Put your full ABI JSON here as a string
  final String abi = '''[
	{
		"inputs":[{"internalType":"string","name":"name","type":"string"},{"internalType":"uint8","name":"age","type":"uint8"},{"internalType":"string","name":"sex","type":"string"},{"internalType":"string","name":"studentClass","type":"string"}],
		"name":"addStudent",
		"outputs":[],
		"stateMutability":"nonpayable",
		"type":"function"
	},
	{
		"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],
		"name":"attendanceRecords",
		"outputs":[{"internalType":"string","name":"studentName","type":"string"},{"internalType":"bool","name":"isPresent","type":"bool"},{"internalType":"uint256","name":"timestamp","type":"uint256"}],
		"stateMutability":"view",
		"type":"function"
	},
	{
		"inputs":[],
		"name":"getAttendanceRecords",
		"outputs":[{"components":[{"internalType":"string","name":"studentName","type":"string"},{"internalType":"bool","name":"isPresent","type":"bool"},{"internalType":"uint256","name":"timestamp","type":"uint256"}],"internalType":"struct Attendance.AttendanceRecord[]","name":"","type":"tuple[]"}],
		"stateMutability":"view",
		"type":"function"
	},
	{
		"inputs":[],
		"name":"getStudents",
		"outputs":[{"components":[{"internalType":"string","name":"name","type":"string"},{"internalType":"uint8","name":"age","type":"uint8"},{"internalType":"string","name":"sex","type":"string"},{"internalType":"string","name":"studentClass","type":"string"}],"internalType":"struct Attendance.Student[]","name":"","type":"tuple[]"}],
		"stateMutability":"view",
		"type":"function"
	},
	{
		"inputs":[{"internalType":"string","name":"name","type":"string"},{"internalType":"bool","name":"isPresent","type":"bool"}],
		"name":"markAttendance",
		"outputs":[],
		"stateMutability":"nonpayable",
		"type":"function"
	},
	{
		"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],
		"name":"students",
		"outputs":[{"internalType":"string","name":"name","type":"string"},{"internalType":"uint8","name":"age","type":"uint8"},{"internalType":"string","name":"sex","type":"string"},{"internalType":"string","name":"studentClass","type":"string"}],
		"stateMutability":"view",
		"type":"function"
	}
]''';

  late Web3Client _client;
  late DeployedContract _contract;
  late Credentials _credentials;

  AttendanceService() {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _contract = DeployedContract(
      ContractAbi.fromJson(abi, "Attendance"),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  // Add student
  Future<void> addStudentBlockchain(Student student) async {
    final addStudentFunction = _contract.function("addStudent");
    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: addStudentFunction,
        parameters: [
          student.name,
          BigInt.from(student.age),
          student.sex,
          student.studentClass
        ],
      ),
      chainId: 11155111, // Sepolia
    );
    _students.add(student);
    print("Added student on blockchain: $txHash");
  }

  // Get students
  Future<List<Student>> getStudentsBlockchain() async {
    final getStudentsFunction = _contract.function("getStudents");
    final result = await _client.call(
      contract: _contract,
      function: getStudentsFunction,
      params: [],
    );

    List<Student> students = [];
    for (var s in result[0]) {
      students.add(Student(
        name: s[0],
        age: (s[1] as BigInt).toInt(),
        sex: s[2],
        studentClass: s[3],
      ));
    }
    _students.clear();
    _students.addAll(students);
    return _students;
  }

  // Mark attendance
  Future<void> markAttendanceBlockchain(String name, bool isPresent) async {
    final markAttendanceFunction = _contract.function("markAttendance");
    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: markAttendanceFunction,
        parameters: [name, isPresent],
      ),
      chainId: 11155111,
    );
    _attendanceList.add(Attendance(
      studentName: name,
      isPresent: isPresent,
      date: DateTime.now(),
      txHash: txHash,
    ));
    print("Attendance marked on blockchain: $txHash");
  }

  // Get attendance records
  Future<List<Attendance>> getAttendanceBlockchain() async {
    final getAttendanceFunction = _contract.function("getAttendanceRecords");
    final result = await _client.call(
      contract: _contract,
      function: getAttendanceFunction,
      params: [],
    );

    List<Attendance> list = [];
    for (var att in result[0]) {
      list.add(Attendance(
        studentName: att[0],
        isPresent: att[1],
        date: DateTime.fromMillisecondsSinceEpoch(
            (att[2] as BigInt).toInt() * 1000),
        txHash: "from blockchain",
      ));
    }
    _attendanceList.clear();
    _attendanceList.addAll(list);
    return _attendanceList;
  }

  List<Student> getLocalStudents() => _students;
  List<Attendance> getLocalAttendance() => _attendanceList;
}

// Single instance
final attendanceService = AttendanceService();
