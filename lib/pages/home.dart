import 'dart:math';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/blocs/smartAPI.dart';
import 'package:loyal/blocs/userinfo/user_info_bloc.dart';
import 'package:loyal/models/userinfo_response.dart';
import 'package:loyal/pages/login.dart';
import 'package:loyal/pages/signup.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/resources/my_dimens.dart';
import 'package:loyal/utils/fadedindexstack.dart';
import 'package:loyal/utils/snackbar_util.dart';
import 'package:loyal/utils/utils.dart';
import 'package:loyal/widgets/custom_appbar.dart';
import 'package:loyal/widgets/custom_appbar_logout.dart';
import 'package:loyal/widgets/dialog_progress.dart';
import 'package:loyal/widgets/qr_canner.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class HomePage extends StatefulWidget {
  final String userId;

  HomePage(this.userId);

  @override
  _HomePageState createState() => _HomePageState();
}

int _index = 0;
bool _isVisible = true;
String lastTransactionHash;
String balance;
GlobalKey<ConvexAppBarState> _appBarKey = GlobalKey<ConvexAppBarState>();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  Widget _loadedWidget = CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: MyColors.mainbggrey,
      appBar: CustomAppbarWithLogout(onLogoutPressed: () {
        _showLogOutDialog();
      }),
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
          TabItem(icon: Icons.local_cafe, title: 'Cafes'),
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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        BlocBuilder<UserInfoBloc, UserInfoState>(
                            builder: (context, state) {
                          if (state is UserInfoLoading) {
                            _loadedWidget = CircularProgressIndicator();
                            return _loadedWidget;
                          } else if (state is UserInfoSuccess) {
                            _loadedWidget = buildHomeUI(state.userInfoResponse);
                            return _loadedWidget;
                          } else if (state is USerInfoError) {
                            _loadedWidget = Container();
                            return _loadedWidget;
                          } else {
                            return _loadedWidget;
                          }
                        })

                        // FutureBuilder(
                        //   future: getBalance(
                        //       "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2"),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       return Text(
                        //           'You have this many Coins ${snapshot.data[0]}');
                        //     } else
                        //       return Text('Loading...');
                        //   },
                        // ),
                        // RaisedButton(
                        //   child: Text("Send some Coins"),
                        //   onPressed: () async {
                        //     // var result = await sendCoin("0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B", 7);
                        //     var result = await sendCoin("0x8ea89c630873a648adc188eca4ff919197f06dc2", 7);
                        //     setState(() {
                        //       lastTransactionHash = result;
                        //     });
                        //   },
                        // ),
                        // RaisedButton(
                        //   child: Text("Get balance"),
                        //   onPressed: () async {
                        //     var result = await getBalance(
                        //         "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2");
                        //     print(result);
                        //     // setState(() {
                        //     //   balance = result;
                        //     // });
                        //   },
                        // ),
                        // RaisedButton(
                        //   child: Text("Scan"),
                        //   onPressed: ()  {
                        //     navigateToScan(context);
                        //   },
                        // ),
                        // Text("Last transaction hash: $lastTransactionHash")

                        // Image.asset("assets/logo-loyal.jpg")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: MyColors.accentColor,
          ),
          Container(
            color: MyColors.boldgrey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.heavyblueblack,
        child: Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
        onPressed: () {
          navigateToScan(context);
        },
      ),
    );
  }

  Widget buildHomeUI(UserInfoResponse userInfoResponse) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          "Welcome, ${userInfoResponse.data.firstName}",
          style: TextStyle(fontFamily: "fatface", fontSize: 30),
        ),
        Text("It's great to see you again"),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: MyColors.backgroundColor.withOpacity(0.1),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          height: 150,
          width: width,
          child: Stack(
            children: [
              Positioned(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "assets/coin.png",colorBlendMode: BlendMode.lighten,
                  ),
                ),
                right: -30,
                bottom: -20,
                width: width / 2.5,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Icon(Icons.account_balance_wallet),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${userInfoResponse.data.balance}",
                          style: TextStyle(fontFamily: "bebas", fontSize: 40),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your balance"),

                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
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

  void _getUser() {
    BlocProvider.of<UserInfoBloc>(context).add(fetchUserInfo(widget.userId));
  }

  navigateToSignup(context) {
    Navigator.push(
        context,
        MaterialPageRoute<HomePage>(
          builder: (BuildContext context) => SignupPage(),
          fullscreenDialog: false,
        ));
  }

  Widget _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular((MyDimens.dialogCornerRadius))),
          content: Text("Are you sure you want to log out?"),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No",
                    style: TextStyle(
                      color: MyColors.primaryColor,
                    ))),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogProgress("Logging out...");
                      });
                  sharedPreferences.remove(Keys.FIRST_TIME).then((value) {
                    Navigator.pop(context);
                    if (value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      SnackbarUtil.showSimpleSnackbar(
                          context, "Logging out failed. Please try again.");
                    }
                  });
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: MyColors.primaryColor,
                  ),
                ))
          ],
        );
      },
    );
  }

  navigateToScan(context) {
    Navigator.push(
        context,
        MaterialPageRoute<HomePage>(
          builder: (BuildContext context) => QRScanner(),
          fullscreenDialog: false,
        ));
  }
}
