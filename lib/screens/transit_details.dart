import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:intl/intl.dart';

class TransitDetails extends StatefulWidget {
  @override
  _TransitDetailsState createState() => _TransitDetailsState();
}

class _TransitDetailsState extends State<TransitDetails> {
  @override
  Widget build(BuildContext context) {

    // Get details of the transit ListView tile selected
    final Transit transit = ModalRoute.of(context).settings.arguments;

    return CapstoneScaffold(
      title: 'Transit Details',
      child: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            transitLine("Name", transit.name, Colors.purple, Icons.flight),
            transitLine("Start Location", transit.startLocation, Colors.blue, Icons.my_location),
            transitLine("Destination", transit.destination, Colors.red, Icons.location_on),
            transitLine("Confirmation Number", transit.confirmNum, Colors.brown, Icons.confirmation_number),
            transitLine("Departure Date", DateFormat('MM-dd-yyyy').format(transit.departDateTime), Colors.blue, Icons.calendar_today),
            transitLine("Departure Time", DateFormat('hh:mm aa').format(transit.departDateTime), Colors.red, Icons.access_time),
            transitLine("Arrival Date", DateFormat('MM-dd-yyyy').format(transit.arriveDateTime), Colors.blue, Icons.calendar_today),
            transitLine("Arrival Time", DateFormat('hh:mm aa').format(transit.arriveDateTime), Colors.red, Icons.access_time),
          ],
        ),
      ),
    );
  }

  // =========================================== Widget Functions ===========================================

  Widget transitLine(String label, String labelField, MaterialColor customColor, IconData customIcon) {
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