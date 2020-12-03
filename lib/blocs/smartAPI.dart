import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';


String address = "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2";
String RPC_address = "https://kovan.infura.io";
Web3Client ethClient = new Web3Client(RPC_address, http.Client());

abstract class ethAPI {
  Future<DeployedContract> loadContract();

  Future<String> submit(String functionName, List<dynamic> args);

  Future<List<dynamic>> query(String functionName, List<dynamic> args);

  Future<String> sendCoin(String targetAddressHex, int amount);

  Future<List<dynamic>> getBalance(String targetAddressHex);
}


class smartAPI implements ethAPI {

  Future<DeployedContract> loadContract() async {
    String abiCode = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xCc43bc89d05e9CdF33a479081e4F0CF154322AA4";

    final contract = DeployedContract(ContractAbi.fromJson(abiCode, "Loyal"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex("3afe01d2fd19fbce288f880e8d3cc7e62d189827d88bb3b1a8548b34c39056a8");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);

    var result = await ethClient.sendTransaction(credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,),);

    return result;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFuncion = contract.function(functionName);
    final data = await ethClient.call(
        contract: contract, function: ethFuncion, params: args);

    return data;
  }

  Future<String> sendCoin(String targetAddressHex, int amount) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);
// uint in smart contract means BigInt for us
    var bigAmount = BigInt.from(amount);
    //sendCoin transaction
    var response = await submit("transfer", [address, bigAmount]);

    //hash of the transaction
    return response;
  }


  Future<List<dynamic>> getBalance(String targetAddressHex) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);
    List<dynamic> result = await query("getBalance", [address]);
    return result;
  }


}