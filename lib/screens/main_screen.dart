import 'package:flutter/material.dart';
import 'package:capstone/screens/login_screen.dart';
import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:capstone/screens/register_page.dart';

class MainScreen extends StatelessWidget {
  static const routeName = 'main_screen';

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "Trip Ready",
      child: buildMainScreen(context),
  
    );
  }
  Widget buildMainScreen(BuildContext context) {
    return Column(
      children: [logo(), Text("Catchy Placeholder Text", style: TextStyle(fontSize: 30),), SizedBox(height: 60), SizedBox(height: 120), signInBtn(context), createAccountBtn(context)],
    );
  }

  Widget signInBtn(BuildContext context) {
  return ButtonTheme(
    minWidth: 300,
    child:RaisedButton(
    color: Colors.blue,
    onPressed: () {
      Navigator.of(context).pushNamed(SignInPage.routeName);
    },
    child: Text('Sign in')
  )
  );
}
}

Widget logo() {
  return Align(
    alignment: Alignment.center,
    child: Container(
    height: 200,
    width: 200,
    child: Image.asset('assets/images/logo.png')
  )
  ); 
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





