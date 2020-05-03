import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone/widgets/capstone_scaffold.dart';


class NewDestinationEntryScreen extends StatefulWidget {
  static const routeName = 'new_destination_entry_screen';

  @override
  _NewDestinationEntryScreenState createState() => _NewDestinationEntryScreenState();
}

class _NewDestinationEntryScreenState extends State<NewDestinationEntryScreen> {
  
  //Navigator.popAndPushNamed(context, MainLandingScreen.routeName);
  int selectitem = 1;

  @override
  Widget build(BuildContext context) {
    
    return CapstoneScaffold(
      title: 'New Destination Entry',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 700.0,
            child: CupertinoPicker(
              magnification: 1.0,
              backgroundColor: Colors.black87,
              children:[
                Text(
                  'City Name',
                  style: TextStyle(
                  color: Colors.white, 
                  fontSize: 20),
                ),
              ],
            itemExtent: 30, //height of each item
            looping: true,
            
            onSelectedItemChanged: (int index) {  
              selectitem = index;
            },
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 30.0,
                  ),
                ),
                CupertinoButton(
                  child: Text('Confirm'),
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 30.0,
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

  