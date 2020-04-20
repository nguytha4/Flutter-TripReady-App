import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class WalletDetailsScreen extends StatefulWidget {
  @override
  _WalletDetailsScreenState createState() => _WalletDetailsScreenState();
}

class _WalletDetailsScreenState extends State<WalletDetailsScreen> {
  @override
  Widget build(BuildContext context) {

    // Get details of entry the ListView tile selected
    final PassportID passportID = ModalRoute.of(context).settings.arguments;

    // Responsive design
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;

    return CapstoneScaffold(
      title: 'Wallet Screen Details',
      child: SizedBox(
        height: pHeight * .7,
        width: pWidth * 1,
        child: Image.network('${passportID.imageURL}'),
      ),
    );
  }

  
}