import 'package:capstone/tripready.dart';
import 'package:flutter/material.dart';

import 'wallet_screen.dart';

class DestinationScreen extends StatefulWidget {
  final DestinationModel destination;
  final PlanModel plan;

  DestinationScreen({this.destination, this.plan});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final _roundedLeft = BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25));
  final _roundedRight = BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25));

  Decoration buildContainerDecoration(Color color, BorderRadius borderRadius) {
    return BoxDecoration(
      color: color,
      boxShadow: [BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3))],
      borderRadius: borderRadius,
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
          children: [buildHeader(context), buildColumn(context)],
        ),
      ),
    );
  }

  Widget buildColumn(BuildContext context) {
    double paddingValue = MediaQuery.of(context).size.width * 0.15;

    var padRight = EdgeInsets.fromLTRB(0.0, 0.0, paddingValue, 18.0);
    var padLeft = EdgeInsets.fromLTRB(paddingValue, 0.0, 0, 18.0);

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Column(
          children:[
            Padding(
              padding: padRight,
              child: buildButton(
                  (_) => SitesFoodScreen(destination: widget.destination),
                  'Sites / Food',
                  Color(0xff7A66F1),
                  _roundedRight),
            ),
            Padding(
              padding: padLeft,
              child: buildButton(
                  (_) => TipsScreen(destination: widget.destination),
                  'Tips',
                  Color(0xffFFB805),
                  _roundedLeft),
            ),
            Padding(
              padding: padRight,
              child: buildButton(
                  (_) => ChecklistScreen(destination: widget.destination, planModel: widget.plan),
                  'Checklist',
                  Color(0xff2E5FEC),
                  _roundedRight),
            ),
            Padding(
              padding: padLeft,
              child: buildButton(
                  (_) => WalletScreen(
                        destination: widget.destination, plan: widget.plan,
                      ),
                  'Wallet',
                  Color(0xff2CCCB5),
                  _roundedLeft),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return ImageHeader(
        imageUrl: widget.destination.imageUrl, label: widget.destination.city);
  }

  Widget buildButton(WidgetBuilder screen, String label, Color color, BorderRadius borderRadius) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: screen,
            ));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: buildContainerDecoration(color, borderRadius),
        height: 75,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15.0,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
