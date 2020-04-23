import 'package:flutter/material.dart';
import 'package:capstone/screens/main_screen.dart';
import 'package:capstone/screens/login_screen.dart';
import 'package:capstone/screens/register_page.dart';


class App extends StatelessWidget {
  final String title;
  const App({Key key, this.title}) : super(key: key);

  static final routes = {
    MainScreen.routeName: (context) => MainScreen(),
    LoginScreen.routeName: (context) => LoginScreen(),
    RegisterPage.routeName: (context) => RegisterPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Ready',
      theme: ThemeData(
          primaryColor: Colors.blue, 
          ),
      routes: App.routes,
      initialRoute: MainScreen.routeName,
    );
  }
}
