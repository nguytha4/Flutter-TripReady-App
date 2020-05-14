import 'package:capstone/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone/screens/login_screen.dart';
import 'package:capstone/tripready.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String userId;
  @override
  void initState() {
    super.initState();
  
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
            if (userId != null) {
            _showSnackBar();
          } 
      });
  
    });
  }
  
  Widget build(BuildContext context) {
    setState(() {
      userId = ModalRoute.of(context).settings.arguments;
      print(userId.toString() + '1');
    });
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
       title: Text("Trip Ready"),
       centerTitle: true),
      body: buildMainScreen(context)
    );
  }

  Widget buildMainScreen(BuildContext context) {
    return Column(
      children: [Logo(), Text("Trip Like Never Before", style: TextStyle(color: Colors.blue, fontSize: 30, fontFamily: 'Sans-serif', fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),), SizedBox(height: 60), SizedBox(height: 120), signInBtn(context), createAccountBtn(context)],
    );
  }

  Widget signInBtn(BuildContext context) {
  return ButtonTheme(
    minWidth: 300,
    child:RaisedButton(
    color: Colors.blue,
    onPressed: () {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    },
    child: Text('Sign in')
  )
  );
  }

  // getUser() async {
  //     FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //     if (user == null) {
  //       userId = null; 
  //     } 
  //     setState(() {});
  //     // print(userId);
  // }

  _showSnackBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Sucessfully logged out'))));
  }

}



Widget createAccountBtn(BuildContext context) {
  return ButtonTheme(
    minWidth: 300,
    child:RaisedButton(
    color: Colors.white,
    onPressed: () {
      Navigator.of(context).pushNamed(RegisterPage.routeName);
    },
    child: Text('Create Account')
  )
  );
}

Widget guestBtn() {
  return ButtonTheme(
    minWidth: 300,
    child:RaisedButton(
    color: Colors.white,
    onPressed: () {},
    child: Text('Enter as a guest')
  )
  );
}





