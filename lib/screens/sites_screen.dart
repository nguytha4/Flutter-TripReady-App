import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:capstone/widgets/destination_carousel.dart';
import 'package:flutter/material.dart';
import 'package:capstone/models/destination_model.dart';

class SitesScreen extends StatefulWidget {
  final Destination destination;

  SitesScreen({this.destination});

  @override
  _SitesScreenState createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  List<bool> isSelected;

  @override
    void initState() {
        isSelected = [true, false, false];
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: '${this.widget.destination.city} - Sites / Food',
      hideAppBar: false,
      fab: addEntryFab(context),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ToggleButtons (
                borderRadius: BorderRadius.circular(8),
                borderWidth: 2,
                fillColor: Colors.blue[300],
                selectedColor: Colors.white,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: (MediaQuery.of(context).size.width - 36) / 3,
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sites",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                  )), 
                  Container(
                    alignment: Alignment.center,
                    width: (MediaQuery.of(context).size.width - 36) / 3,
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Food",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                  )), 
                  Container(
                    alignment: Alignment.center,
                    width: (MediaQuery.of(context).size.width - 36) / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Favorites",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        )),
                    ),
                  )
                ],
                onPressed: (int index) {
                  setState(() {
                    for(int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
              )
            ]),
            SizedBox(height: 10.0),
            Expanded(child: DestinationCarousel()),
          ],
        ),
    );
  }
  Widget addEntryFab(BuildContext context) {
    return Semantics(
      button: true,
      onTapHint: 'Add a new destination',
      child: FloatingActionButton(
        key: Key('new'),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[300],
        onPressed: () {
          displayNewEntryForm(context);
        })
    );
  }
  void displayNewEntryForm(BuildContext context) {
    //  Navigator.pushNamed(context, NewDestinationEntryScreen.routeName);
  }
}