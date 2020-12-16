import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/blocs/restaurants/restaurants_bloc.dart';
import 'package:loyal/blocs/signup/signup_bloc.dart';
import 'package:loyal/blocs/userinfo/user_info_bloc.dart';
import 'package:loyal/network/api.dart';
import 'package:loyal/pages/home.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/welcome_screen.dart';

SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //needed because i initialise stuff before runapp
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp());
}
LoginBloc _loginbloc = LoginBloc(AppAPI());
SignupBloc _signupbloc = SignupBloc(AppAPI());
UserInfoBloc _userinfobloc = UserInfoBloc(AppAPI());
RestaurantsBloc _restobloc = RestaurantsBloc(AppAPI());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => _loginbloc),
        BlocProvider<SignupBloc>(create: (BuildContext context) => _signupbloc),
        BlocProvider<UserInfoBloc>(create: (BuildContext context) => _userinfobloc),
        BlocProvider<RestaurantsBloc>(create: (BuildContext context) => _restobloc..add(FetchRestaurants())),
      ],
      child: MaterialApp(
        title: 'Loyal',
        home: _getHome(),
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: MyColors.heavyblueblack,
            accentColor: MyColors.accentColor,

          )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}

Widget _getHome() {
  // return SidebarPage();
  bool firstTime = sharedPreferences.getBool(Keys.FIRST_TIME);

  if (firstTime != null) {
    //has been here before, so check if first time is true or false
    if (firstTime) {
      //firsttime is true,  take them to the welcome screen
      setNotFirstTime();
      return WelcomeScreen();
    } else {
      //not first time. Take them to where they should go
      return HomePage(sharedPreferences.getString(Keys.USER_ID));
    }
  } else {
    setNotFirstTime();
    return WelcomeScreen();
  }
}

Future<void> setNotFirstTime() async {
  await sharedPreferences.setBool(Keys.FIRST_TIME, false);
}
