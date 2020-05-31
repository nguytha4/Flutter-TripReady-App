import 'package:capstone/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone/screens/login_screen.dart';
import 'package:capstone/tripready.dart';

class MainScreen extends StatelessWidget {
  static const routeName = 'main_screen';

  Future<bool> isSignedIn() async {
    return (await FirebaseAuth.instance.currentUser()) != null;
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isSignedIn(),
      builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot) {
        // if the future hasn't completed
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        // skip login process if the user is signed in
        if (snapshot.data) {
          return MainLandingScreen();
        }

        return Scaffold(
            appBar: AppBar(title: Text("Trip Ready"), centerTitle: true),
            body: Login());
      },
    );
  }
}

class Login extends StatelessWidget {
  final logoutSnackBar = SnackBar(content: Text('Sucessfully logged out'));

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // if (ModalRoute.of(context).settings.arguments != null) {
        //   Scaffold.of(context).showSnackBar(logoutSnackBar);
        // }

        return Column(
          children: [
            Logo(),
            Text(
              "Trip Like Never Before",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontFamily: 'Sans-serif',
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 60),
            SizedBox(height: 120),
            _signInBtn(context),
            _createAccountBtn(context)
          ],
        );
      },
    );
  }

  Widget _signInBtn(BuildContext context) {
    return ButtonTheme(
        minWidth: 300,
        child: RaisedButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: Text('Sign in')));
  }

  Widget _createAccountBtn(BuildContext context) {
    return ButtonTheme(
        minWidth: 300,
        child: RaisedButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed(RegisterPage.routeName);
            },
            child: Text('Create Account')));
  }
}
