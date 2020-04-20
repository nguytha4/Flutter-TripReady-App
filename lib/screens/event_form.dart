import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Upload Event',
      child: Center(child: Text('Upload Event Page'),),
    );
  }
}