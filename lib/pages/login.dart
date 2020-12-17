import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/blocs/smartAPI.dart';
import 'package:loyal/pages/home.dart';
import 'package:loyal/pages/signup.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/utils/utils.dart';
import 'package:loyal/widgets/custom_appbar.dart';
import 'package:loyal/widgets/dialog_progress.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:hex/hex.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showEmailClear = false;
  bool showPasswordClear = false;

  FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mnemonicController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController.addListener(() {
      setState(() {
        showEmailClear = emailController.text.isNotEmpty;
      });
    });

    passwordController.addListener(() {
      setState(() {
        showPasswordClear = passwordController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: ourCustomAppbar(),
      body: SafeArea(
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
                child: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return DialogProgress("Authenticating...");
                          });
                    } else if (state is LoginError) {
                      Navigator.pop(context);
                      displayDialog("Oops", state.message);
                    } else if (state is LoginSuccess) {
                      Navigator.pop(context);
                      navigateToHome(context, state.loginResponse.data.userId);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo.jpg',
                          width: width / 4.5,
                        ),
                        Text(
                          "LOGIN",
                          style: TextStyle(fontFamily: "Bebas", fontSize: 30),
                        ),
                        Text("...loyal"),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                              labelText: "email",
                              suffixIcon: IconButton(
                                icon: showEmailClear
                                    ? Icon(Icons.clear)
                                    : Container(),
                                onPressed: () {
                                  emailController.clear();
                                },
                              ),
                              hintText: "Email address...",
//                              labelText: "Username",
                              filled: true,
                              fillColor: Colors.white),
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                              labelText: "password",
                              suffixIcon: IconButton(
                                icon: showPasswordClear
                                    ? Icon(Icons.clear)
                                    : Container(),
                                onPressed: () {
                                  passwordController.clear();
                                },
                              ),
                              hintText: "Password...",
//                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {},
                          controller: passwordController,
                          obscureText: true,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          // focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                              labelText: "secret phrase",
                              suffixIcon: IconButton(
                                icon: showPasswordClear
                                    ? Icon(Icons.clear)
                                    : Container(),
                                onPressed: () {
                                  passwordController.clear();
                                },
                              ),
                              hintText: "enter the secret phrase here...",
//                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {},
                          controller: mnemonicController,
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Don't have an account?",
                            style:
                                TextStyle(fontFamily: "Fatface", fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: () {
                              navigateToSignup(context);
                            },
                            child: Text(
                              "Sign up",
                              style:
                                  TextStyle(fontFamily: "Bebas", fontSize: 25),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: width * 0.18,
                            height: height * 0.18,
                            child: FloatingActionButton(
                              onPressed: () {
                                _login(context);
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              backgroundColor: MyColors.heavyblueblack,
                              elevation: 0,
                            ),
                          ),
                        )

                        // Image.asset("assets/logo-loyal.jpg")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    String mn = mnemonicController.text.trim();
    bool isValid = await bip39.validateMnemonic(mn);
    if (!isValid) {
      displayDialog("Oops",
          "Please make sure you have entered the exact access code you copied.");
    } else {
      String theEntropy = bip39.mnemonicToEntropy(mn);

      // print("private keys regained : "+ thehexx);
      // Credentials credentials = EthPrivateKey.fromHex(theEntropy);
          await sharedPreferences.setString(Keys.P_KEY, theEntropy);
          final credentials = await ethClient.credentialsFromPrivateKey(theEntropy);
          final address = await credentials.extractAddress();
          String publicaddress = address.hex;

      print("public address re extracted: " + publicaddress);


      BlocProvider.of<LoginBloc>(context).add(AttemptLogin(
          emailController.text.trim(),
          passwordController.text.trim(),
          publicaddress));
    }
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
        MaterialPageRoute<LoginPage>(
          builder: (BuildContext context) => SignupPage(),
          fullscreenDialog: false,
        ));
  }

  navigateToHome(context, String userId) {
    Navigator.push(
        context,
        MaterialPageRoute<LoginPage>(
          builder: (BuildContext context) => HomePage(userId),
          fullscreenDialog: false,
        ));
  }
}
