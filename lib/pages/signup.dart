import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/signup/signup_bloc.dart';
import 'package:loyal/blocs/smartAPI.dart';
import 'package:loyal/pages/login.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/widgets/custom_appbar.dart';
import 'package:loyal/widgets/dialog_progress.dart';
import 'package:loyal/utils/bchain_functions.dart' as blockchain;
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool showEmailClear = false;
  bool showfirstnameClear = false;
  bool showOthernamesClear = false;
  bool showPasswordClear = false;
  bool showPasswordConfirmClear = false;

  String publicAddress;
  String privateKey;
  Uint8List privateKeyUint8List;

  String mnemonic;

  FocusNode firstnameFocusNode = FocusNode();
  FocusNode othernamesFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode passwordConfirmFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController othernamesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController.addListener(() {
      setState(() {
        showEmailClear = emailController.text.isNotEmpty;
      });
    });
    firstnameController.addListener(() {
      setState(() {
        showfirstnameClear = firstnameController.text.isNotEmpty;
      });
    });
    othernamesController.addListener(() {
      setState(() {
        showOthernamesClear = othernamesController.text.isNotEmpty;
      });
    });

    passwordController.addListener(() {
      setState(() {
        showPasswordClear = passwordController.text.isNotEmpty;
      });
    });
    passwordConfirmController.addListener(() {
      setState(() {
        showPasswordConfirmClear = passwordConfirmController.text.isNotEmpty;
      });
    });
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
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  "assets/coffee.png",
                  colorBlendMode: BlendMode.lighten,
                ),
              ),
              right: -30,
              bottom: -20,
              width: width / 1.6,
            ),
            Center(
              child: SingleChildScrollView(
                child: BlocListener<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupLoading) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return DialogProgress("Signing up, please wait...");
                          });
                    } else if (state is SignupError) {
                      Navigator.pop(context);
                      displayDialog(
                          state.message, "Couldn't sign up. Please try again.");
                    } else if (state is SignupSuccess) {
                      Navigator.pop(context);

                      displayMnemonicMsg(mnemonic);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo.jpg',
                          width: width / 4.5,
                        ),
                        Text(
                          "SIGNUP",
                          style: TextStyle(fontFamily: "Bebas", fontSize: 30),
                        ),
                        Text("All the goodies start here..."),
                        SizedBox(
                          height: 20,
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
                                .requestFocus(firstnameFocusNode);
                          },
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          focusNode: firstnameFocusNode,
                          decoration: InputDecoration(
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                              labelText: "firstname",
                              suffixIcon: IconButton(
                                icon: showfirstnameClear
                                    ? Icon(Icons.clear)
                                    : Container(),
                                onPressed: () {
                                  firstnameController.clear();
                                },
                              ),
                              hintText: "First name...",
//                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(othernamesFocusNode);
                          },
                          controller: firstnameController,
                          obscureText: false,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          focusNode: othernamesFocusNode,
                          decoration: InputDecoration(
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                              labelText: "othernames",
                              suffixIcon: IconButton(
                                icon: showOthernamesClear
                                    ? Icon(Icons.clear)
                                    : Container(),
                                onPressed: () {
                                  othernamesController.clear();
                                },
                              ),
                              hintText: "Othernames...",
//                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          controller: othernamesController,
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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordConfirmFocusNode);
                          },
                          controller: passwordController,
                          obscureText: true,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          focusNode: passwordConfirmFocusNode,
                          decoration: InputDecoration(
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                              labelText: "confirm password",
                              suffixIcon: IconButton(
                                icon: showPasswordConfirmClear
                                    ? Icon(Icons.clear)
                                    : Container(),
                                onPressed: () {
                                  passwordConfirmController.clear();
                                },
                              ),
                              hintText: "Confirm Password...",
//                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            //  _login(context);
                          },
                          controller: passwordConfirmController,
                          obscureText: true,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Have an account?",
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
                              navigateToLogin(context);
                            },
                            child: Text(
                              "Log in",
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
                                _signup(context);
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

  void displayMnemonicMsg(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Important Step!!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Copy this text to a very safe place. It is your private access. You will need it for login."),
                SizedBox(height: 10,),
                Text(message, style: TextStyle(
                    color: MyColors.heavyblueblack, fontSize: 18),),
                FlatButton.icon(
                  label: Text("Copy"),
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(text: message));
                    //     .then((_) {
                    //   Scaffold.of(context).showSnackBar(SnackBar(
                    //       content: Text("Access code copied to clipboard")));
                    // });
                  },
                )
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    navigateToLogin(context);
                  },
                  child: Text("Continue"))
            ],
          );
        });
  }

  void _signup(BuildContext context) async {
    //generate private address
    var keys = await blockchain.getKey();
    privateKeyUint8List = keys[0];
    publicAddress = keys[1];
    privateKey = keys[2];

    print("public address: " + publicAddress);
    print("private key:" + privateKey);


    //use bip39 lib to generate and store mnemonic value inside mnenonic variable
    mnemonic = await bip39.entropyToMnemonic(privateKey.toString());
    // mnemonic = await bip39.generateMnemonic(randomBytes: privateKey);
    // print(mnemonic);

    // String theEntropy = bip39.mnemonicToEntropy(mnemonic);
   // print("the entropy >>");
   //  print(theEntropy);

// ///testtttt
//      Credentials credential = EthPrivateKey.fromHex(theEntropy);
//      var addd = await credential.extractAddress();
//
//     final credentials = await ethClient.credentialsFromPrivateKey(theEntropy);
//     final address = await credentials.extractAddress();
//
//     // var add = await credentials.extractAddress();
//     print("public address re extracted: " + address.hex);
//
//     print("public key from other one: " + addd.hex);
//
//


    BlocProvider.of<SignupBloc>(context).add(
      AttemptSignup(
          emailController.text.trim(),
          firstnameController.text.trim(),
          othernamesController.text.trim(),
          passwordController.text.trim(),
          publicAddress),
    );
  }

  navigateToLogin(context) {
    Navigator.push(
        context,
        MaterialPageRoute<SignupPage>(
          builder: (BuildContext context) => LoginPage(),
          fullscreenDialog: false,
        ));
  }
}
