import 'dart:math';
import 'dart:typed_data';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

Future<List<dynamic>> getKey() async{
  final random = new Random.secure();
  final EthPrivateKey credentials = EthPrivateKey.createRandom(random);
  // credentials.privateKey

  String privateKeyy = bytesToHex(credentials.privateKey);
  Uint8List privateKeyUint8List = (credentials.privateKey);


  print(privateKeyUint8List);

  var address = await credentials.extractAddress();
  return [privateKeyUint8List, address.hex, privateKeyy];
}

// ll@gmail
// 6e530a5b-8071-4ed9-b85e-9f4e12369c52
// flutter: public address: 0x043ab6bf3dc23a48465da863d04dec76f8928742
// flutter: private key:5ee43ec9a11a6db478c3fd46bded7285d02b42d4f755456937ecc891ab806c74
// flutter: public address re extracted: 0x043ab6bf3dc23a48465da863d04dec76f8928742