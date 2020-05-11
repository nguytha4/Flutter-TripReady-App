import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';



class NewDestinationEntryScreen extends StatefulWidget {
  static const routeName = 'new_destination_entry_screen';

  @override
  _NewDestinationEntryScreenState createState() => _NewDestinationEntryScreenState();
}

class _NewDestinationEntryScreenState extends State<NewDestinationEntryScreen> {
  
  //Navigator.popAndPushNamed(context, MainLandingScreen.routeName);
  int selectitem = 1;

  Widget buildPickerItem(DocumentSnapshot snapshot)
  {
    var destination = Destination.fromSnapshot(snapshot);

    return Text(
          '${destination.country}: ${destination.city}',
          style: TextStyle(
          color: Colors.white, 
          fontSize: 20),
        );
  }

  @override
  Widget build(BuildContext context) {
    
    return CapstoneScaffold(
      title: 'New Destination Entry',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Expanded(
                child: StreamBuilder(
                  stream: Firestore.instance.collection('destination').orderBy('country').snapshots(),
                  builder: (context, snapshot) {
                    return CupertinoPicker(
                    magnification: 1.0,
                    backgroundColor: Colors.black87,
                    children: 
                      (snapshot.data.documents as List<DocumentSnapshot>)
                      .map((s) => buildPickerItem(s))
                      .toList(),
              itemExtent: 30, //height of each item
              looping: false,
              
              onSelectedItemChanged: (int index) {  
                    selectitem = index;
              },
              );
                  }
                ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 0.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  child: Text('Confirm'),
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 40.0,
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}

  