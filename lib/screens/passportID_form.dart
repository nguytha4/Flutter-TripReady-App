import 'package:flutter/material.dart';

class PassportIDForm extends StatefulWidget {
  @override
  _PassportIDFormState createState() => _PassportIDFormState();
}

class _PassportIDFormState extends State<PassportIDForm> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Screen'),
        centerTitle: true,
      ),
      body: Center(child: const Text('Passport / ID Forms Page!')),
    );
  }
}