import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class TransitForm extends StatefulWidget {
  @override
  _TransitFormState createState() => _TransitFormState();
}

class _TransitFormState extends State<TransitForm> {
  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Upload Transit',
      child: Center(child: Text('Upload Transit Page'),),
    );
  }
}