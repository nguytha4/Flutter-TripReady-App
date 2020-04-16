import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const routeName = 'main_screen';

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "Trip Ready",
      child: buildMainScreen(),
  
    );
  }
  Widget buildMainScreen() {
    return Column(
      children: [logo(), Text("Catchy Text", style: TextStyle(fontSize: 30),), SizedBox(height: 60), SizedBox(height: 120), signInBtn(), createAccountBtn()],
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

Widget signInBtn() {
  return ButtonTheme(
    minWidth: 300,
    child:RaisedButton(
    color: Colors.blue,
    onPressed: () {},
    child: Text('Sign in')
  )
  );
}

Widget createAccountBtn() {
  return ButtonTheme(
    minWidth: 300,
    child:RaisedButton(
    color: Colors.white,
    onPressed: () {},
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





