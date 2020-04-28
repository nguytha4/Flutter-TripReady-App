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

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "",
      hideAppBar: true,
      child: Column(
        children: [
          Stack(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image(
                      image: AssetImage(widget.destination.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
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
                left: 20.0,
                bottom: 10.0,
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
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SitesScreen(
                        destination: this.widget.destination,
                        ),
                      )),
                      child: Container(
                      color: Colors.red,
                      alignment: Alignment.bottomCenter,
                      child: 
                      Column(
                        children: [ 
                          Icon(
                            Icons.account_balance,
                            size: 30.0,
                            color: Colors.black,
                            //onPressed: () => Navigator.pop(context),
                          ),
                          Icon(
                            Icons.fastfood,
                            size: 30.0,
                            color: Colors.black,
                          ),
                          Text(
                          'Sites / Food',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            letterSpacing: 1.2,
                          ),
                        )],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    alignment: Alignment.bottomCenter,
                    child: 
                    Column(
                      children: [ 
                        IconButton(
                          icon: Icon(Icons.lightbulb_outline),
                          iconSize: 30.0,
                          color: Colors.black,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                        'Tips',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          letterSpacing: 1.2,
                        ),
                      )],
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    alignment: Alignment.bottomCenter,
                    child: 
                    Column(
                      children: [ 
                        IconButton(
                          icon: Icon(Icons.check_box),
                          iconSize: 30.0,
                          color: Colors.black,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                        'Items Checklist',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          letterSpacing: 1.2,
                        ),
                      )],
                    ),
                  ),
                  Container(
                    color: Colors.green,
                    alignment: Alignment.bottomCenter,
                    child: 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [ 
                        IconButton(
                          icon: Icon(Icons.account_balance_wallet),
                          iconSize: 70.0,
                          color: Colors.black,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                        'Wallet',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          letterSpacing: 1.2,
                        ),
                      )],
                    ),
                  ),
                ],
              ),
            ),
          )
          ],
          ),

    );
  }
}
