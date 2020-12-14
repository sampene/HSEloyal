import 'dart:math';
import 'package:web3dart/credentials.dart';

Future<String> getKey() async{
  var random = new Random.secure();
  Credentials credentials = EthPrivateKey.createRandom(random);
  print(credentials.toString());

// In either way, the library can derive the public key and the address
// from a private key:
  var address = await credentials.extractAddress();
  print(credentials.toString());
  print(credentials.extractAddress().toString());
  return address.hex;
}