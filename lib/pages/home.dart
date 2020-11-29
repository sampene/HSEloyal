import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/blocs/smartAPI.dart';
import 'package:loyal/pages/signup.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/widgets/custom_appbar.dart';
import 'package:loyal/widgets/dialog_progress.dart';
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

class _HomePageState extends State<HomePage> {
  // Web3Client ethClient;
  // String address = "";
  ethAPI smartApi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: ourCustomAppbar(),
      bottomNavigationBar: ConvexAppBar.badge({0: '',},
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
        onTap: (int index) =>
            setState(() {
              _index = index;
            }),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  "assets/coin.png", colorBlendMode: BlendMode.lighten,
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
                        future: smartApi.getBalance(""),
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
                          var result = await smartApi.sendCoin(
                              "", 2);
                          setState(() {
                            lastTransactionHash = result;
                          });
                        },
                      ),
                      RaisedButton(
                        child: Text("Get balance"),
                        onPressed: () async {
                          var result = await smartApi.getBalance("0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2");
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
              FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("OK"))
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
