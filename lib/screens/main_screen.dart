import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const routeName = 'main_screen';

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "Main Screen",
      child: Text('Hello World!'),
    );
  }
}



