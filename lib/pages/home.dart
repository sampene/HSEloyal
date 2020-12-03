import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/blocs/smartAPI.dart';
import 'package:loyal/pages/signup.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/utils/fadedindexstack.dart';
import 'package:loyal/widgets/custom_appbar.dart';
import 'package:loyal/widgets/dialog_progress.dart';
import 'package:loyal/widgets/qr_canner.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int _index = 0;
bool _isVisible = true;
String lastTransactionHash;
String balance;
GlobalKey<ConvexAppBarState> _appBarKey = GlobalKey<ConvexAppBarState>();
// ethAPI smartApi;
String RPC_address =
    "https://kovan.infura.io/v3/776e4318c8844d01830f74bc865059ea";

class _HomePageState extends State<HomePage> {
  String address = "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2";

  // String RPC_address = "https://kovan.infura.io";
  Web3Client ethClient = new Web3Client(RPC_address, http.Client());

  @override
  void initState() {
    // smartApi = new ethAPI();
    super.initState();
  }

  Future<DeployedContract> loadContract() async {
    String abiCode = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xCc43bc89d05e9CdF33a479081e4F0CF154322AA4";

    final contract = DeployedContract(ContractAbi.fromJson(abiCode, "Loyal"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "3afe01d2fd19fbce288f880e8d3cc7e62d189827d88bb3b1a8548b34c39056a8");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);

    var result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
        ),
        chainId: 4);

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: ourCustomAppbar(),
      bottomNavigationBar: ConvexAppBar.badge(
        {
          0: '',
        },
        // key: _appBarKey,
        backgroundColor: Colors.white,
        activeColor: MyColors.heavyblueblack,
        color: MyColors.heavyblueblack,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.qr_code, title: 'Scan'),
          TabItem(icon: Icons.settings, title: 'Settings'),
        ],
        initialActiveIndex: 0,
        //optional, default as 0
        onTap: (int index) => setState(() {
          _index = index;
        }),
      ),
      body: FadeIndexedStack(
        index: _index,
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Opacity(
                    opacity: 0.4,
                    child: Image.asset(
                      "assets/coin.png",
                      colorBlendMode: BlendMode.lighten,
                    ),
                  ),
                  right: -30,
                  bottom: -20,
                  width: width / 1.6,
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            "Welcome, this is Loyal. ",
                            style: TextStyle(fontFamily: "Bebas", fontSize: 30),
                          ),
                          FutureBuilder(
                            future: getBalance(
                                "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2"),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                    'You have this many Coins ${snapshot.data[0]}');
                              } else
                                return Text('Loading...');
                            },
                          ),
                          RaisedButton(
                            child: Text("Send some Coins"),
                            onPressed: () async {
                              var result = await sendCoin(
                                  "0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B", 7);
                              setState(() {
                                lastTransactionHash = result;
                              });
                            },
                          ),
                          RaisedButton(
                            child: Text("Get balance"),
                            onPressed: () async {
                              var result = await getBalance(
                                  "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2");
                              print(result);
                              // setState(() {
                              //   balance = result;
                              // });
                            },
                          ),
                          Text("Last transaction hash: $lastTransactionHash")

                          // Image.asset("assets/logo-loyal.jpg")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          QRScanner(),
          Container(
            color: MyColors.boldgrey,
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    // BlocProvider.of<LoginBloc>(context).add(AttemptLogin(emailController.text.trim(),
    //     passwordController.text.trim()));
  }

  void displayDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  navigateToSignup(context) {
    Navigator.push(
        context,
        MaterialPageRoute<HomePage>(
          builder: (BuildContext context) => SignupPage(),
          fullscreenDialog: false,
        ));
  }
}
