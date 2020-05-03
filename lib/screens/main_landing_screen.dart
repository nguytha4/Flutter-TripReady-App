import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:capstone/widgets/destination_list.dart';
import 'package:flutter/material.dart';
import 'new_destination_entry_screen.dart';

class MainLandingScreen extends StatefulWidget {
  static const routeName = 'main_landing_screen';

  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  List<bool> isSelected;

  @override
    void initState() {
        isSelected = [true, false];
        super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Trips',
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
                fillColor: Colors.white,
                selectedBorderColor: Colors.black,
                selectedColor: Colors.black,
                color: Colors.grey,
                children: [
                  buildContainer(context, 'Upcoming'),
                  buildContainer(context, 'Past'),  
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
            Expanded(child: DestinationList()),
          ],
        ),
    );
  }

  Container buildContainer(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      width: (MediaQuery.of(context).size.width - 36) / 2,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        )),
    ));
  }

  Widget addEntryFab(BuildContext context) {
    return Semantics(
      button: true,
      onTapHint: 'Add a new destination',
      child: FloatingActionButton(
        key: Key('new'),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () {
          displayNewEntryForm(context);
        })
    );
  }

  void displayNewEntryForm(BuildContext context) {
    Navigator.pushNamed(context, NewDestinationEntryScreen.routeName);
  }
}



