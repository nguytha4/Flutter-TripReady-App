import 'package:capstone/screens/sites_food_detail_screen.dart';
import 'package:capstone/screens/sites_food_screen.dart';
import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:capstone/widgets/image_header.dart';
import 'package:flutter/material.dart';
import 'package:capstone/models/destination_model.dart';

import 'wallet_screen.dart';

class DestinationScreen extends StatefulWidget {
  final Destination destination;

  DestinationScreen({this.destination});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  Decoration buildBorder(Color color) {
    return BoxDecoration(
        border: Border.all(
      color: color,
      width: 3.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "",
      hideAppBar: true,
      child: Column(
        children: [
          buildHeader(context),
          buildGrid(context)
        ],
      ),
    );
  }

  Container buildGrid(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          physics: new NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          children: [
            buildButton(SitesFoodDetailScreen.routeName, 'Sites / Food'),
            buildButton(SitesFoodDetailScreen.routeName, 'Tips'),
            buildButton(SitesFoodDetailScreen.routeName, 'Items Checklist'),
            buildButton(WalletScreen.routeName, 'Wallet'),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return ImageHeader(imageUrl: widget.destination.imageUrl, label: widget.destination.city);
  }

  Widget buildButton(String routeName, String label) {
    return GestureDetector(
      onTap: () {
        return Navigator.pushNamed(context, routeName);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: buildBorder(Colors.black),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 15.0,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

