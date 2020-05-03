import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class PassportIDDetails extends StatefulWidget {
  @override
  _PassportIDDetailsState createState() => _PassportIDDetailsState();
}

class _PassportIDDetailsState extends State<PassportIDDetails> {
  @override
  Widget build(BuildContext context) {

    // Get details of entry the ListView tile selected
    final PassportID passportID = ModalRoute.of(context).settings.arguments;

    // Responsive design
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;

    return CapstoneScaffold(
      title: 'Passport / ID Details',
      child: SizedBox(
        height: pHeight * .7,
        width: pWidth * 1,
        child: Image.network('${passportID.imageURL}'),
      ),
    );
  }

  
}