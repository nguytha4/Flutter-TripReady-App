import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';


class AccomodationForm extends StatefulWidget {
  @override
  _AccomodationFormState createState() => _AccomodationFormState();
}

class _AccomodationFormState extends State<AccomodationForm> {
  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Upload Accomodation',
      child: Center(child: Text('Upload Accomodation Page'),),
    );
  }
}