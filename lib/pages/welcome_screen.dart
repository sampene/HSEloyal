import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loyal/pages/signup.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/widgets/custom_appbar.dart';
import 'package:styled_text/styled_text.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColors.heavyblueblack
    ));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: ourCustomAppbar(),
      body: Column(
        children: [
          Image.asset("assets/girll.png"),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, bottom: 30),
              child: StyledText(
                text: '<boldgrey>Buy coffee, stay</boldgrey> '
                    '<br/><heavyblueblack>LOYAL</heavyblueblack>'
                    '<br/><boldgrey>earn points,</boldgrey>'
                    '<br/><boldgrey>spend points,</boldgrey>',
                styles: {
                  'boldgrey': TextStyle(
                      fontFamily: "Fatface",
                      fontSize: 25,
                      color: MyColors.boldgrey),
                  'heavyblueblack': TextStyle(
                      fontFamily: "Bebas",
                      fontSize: 95,
                      color: MyColors.heavyblueblack),
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Get started",
            style: TextStyle(fontFamily: "Fatface", fontSize: 17),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              navigateToMain(context);
            },
            child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
            backgroundColor: MyColors.heavyblueblack,
            elevation: 0,
          )
        ],
      ),
    );
  }

  navigateToMain(context) {
    Navigator.push(
        context,
        MaterialPageRoute<SignupPage>(
          builder: (BuildContext context) => SignupPage(),
          fullscreenDialog: false,
        ));
  }
}
