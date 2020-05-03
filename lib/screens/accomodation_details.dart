import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:intl/intl.dart';

class AccomodationDetails extends StatefulWidget {
  @override
  _AccomodationDetailsState createState() => _AccomodationDetailsState();
}

class _AccomodationDetailsState extends State<AccomodationDetails> {
  @override
  Widget build(BuildContext context) {

    // Get details of the accomodation ListView tile selected
    final Accomodation accomodation = ModalRoute.of(context).settings.arguments;

    return CapstoneScaffold(
      title: 'Accomodation Details',
      child: Column(
        children: <Widget>[
          accomodationLine("Name", accomodation.name, Colors.purple, Icons.home),
          accomodationLine("Phone Number", accomodation.phoneNum, Colors.green, Icons.phone),
          accomodationLine("Email", accomodation.email, Colors.blue, Icons.email),
          accomodationLine("Address", accomodation.address, Colors.red, Icons.location_on),
          accomodationLine("Confirmation Number", accomodation.confirmNum, Colors.brown, Icons.confirmation_number),
          accomodationLine("Check-in Date", DateFormat('MM-dd-yyyy').format(accomodation.checkInDateTime), Colors.blue, Icons.calendar_today),
          accomodationLine("Check-out Date", DateFormat('MM-dd-yyyy').format(accomodation.checkOutDateTime), Colors.red, Icons.calendar_today),
        ],
      ),
    );
  }

  // ===========================================  Widget Functions ===========================================

  Widget accomodationLine(String label, String labelField, MaterialColor customColor, IconData customIcon) {
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