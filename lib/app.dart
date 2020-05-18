import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';




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
    WalletScreen.routeName: (context) => WalletScreen(),
    ChecklistScreen.routeName: (context) => ChecklistScreen()
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
