import 'package:capstone/screens/sites_screen.dart';
import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:capstone/models/destination_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    var sitesRoute = MaterialPageRoute(
      builder: (_) => SitesScreen(
        destination: this.widget.destination,
      ),
    );

    return CapstoneScaffold(
      title: "",
      hideAppBar: true,
      child: Column(
        children: [
          buildHeader(context),
          buildGrid(context, sitesRoute)
        ],
      ),
    );
  }

  Container buildGrid(BuildContext context, MaterialPageRoute sitesRoute) {
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
                buildButton(sitesRoute, 'Sites / Food'),
                buildButton(sitesRoute, 'Tips'),
                buildButton(sitesRoute, 'Items Checklist'),
                buildButton(sitesRoute, 'Wallet'),
              ],
            ),
          ),
        );
  }

  ClipRRect buildHeader(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Hero(
                  tag: widget.destination.imageUrl,
                  child: Image(
                    image: AssetImage(widget.destination.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Positioned(
                //left: 20.0,
                bottom: 0.0,
                child: Container(
                  color: Colors.black45,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destination.city,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Widget buildButton(Route route, String label) {
    return GestureDetector(
      onTap: () {
        return Navigator.push(context, route);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: buildBorder(Colors.black45),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
