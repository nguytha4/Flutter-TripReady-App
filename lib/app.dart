import 'package:capstone/screens/main_landing_screen.dart';
import 'package:capstone/screens/new_destination_entry_screen.dart';
import 'package:capstone/screens/sites_food_detail_screen.dart';
import 'package:capstone/screens/sites_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screens/login_screen.dart';
import 'package:capstone/screens/register_page.dart';
import 'package:capstone/screens/main_screen.dart';

import 'screens/wallet_screen.dart';



class App extends StatelessWidget {
  final String title;
  const App({Key key, this.title}) : super(key: key);

  static final routes = {
    MainLandingScreen.routeName: (context) => MainLandingScreen(),
    NewDestinationEntryScreen.routeName: (context) => NewDestinationEntryScreen(),
    SitesFoodScreen.routeName: (context) => SitesFoodScreen(),
    SitesFoodDetailScreen.routeName: (context) => SitesFoodDetailScreen(),
    LoginScreen.routeName: (context) => LoginScreen(),
    RegisterPage.routeName: (context) => RegisterPage(),
    MainScreen.routeName: (context) => MainScreen(),
    WalletScreen.routeName: (context) => WalletScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Ready',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white
        ),
      routes: App.routes,
      initialRoute: MainScreen.routeName,
    );
  }
}
