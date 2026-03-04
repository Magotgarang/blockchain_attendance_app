import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ContractService {
  final String rpcUrl = dotenv.env['RPC_URL']!;
  final String privateKey = dotenv.env['PRIVATE_KEY']!;
  final String contractAddress = dotenv.env['CONTRACT_ADDRESS']!;

  late Web3Client _client;
  late DeployedContract _contract;
  late EthereumAddress _contractAddr;
  late Credentials _credentials;

  ContractService() {
    _client = Web3Client(rpcUrl, Client());
    _contractAddr = EthereumAddress.fromHex(contractAddress);
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> init() async {
    String abiString = await rootBundle.loadString("assets/abi.json");
    final abi = ContractAbi.fromJson(abiString, "AttendanceSystem");
    _contract = DeployedContract(abi, _contractAddr);
  }

  Future<String> addStudent(String name, String wallet) async {
    final func = _contract.function('addStudent');
    final walletAddr = EthereumAddress.fromHex(wallet);
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: func,
        parameters: [name, walletAddr],
      ),
      chainId: 11155111, // Sepolia
    );
    return tx;
  }

  Future<String> markAttendance(int studentId, bool present) async {
    final func = _contract.function('markAttendance');
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: func,
        parameters: [BigInt.from(studentId), present],
      ),
      chainId: 11155111,
    );
    return tx;
  }

  Future<List> getStudent(int studentId) async {
    final func = _contract.function('getStudent');
    final res = await _client.call(
      contract: _contract,
      function: func,
      params: [BigInt.from(studentId)],
    );
    return res;
  }

  Future<int> studentCount() async {
    final func = _contract.function('studentCount');
    final res =
        await _client.call(contract: _contract, function: func, params: []);
    return (res[0] as BigInt).toInt();
  }

  Future<List> getAttendance(int studentId) async {
    final func = _contract.function('getAttendance');
    final res = await _client.call(
      contract: _contract,
      function: func,
      params: [BigInt.from(studentId)],
    );
    return res;
  }
}
