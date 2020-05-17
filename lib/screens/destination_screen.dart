import 'package:capstone/tripready.dart';
import 'package:flutter/material.dart';


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
      title: '${this.widget.destination.country}',
      child: SingleChildScrollView(
              child: Column(
          children: [
            buildHeader(context),
            buildGrid(context)
          ],
        ),
      ),
    );
  }

  Widget buildGrid(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width,
        child: Padding(
    padding: const EdgeInsets.all(30.0),
    child: GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: const EdgeInsets.all(10.0),
      children: [
        buildButton((_) => SitesFoodScreen(destination:widget.destination), 'Sites / Food', Colors.green),
        buildButton((_) => SitesFoodScreen(destination:widget.destination), 'Tips', Colors.orange),
        buildButton((_) => SitesFoodScreen(destination:widget.destination), 'Items Checklist', Colors.red),
        buildButton((_) => WalletScreen(), 'Wallet', Colors.purple),
      ],
    ),
        ),
      );
  }

  Widget buildHeader(BuildContext context) {
    return ImageHeader(imageUrl: widget.destination.imageUrl, label: widget.destination.city);
  }

  Widget buildButton(WidgetBuilder screen, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: screen,
              ));
        //return Navigator.pushNamed(context, routeName);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: buildBorder(color),
        height: 75,
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

