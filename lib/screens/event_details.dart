import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
     
    // Get details of the event ListView tile selected
    final Event event = ModalRoute.of(context).settings.arguments;

    return CapstoneScaffold(
      title: 'Event Details',
      child: Column(
        children: <Widget>[
          eventLine("Name", event.name, Colors.purple, Icons.home),
          eventLine("Phone Number", event.phoneNum, Colors.green, Icons.phone),
          eventLine("Email", event.email, Colors.blue, Icons.email),
          eventLine("Address", event.address, Colors.red, Icons.location_on),
          eventLine("Confirmation Number", event.confirmNum, Colors.brown, Icons.confirmation_number),
          eventLine("Check-in Date", DateFormat('MM-dd-yyyy').format(event.startDateTime), Colors.blue, Icons.calendar_today),
          eventLine("Check-in Time", DateFormat('hh:mm aa').format(event.startDateTime), Colors.red, Icons.access_time)
        ],
      ),
    );
  }

  // =========================================== Widget Functions ===========================================

  Widget eventLine(String label, String labelField, MaterialColor customColor, IconData customIcon) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            customIcon,
            color: customColor,
            size: 40,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                "$label",
                style: TextStyle(
                  color: Colors.blueGrey, 
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 84),
              child: Text(
                "$labelField",
                style: TextStyle(
                  fontSize: 22, 
                ),
              ),
            ),
          ],
        ),
        ],
      )
    );
  }

}